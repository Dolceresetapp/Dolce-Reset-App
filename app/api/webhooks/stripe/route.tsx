import { createClient } from "@supabase/supabase-js";
import { headers } from "next/headers"
import { type NextRequest, NextResponse } from "next/server"
import Stripe from "stripe"


const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL as string;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY as string;
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY as string;

export const supabase = createClient(supabaseUrl, supabaseServiceKey);

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, {
  apiVersion: "2025-07-30.basil",
})

const endpointSecret = process.env.STRIPE_WEBHOOK_SECRET!

export async function POST(req: NextRequest) {
  const body = await req.text()
  const headersList = await headers()
  const sig = headersList.get("stripe-signature")!

  let event: Stripe.Event

  try {
    event = stripe.webhooks.constructEvent(body, sig, endpointSecret)
  } catch (err: any) {
    console.error(`Webhook signature verification failed.`, err.message)
    return NextResponse.json({ error: "Webhook signature verification failed" }, { status: 400 })
  }

  try {
    switch (event.type) {
      case "customer.subscription.created":
      case "customer.subscription.updated": {
        const subscription = event.data.object as Stripe.Subscription

        // Get customer details
        const customer = await stripe.customers.retrieve(subscription.customer as string)
        if (!customer || customer.deleted) {
          throw new Error("Customer not found")
        }

        // Find user by email
        const { data: user, error: userError } = await supabase
          .from("users")
          .select("id")
          .eq("email", (customer as Stripe.Customer).email)
          .single()

        if (userError || !user) {
          console.error("User not found for email:", (customer as Stripe.Customer).email)
          break
        }

        // Upsert subscription
        const { error: subError } = await supabase.from("user_subscriptions").upsert({
          user_id: user.id,
          stripe_customer_id: subscription.customer as string,
          stripe_subscription_id: subscription.id,
          stripe_price_id: subscription.items.data[0]?.price.id,
          status: subscription.status,
          current_period_start: new Date(subscription.current_period_start * 1000).toISOString(),
          current_period_end: new Date(subscription.current_period_end * 1000).toISOString(),
          cancel_at_period_end: subscription.cancel_at_period_end,
        })

        if (subError) {
          console.error("Error upserting subscription:", subError)
          break
        }

        // Update user premium status
        const isPremium = subscription.status === "active" || subscription.status === "trialing"
        const { error: updateError } = await supabase
          .from("users")
          .update({
            is_premium: isPremium,
            subscription_status: subscription.status,
            subscription_id: subscription.id,
          })
          .eq("id", user.id)

        if (updateError) {
          console.error("Error updating user premium status:", updateError)
        }

        console.log(`Subscription ${subscription.status} for user ${user.id}`)
        break
      }

      case "customer.subscription.deleted": {
        const subscription = event.data.object as Stripe.Subscription

        // Update subscription status
        const { error: subError } = await supabase
          .from("user_subscriptions")
          .update({
            status: "canceled",
            cancel_at_period_end: true,
          })
          .eq("stripe_subscription_id", subscription.id)

        if (subError) {
          console.error("Error updating canceled subscription:", subError)
          break
        }

        // Update user premium status
        const { data: userSub } = await supabase
          .from("user_subscriptions")
          .select("user_id")
          .eq("stripe_subscription_id", subscription.id)
          .single()

        if (userSub) {
          const { error: updateError } = await supabase
            .from("users")
            .update({
              is_premium: false,
              subscription_status: "cancelled",
            })
            .eq("id", userSub.user_id)

          if (updateError) {
            console.error("Error updating user after cancellation:", updateError)
          }
        }

        console.log(`Subscription canceled for subscription ${subscription.id}`)
        break
      }

      case "invoice.payment_succeeded": {
        const invoice = event.data.object as Stripe.Invoice

        if (invoice.subscription) {
          // Get subscription details
          const subscription = await stripe.subscriptions.retrieve(invoice.subscription as string)
          const customer = await stripe.customers.retrieve(subscription.customer as string)

          if (!customer || customer.deleted) break

          // Find user
          const { data: user } = await supabase
            .from("users")
            .select("id")
            .eq("email", (customer as Stripe.Customer).email)
            .single()

          if (!user) break

          // Record payment
          const { error: paymentError } = await supabase.from("payment_history").insert({
            user_id: user.id,
            stripe_payment_intent_id: invoice.payment_intent as string,
            amount: invoice.amount_paid,
            currency: invoice.currency,
            status: "succeeded",
            description: invoice.description || "Premium subscription payment",
          })

          if (paymentError) {
            console.error("Error recording payment:", paymentError)
          }

          console.log(`Payment succeeded for user ${user.id}, amount: ${invoice.amount_paid}`)
        }
        break
      }

      case "invoice.payment_failed": {
        const invoice = event.data.object as Stripe.Invoice

        if (invoice.subscription) {
          const subscription = await stripe.subscriptions.retrieve(invoice.subscription as string)
          const customer = await stripe.customers.retrieve(subscription.customer as string)

          if (!customer || customer.deleted) break

          const { data: user } = await supabase
            .from("users")
            .select("id")
            .eq("email", (customer as Stripe.Customer).email)
            .single()

          if (!user) break

          // Record failed payment
          const { error: paymentError } = await supabase.from("payment_history").insert({
            user_id: user.id,
            stripe_payment_intent_id: invoice.payment_intent as string,
            amount: invoice.amount_due,
            currency: invoice.currency,
            status: "failed",
            description: "Failed premium subscription payment",
          })

          if (paymentError) {
            console.error("Error recording failed payment:", paymentError)
          }

          console.log(`Payment failed for user ${user.id}`)
        }
        break
      }

      default:
        console.log(`Unhandled event type ${event.type}`)
    }
  } catch (error) {
    console.error("Error processing webhook:", error)
    return NextResponse.json({ error: "Webhook processing failed" }, { status: 500 })
  }

  return NextResponse.json({ received: true })
}
