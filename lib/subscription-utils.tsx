import { createClient } from "@supabase/supabase-js"

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY!

const supabase = createClient(supabaseUrl, supabaseServiceKey)

export async function getUserSubscription(userId: string) {
  const { data, error } = await supabase.from("subscriptions").select("*").eq("user_id", userId).single()

  if (error) {
    console.error("Error fetching user subscription:", error)
    return null
  }

  return data
}

export async function checkSubscriptionStatus(userId: string) {
  const subscription = await getUserSubscription(userId)

  if (!subscription) {
    return { hasSubscription: false, isActive: false, status: null }
  }

  const isActive =
    (subscription.status === "active" || subscription.status === "trialing") &&
    new Date(subscription.current_period_end) > new Date()

  return {
    hasSubscription: true,
    isActive,
    status: subscription.status,
    subscription,
  }
}

export async function linkSubscriptionToUser(email: string, userId: string) {
  const { data, error } = await supabase
    .from("subscriptions")
    .update({ user_id: userId, updated_at: new Date().toISOString() })
    .eq("email", email)
    .is("user_id", null)
    .select()
    .single()

  if (error) {
    console.error("Error linking subscription:", error)
    return null
  }

  return data
}
