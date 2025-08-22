import { type NextRequest, NextResponse } from "next/server"
import { currentUser } from "@clerk/nextjs/server"
import { createClient } from "@supabase/supabase-js"

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL as string
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY as string

export const supabase = createClient(supabaseUrl, supabaseServiceKey)


const Stripe = require("stripe")
const stripe = Stripe(process.env.STRIPE_SECRET_KEY)

export async function POST(request: NextRequest) {
  console.log("POST /api/stripe/create-portal-session")
  try {
    const user = await currentUser()
    console.log("user:", user)
    if (!user?.emailAddresses?.[0]?.emailAddress) {
      console.log("User not authenticated")
      return NextResponse.json({ error: "User not authenticated" , status: 401 })
    }

    const userEmail = user.emailAddresses[0].emailAddress
    console.log("userEmail:", userEmail)

    // Get customer ID
    const { data: packageData } = await supabase
      .from("subscriptions")
      .select("stripe_customer_id")
      .eq("email", userEmail)
      .single()

    console.log("packageData:", packageData)

    if (!packageData?.stripe_customer_id) {
      console.log("No customer found")
      return NextResponse.json({ error: "No customer found" , status: 404 })
    }

    // Create portal session
    const portalSession = await stripe.billingPortal.sessions.create({
      customer: packageData.stripe_customer_id,
      return_url: `${process.env.NEXT_PUBLIC_APP_URL}/features`,
    })

    console.log("portalSession:", portalSession)

    return NextResponse.json({ url: portalSession.url })
  } catch (error) {
    console.error("Error creating portal session:", error)
    return NextResponse.json({ error: "Internal server error" , status: 500 })
  }
}
