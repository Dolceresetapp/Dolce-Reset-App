// pages/api/create-setup-intent.ts
import { NextRequest, NextResponse } from "next/server";
import Stripe from "stripe";

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!, { apiVersion: "2025-07-30.basil" });

export async function POST(req: NextRequest) {
  try {
    const { email } = await req.json();

    // Create or get a customer
    const customers = await stripe.customers.list({ email });
    let customer = customers.data[0];
    if (!customer) {
      customer = await stripe.customers.create({ email });
    }

    // Create a SetupIntent
    const setupIntent = await stripe.setupIntents.create({
      customer: customer.id,
      // payment_method_types: ["card"],
    });

    return NextResponse.json({
      client_secret: setupIntent.client_secret,
      customer_id: customer.id
    });
  } catch (err: any) {
    console.error(err);
    return NextResponse.json({ error: err.message }, { status: 500 });
  }
}
