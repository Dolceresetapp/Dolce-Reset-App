import { headers } from "next/headers"
import { Webhook } from "svix"

import { createClient } from "@supabase/supabase-js";

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL as string;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY as string;
const supabaseServiceKey = process.env.NEXT_PUBLIC_SERVICE_ROLE_KEY as string;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);


export async function POST(req: Request) {
  const WEBHOOK_SECRET = process.env.CLERK_WEBHOOK_SECRET

  if (!WEBHOOK_SECRET) {
    throw new Error("Please add CLERK_WEBHOOK_SECRET from Clerk Dashboard to .env or .env.local")
  }

  // Get the headers
  const headerPayload = headers()
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

    try {
      const { error } = await supabase.from("users").insert({
        clerk_user_id: id,
        email: email_addresses[0]?.email_address,
        first_name: first_name,
        last_name: last_name,
        profile_image_url: image_url,
      })

      if (error) {
        console.error("Error creating user in Supabase:", error)
        return new Response("Error creating user", { status: 500 })
      }

      console.log("User created successfully in Supabase")
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
