import { type NextRequest, NextResponse } from "next/server"
import Stripe from "stripe"
import { createClient } from "@supabase/supabase-js"

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!)

const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!)

const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET!

export async function POST(req: NextRequest) {
  const body = await req.text()
  const sig = req.headers.get("stripe-signature")!

  let event: Stripe.Event

  try {
    event = stripe.webhooks.constructEvent(body, sig, endpointSecret)
  } catch (err) {
    console.error("Webhook signature verification failed:", err)
    return NextResponse.json({ error: "Invalid signature" }, { status: 400 })
  }

  try {
    switch (event.type) {
      case "checkout.session.completed": {
        const session = event.data.object as Stripe.Checkout.Session

        // Get customer email and subscription details
        const customerEmail = session.customer_email || session.metadata?.email
        const subscriptionId = session.subscription as string

        if (customerEmail && subscriptionId) {
          // Get subscription details
          const subscription = await stripe.subscriptions.retrieve(subscriptionId)

          // Save subscription data to database
          const { error } = await supabase.from("subscriptions").upsert({
            email: customerEmail,
            stripe_customer_id: session.customer,
            stripe_subscription_id: subscriptionId,
            status: subscription.status,
            current_period_start: new Date(subscription.current_period_start * 1000),
            current_period_end: new Date(subscription.current_period_end * 1000),
            trial_end: subscription.trial_end ? new Date(subscription.trial_end * 1000) : null,
            created_at: new Date(),
            updated_at: new Date(),
          })

          if (error) {
            console.error("Error saving subscription:", error)
          } else {
            console.log("Subscription saved successfully for email:", customerEmail)
          }
        }
        break
      }

      case "customer.subscription.updated": {
        const subscription = event.data.object as Stripe.Subscription

        // Get customer details
        const customer = await stripe.customers.retrieve(subscription.customer as string)
        const customerEmail = (customer as Stripe.Customer).email

        if (customerEmail) {
          // Update subscription status
          const { error } = await supabase
            .from("subscriptions")
            .update({
              status: subscription.status,
              current_period_start: new Date(subscription.current_period_start * 1000),
              current_period_end: new Date(subscription.current_period_end * 1000),
              trial_end: subscription.trial_end ? new Date(subscription.trial_end * 1000) : null,
              updated_at: new Date(),
            })
            .eq("stripe_subscription_id", subscription.id)

          if (error) {
            console.error("Error updating subscription:", error)
          }
        }
        break
      }

      case "customer.subscription.deleted": {
        const subscription = event.data.object as Stripe.Subscription

        // Update subscription status to cancelled
        const { error } = await supabase
          .from("subscriptions")
          .update({
            status: "cancelled",
            updated_at: new Date(),
          })
          .eq("stripe_subscription_id", subscription.id)

        if (error) {
          console.error("Error cancelling subscription:", error)
        }
        break
      }

      default:
        console.log(`Unhandled event type: ${event.type}`)
    }

    return NextResponse.json({ received: true })
  } catch (error) {
    console.error("Error processing webhook:", error)
    return NextResponse.json({ error: "Webhook processing failed" }, { status: 500 })
  }
}
