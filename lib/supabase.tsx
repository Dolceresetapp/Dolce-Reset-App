"use client"

import { createClient } from "@supabase/supabase-js"
import { useAuth } from "@clerk/nextjs"

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

// Create a base Supabase client
export const supabase = createClient(supabaseUrl, supabaseAnonKey)

// Custom hook to create authenticated Supabase client
export function useSupabaseClient() {
  const { getToken } = useAuth()

  const getSupabaseClient = async () => {
    const token = await getToken({ template: "supabase" })

    if (!token) {
      // Return regular client if no token (for public operations)
      return supabase
    }

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

// Server-side Supabase client (for API routes and webhooks)
export const createServerSupabaseClient = () => {
  return createClient(process.env.NEXT_PUBLIC_SUPABASE_URL!, process.env.SUPABASE_SERVICE_ROLE_KEY!, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  })
}
