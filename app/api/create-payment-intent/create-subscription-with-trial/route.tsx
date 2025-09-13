import { NextRequest, NextResponse } from "next/server";
import Stripe from "stripe";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, { apiVersion: "2025-07-30.basil" });

export async function POST(req: NextRequest) {
  try {
    const priceId = process.env.NEXT_PUBLIC_STRIPE_PRICE_ID;
    const { customer_id, payment_method_id, trial_days } = await req.json();

    // Create subscription with trial using saved card
    const subscription = await stripe.subscriptions.create({
      customer: customer_id,
      items: [{ price: priceId }], // your recurring price ID
      default_payment_method: payment_method_id,
      trial_period_days: trial_days,
      expand: ["latest_invoice.payment_intent"]
    });

    return NextResponse.json({ subscription });
  } catch (err: any) {
    console.error(err);
    return NextResponse.json({ error: err.message }, { status: 500 });
  }
}
