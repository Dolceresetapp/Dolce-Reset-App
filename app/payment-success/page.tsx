"use client"

import { useEffect, useState } from "react"
import { useSearchParams, useRouter } from "next/navigation"
import { Card, CardContent } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { CheckCircle, Crown, ArrowRight } from "lucide-react"

export default function PaymentSuccessPage() {
  const searchParams = useSearchParams()
  const router = useRouter()
  const [isLoading, setIsLoading] = useState(true)
  const sessionId = searchParams.get("session_id")

  useEffect(() => {
    // Verify the payment session
    if (sessionId) {
      // You can optionally verify the session with your backend
      setIsLoading(false)
    } else {
      // Redirect if no session ID
      router.push("/onboarding")
    }
  }, [sessionId, router])

  const handleCreateAccount = () => {
    // Store that payment is completed
    localStorage.setItem("payment_completed", "true")
    // Redirect to sign up
    router.push("/sign-up")
  }

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-rose-50 via-pink-50 to-red-50 flex items-center justify-center">
        <div className="text-center">
          <div className="w-16 h-16 bg-gradient-to-br from-pink-400 to-rose-400 rounded-full flex items-center justify-center mb-4 mx-auto animate-pulse">
            <Crown className="w-8 h-8 text-white" />
          </div>
          <p className="text-gray-600">Verifying your payment...</p>
        </div>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-50 via-pink-50 to-red-50 flex items-center justify-center p-4">
      <Card className="w-full max-w-md border-0 shadow-xl">
        <CardContent className="p-8 text-center">
          {/* Success Icon */}
          <div className="w-20 h-20 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full flex items-center justify-center mb-6 mx-auto">
            <CheckCircle className="w-10 h-10 text-white" />
          </div>

          {/* Success Message */}
          <h1 className="text-2xl font-bold text-gray-800 mb-3">🎉 Payment Successful!</h1>
          <p className="text-gray-600 mb-6 leading-relaxed">
            Your 3-day free trial has started! Now let's create your account to access your personalized fitness plan.
          </p>

          {/* Trial Info */}
          <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-6">
            <h3 className="font-semibold text-blue-800 mb-2">Your Free Trial</h3>
            <p className="text-sm text-blue-600">
              • 3 days of full access
              <br />• Cancel anytime during trial
              <br />• €49/year after trial ends
            </p>
          </div>

          {/* CTA Button */}
          <Button
            onClick={handleCreateAccount}
            className="w-full h-12 bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-xl shadow-lg transition-all duration-300 hover:scale-105"
          >
            Create Your Account
            <ArrowRight className="w-5 h-5 ml-2" />
          </Button>

          <p className="text-xs text-gray-500 mt-4">You'll use the same email address you provided during payment</p>
        </CardContent>
      </Card>
    </div>
  )
}
