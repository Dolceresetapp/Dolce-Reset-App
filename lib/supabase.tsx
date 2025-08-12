"use client"

import { createClient } from "@supabase/supabase-js"
import { useAuth } from "@clerk/nextjs"

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Custom hook to create authenticated Supabase client
export function useSupabaseClient() {
  const { getToken } = useAuth()

  const getSupabaseClient = async () => {
    const token = await getToken({ template: "supabase" })

    return createClient(supabaseUrl, supabaseAnonKey, {
      global: {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    })
  }

  return { getSupabaseClient }
}
