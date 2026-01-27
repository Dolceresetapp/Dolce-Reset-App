import { headers } from "next/headers"
import { Webhook } from "svix"
import { createClient } from "@supabase/supabase-js"

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL as string
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY as string

export const supabase = createClient(supabaseUrl, supabaseServiceKey)

export async function POST(req: Request) {
  const WEBHOOK_SECRET = process.env.CLERK_WEBHOOK_SECRET

  if (!WEBHOOK_SECRET) {
    throw new Error("Please add CLERK_WEBHOOK_SECRET from Clerk Dashboard to .env or .env.local")
  }

  // Get the headers
  const headerPayload = await headers()
  const svix_id = headerPayload.get("svix-id")
  const svix_timestamp = headerPayload.get("svix-timestamp")
  const svix_signature = headerPayload.get("svix-signature")

  // If there are no headers, error out
  if (!svix_id || !svix_timestamp || !svix_signature) {
    return new Response("Error occured -- no svix headers", {
      status: 400,
    })
  }

  // Get the body
  const payload = await req.json()
  const body = JSON.stringify(payload)

  // Create a new Svix instance with your secret.
  const wh = new Webhook(WEBHOOK_SECRET)

  let evt: any

  // Verify the payload with the headers
  try {
    evt = wh.verify(body, {
      "svix-id": svix_id,
      "svix-timestamp": svix_timestamp,
      "svix-signature": svix_signature,
    }) as any
  } catch (err) {
    console.error("Error verifying webhook:", err)
    return new Response("Error occured", {
      status: 400,
    })
  }

  // Handle the webhook
  const eventType = evt.type

  if (eventType === "user.created") {
    const { id, email_addresses, first_name, last_name, image_url } = evt.data
    const email = email_addresses[0]?.email_address

    try {
      // Create user in database
      const { data: user, error: userError } = await supabase.from("users").insert({
        clerk_user_id: id,
        email: email,
        first_name: first_name,
        last_name: last_name,
        profile_image_url: image_url,
      }).select("*").single()

      if (userError) {
        console.error("Error creating user in Supabase:", userError)
        return new Response("Error creating user", { status: 500 })
      }

      console.log("User created successfully in Supabase")

      // Check if user has existing subscription and link it
      if (email) {
        const { data: subscription, error: subError } = await supabase
          .from("subscriptions")
          .select("*")
          .eq("email", email)
          .is("user_id", null)
          .single()

        if (subscription && !subError) {
          // Link subscription to user
          const { error: linkError } = await supabase
            .from("subscriptions")
            .update({ updated_at: new Date().toISOString() })
            .eq("id", subscription.id)

          if (linkError) {
            console.error("Error linking subscription to user:", linkError)
          } else {
            console.log("Successfully linked subscription to user:", id)

            // Update user with subscription status
            const hasActiveSubscription =
              (subscription.status === "active" || subscription.status === "trialing") &&
              new Date(subscription.current_period_end) > new Date()

            if (hasActiveSubscription) {
              const { error: updateError } = await supabase
                .from("users")
                .update({
                  subscription_status: subscription.status || "active",
                  is_premium: true,
                  updated_at: new Date().toISOString(),
                })
                .eq("clerk_user_id", id)

              if (updateError) {
                console.error("Error updating user subscription status:", updateError)
              } else {
                console.log("User subscription status updated successfully")
              }
            }
          }
        } else {
          console.log("No existing subscription found for email:", email)
        }
      }
    } catch (error) {
      console.error("Error in user creation:", error)
      return new Response("Error creating user", { status: 500 })
    }
  }

  if (eventType === "user.updated") {
    const { id, email_addresses, first_name, last_name, image_url } = evt.data

    try {
      const { error } = await supabase
        .from("users")
        .update({
          email: email_addresses[0]?.email_address,
          first_name: first_name,
          last_name: last_name,
          profile_image_url: image_url,
          updated_at: new Date().toISOString(),
        })
        .eq("clerk_user_id", id)

      if (error) {
        console.error("Error updating user in Supabase:", error)
        return new Response("Error updating user", { status: 500 })
      }

      console.log("User updated successfully in Supabase")
    } catch (error) {
      console.error("Error in user update:", error)
      return new Response("Error updating user", { status: 500 })
    }
  }

  if (eventType === "user.deleted") {
    const { id } = evt.data

    try {
      const { error } = await supabase.from("users").delete().eq("clerk_user_id", id)

      if (error) {
        console.error("Error deleting user from Supabase:", error)
        return new Response("Error deleting user", { status: 500 })
      }

      console.log("User deleted successfully from Supabase")
    } catch (error) {
      console.error("Error in user deletion:", error)
      return new Response("Error deleting user", { status: 500 })
    }
  }

  return new Response("", { status: 200 })
}
