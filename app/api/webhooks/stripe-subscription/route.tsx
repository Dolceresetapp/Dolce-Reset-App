import { headers } from "next/headers"
import { NextResponse } from "next/server"
import Stripe from "stripe"
import { createClient } from "@supabase/supabase-js"

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!)
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient(supabaseUrl, supabaseServiceKey)

export async function POST(req: Request) {
  const body = await req.text()
  const signature = headers().get("Stripe-Signature") as string

  let event: Stripe.Event

  try {
    event = stripe.webhooks.constructEvent(body, signature, process.env.STRIPE_WEBHOOK_SECRET!)
  } catch (err: any) {
    console.error(`Webhook signature verification failed.`, err.message)
    return NextResponse.json({ error: "Webhook signature verification failed" }, { status: 400 })
  }

  console.log("Received Stripe webhook:", event.type)

  try {
    const now = new Date()
    const oneMonthLater = new Date()
    oneMonthLater.setMonth(now.getMonth() + 1)

    switch (event.type) {
      case "checkout.session.completed": {
        const session = event.data.object as Stripe.Checkout.Session
        console.log("Checkout session completed:", session.id)

        if (session.mode === "subscription" && session.subscription) {
          const subscription = await stripe.subscriptions.retrieve(session.subscription as string)
          const customer = await stripe.customers.retrieve(session.customer as string)

          const email = session.customer_email || (customer as Stripe.Customer).email

          if (email) {
            // Save subscription to database
            const { error } = await supabase.from("subscriptions").upsert({
              stripe_subscription_id: subscription.id,
              stripe_customer_id: subscription.customer as string,
              email: email,
              status: subscription.status,
              current_period_start: now.toISOString(),
              current_period_end: oneMonthLater.toISOString(),
              trial_end: subscription.trial_end ? new Date(subscription.trial_end * 1000).toISOString() : null,
              updated_at: new Date().toISOString(),
            })

            if (error) {
              console.error("Error saving subscription:", error)
            } else {
              console.log("Subscription saved successfully for email:", email)
            }
          }
        }
        break
      }

      case "customer.subscription.updated":
      case "customer.subscription.deleted": {
        const subscription = event.data.object as Stripe.Subscription
        console.log("Subscription updated/deleted:", subscription.id)

        const { error } = await supabase
          .from("subscriptions")
          .update({
            status: subscription.status,
            current_period_start: now.toISOString(),
            current_period_end: oneMonthLater.toISOString(),
            trial_end: subscription.trial_end ? new Date(subscription.trial_end * 1000).toISOString() : null,
            updated_at: new Date().toISOString(),
          })
          .eq("stripe_subscription_id", subscription.id)

        if (error) {
          console.error("Error updating subscription:", error)
        } else {
          console.log("Subscription updated successfully")
        }
        break
      }

      default:
        console.log(`Unhandled event type: ${event.type}`)
    }
  } catch (error) {
    console.error("Error processing webhook:", error)
    return NextResponse.json({ error: "Webhook processing failed" }, { status: 500 })
  }

  return NextResponse.json({ received: true })
}
