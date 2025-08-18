import { type NextRequest, NextResponse } from "next/server"
import Stripe from "stripe"

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!)

export async function POST(req: NextRequest) {
  try {
    console.log("Received request to create checkout session")

    const { email, priceId = process.env.NEXT_PUBLIC_STRIPE_PRICE_ID } = await req.json()

    console.log("Email:", email)
    console.log("Price ID:", priceId)

    if (!email || !priceId) {
      console.error("Email and price ID are required")
      return NextResponse.json({ error: "Email and price ID are required" }, { status: 400 })
    }

    // Create Stripe checkout session with trial
    const session = await stripe.checkout.sessions.create({
      customer_email: email,
      payment_method_types: ["card"],
      mode: "subscription",
      line_items: [
        {
          price: priceId,
          quantity: 1,
        },
      ],
      subscription_data: {
        trial_period_days: 3, // 3-day free trial
        metadata: {
          source: "onboarding_flow",
          email: email,
        },
      },
      metadata: {
        email: email,
        source: "onboarding_flow",
      },
      success_url: `${process.env.NEXT_PUBLIC_APP_URL}/payment-success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.NEXT_PUBLIC_APP_URL}/onboarding`,
      allow_promotion_codes: true,
    })

    console.log("Checkout session created successfully")
    console.log("Checkout session URL:", session.url)

    return NextResponse.json({ url: session.url })
  } catch (error) {
    console.error("Error creating checkout session:", error)
    return NextResponse.json({ error: "Failed to create checkout session" }, { status: 500 })
  }
}
