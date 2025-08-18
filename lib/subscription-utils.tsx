import { createClient } from "@supabase/supabase-js"

const supabase = createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!)

export async function linkSubscriptionToUser(email: string, userId: string) {
  try {
    // Find subscription by email and link it to the user
    const { data, error } = await supabase
      .from("subscriptions")
      .update({ user_id: userId, updated_at: new Date() })
      .eq("email", email)
      .select()

    if (error) {
      console.error("Error linking subscription to user:", error)
      return { success: false, error }
    }

    if (data && data.length > 0) {
      console.log("Successfully linked subscription to user:", userId)
      return { success: true, subscription: data[0] }
    } else {
      console.log("No subscription found for email:", email)
      return { success: false, error: "No subscription found" }
    }
  } catch (error) {
    console.error("Error in linkSubscriptionToUser:", error)
    return { success: false, error }
  }
}

export async function checkUserSubscription(userId: string) {
  try {
    const { data, error } = await supabase.from("subscriptions").select("*").eq("user_id", userId).single()

    if (error && error.code !== "PGRST116") {
      console.error("Error checking user subscription:", error)
      return { hasSubscription: false, error }
    }

    const hasActiveSubscription =
      data && (data.status === "active" || data.status === "trialing") && new Date(data.current_period_end) > new Date()

    return {
      hasSubscription: hasActiveSubscription,
      subscription: data,
      error: null,
    }
  } catch (error) {
    console.error("Error in checkUserSubscription:", error)
    return { hasSubscription: false, error }
  }
}
