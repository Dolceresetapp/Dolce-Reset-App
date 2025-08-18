"use client"

import { useEffect, useState } from "react"
import { useSearchParams } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { CheckCircle, Crown, ArrowRight } from "lucide-react"
import Link from "next/link"

export default function PaymentSuccessPage() {
  const searchParams = useSearchParams()
  const sessionId = searchParams.get("session_id")
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    // Simulate loading time
    const timer = setTimeout(() => {
      setIsLoading(false)
    }, 2000)

    return () => clearTimeout(timer)
  }, [])

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-rose-50 via-pink-50 to-red-50 flex items-center justify-center p-4">
        <Card className="w-full max-w-md">
          <CardContent className="p-8 text-center">
            <div className="w-16 h-16 border-4 border-pink-200 border-t-pink-500 rounded-full animate-spin mx-auto mb-4" />
            <h2 className="text-xl font-bold text-gray-800 mb-2">Processing your payment...</h2>
            <p className="text-gray-600">Please wait while we confirm your subscription.</p>
          </CardContent>
        </Card>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-50 via-pink-50 to-red-50 flex items-center justify-center p-4">
      <Card className="w-full max-w-md">
        <CardContent className="p-8 text-center">
          {/* Success Icon */}
          <div className="w-20 h-20 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full flex items-center justify-center mx-auto mb-6 shadow-xl">
            <CheckCircle className="w-10 h-10 text-white" />
          </div>

          {/* Success Message */}
          <h1 className="text-2xl font-bold text-gray-800 mb-2">Payment Successful! 🎉</h1>
          <p className="text-gray-600 mb-6">
            Your 3-day free trial has started. You now have access to your personalized fitness plan!
          </p>

          {/* Trial Info */}
          <div className="bg-gradient-to-r from-pink-50 to-rose-50 rounded-xl p-4 mb-6 border border-pink-200">
            <div className="flex items-center justify-center space-x-2 mb-2">
              <Crown className="w-5 h-5 text-pink-500" />
              <span className="font-semibold text-gray-800">Premium Access Activated</span>
            </div>
            <p className="text-sm text-gray-600">Your trial ends in 3 days. After that, you'll be charged €49/year.</p>
          </div>

          {/* Next Steps */}
          <div className="space-y-3 mb-6">
            <h3 className="font-semibold text-gray-800">Next Steps:</h3>
            <div className="text-left space-y-2">
              <div className="flex items-center space-x-2">
                <div className="w-2 h-2 bg-pink-500 rounded-full" />
                <span className="text-sm text-gray-700">Create your account to access your plan</span>
              </div>
              <div className="flex items-center space-x-2">
                <div className="w-2 h-2 bg-pink-500 rounded-full" />
                <span className="text-sm text-gray-700">Start your personalized workouts</span>
              </div>
              <div className="flex items-center space-x-2">
                <div className="w-2 h-2 bg-pink-500 rounded-full" />
                <span className="text-sm text-gray-700">Track your progress daily</span>
              </div>
            </div>
          </div>

          {/* CTA Button */}
          <Link href="/sign-up">
            <Button className="w-full h-12 text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-semibold rounded-xl shadow-lg transition-all duration-300 hover:scale-105">
              Create Your Account
              <ArrowRight className="w-5 h-5 ml-2" />
            </Button>
          </Link>

          {/* Support */}
          <p className="text-xs text-gray-500 mt-4">Need help? Contact our support team anytime.</p>
        </CardContent>
      </Card>
    </div>
  )
}
