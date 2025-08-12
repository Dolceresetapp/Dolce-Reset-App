"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Crown, ArrowLeft, CreditCard, Shield } from "lucide-react"

export default function CheckoutPage() {
  const [isLoading, setIsLoading] = useState(false)
  const router = useRouter()

  const handlePayment = async () => {
    setIsLoading(true)

    // Simulate payment processing
    setTimeout(() => {
      localStorage.setItem("onboarding-completed", "true")
      localStorage.setItem("user-plan", "premium")
      router.push("/dashboard")
    }, 2000)
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen">
      <div className="p-6 pt-12">
        {/* Header */}
        <div className="flex items-center mb-8">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => router.back()}
            className="h-12 w-12 rounded-full hover:bg-pink-100 mr-4"
          >
            <ArrowLeft className="h-6 w-6 text-gray-600" />
          </Button>
          <h1 className="senior-text-xl font-bold text-gray-800">Complete Your Order</h1>
        </div>

        {/* Plan Summary */}
        <Card className="mb-6 bg-gradient-to-r from-pink-500 to-rose-500 text-white border-0 shadow-xl">
          <CardContent className="p-6">
            <div className="flex items-center justify-between">
              <div>
                <div className="flex items-center mb-2">
                  <Crown className="w-6 h-6 mr-2" />
                  <h3 className="senior-text-lg font-bold">Premium Plan</h3>
                </div>
                <p className="senior-text-sm opacity-90">Complete transformation package</p>
              </div>
              <div className="text-right">
                <p className="senior-text-2xl font-bold">$9.99</p>
                <p className="senior-text-sm opacity-90">First month</p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Security Features */}
        <Card className="mb-6 bg-white/80 border-pink-200">
          <CardContent className="p-6">
            <div className="flex items-center mb-4">
              <Shield className="w-6 h-6 text-green-500 mr-2" />
              <h3 className="senior-text-lg font-semibold text-gray-800">Secure Payment</h3>
            </div>
            <div className="space-y-2">
              <p className="senior-text-sm text-gray-600">✓ 256-bit SSL encryption</p>
              <p className="senior-text-sm text-gray-600">✓ Cancel anytime</p>
              <p className="senior-text-sm text-gray-600">✓ 30-day money-back guarantee</p>
            </div>
          </CardContent>
        </Card>

        {/* Payment Button */}
        <Button
          onClick={handlePayment}
          disabled={isLoading}
          className="w-full h-16 senior-text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-2xl shadow-xl transition-all duration-300 hover:scale-105 disabled:opacity-50"
        >
          {isLoading ? (
            <div className="flex items-center">
              <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white mr-3"></div>
              Processing...
            </div>
          ) : (
            <>
              <CreditCard className="w-6 h-6 mr-3" />
              Complete Payment - $9.99
            </>
          )}
        </Button>

        <p className="senior-text-sm text-gray-500 text-center mt-4">
          By continuing, you agree to our Terms of Service and Privacy Policy
        </p>
      </div>
    </div>
  )
}
