import { useEffect, useState } from "react"
import { useUser } from "@clerk/nextjs"
import { createClient } from "@supabase/supabase-js"

export const useCheckPremium = () => {
  const { user } = useUser()
  const [isPremium, setIsPremium] = useState(false)
  const [error, setError] = useState(false)
  const email = user?.emailAddresses?.[0]?.emailAddress

  useEffect(() => {
    const checkPremium = async () => {
      const supabase = createClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_SERVICE_ROLE_KEY!
      )
      const { data, error } = await supabase
        .from("users")
        .select("is_premium")
        .eq("email", email)
        .single()

      if (error) {
        setError(true)
      } else if (data) {
        setIsPremium(data.is_premium)
      }
    }

    if (email) {
      checkPremium()
    }
  }, [email])

  return { isPremium, error }
}
