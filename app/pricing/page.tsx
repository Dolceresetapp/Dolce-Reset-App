"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { useUser } from "@clerk/nextjs"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, Crown, Check, Sparkles, Star, Zap } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"

export default function PricingPage() {
  const router = useRouter()
  const { user } = useUser()
  const [isLoading, setIsLoading] = useState(false)
  const [selectedPlan, setSelectedPlan] = useState<"monthly" | "yearly">("monthly")

  const plans = {
    monthly: {
      price: 29,
      period: "month",
      savings: null,
    },
    yearly: {
      price: 199,
      period: "year",
      savings: "Save $149",
    },
  }

  const premiumFeatures = [
    "50+ Premium Exercise Videos",
    "AI Personal Health Doctor",
    "AI Nutrition Chef & Meal Plans",
    "Exclusive Community Access",
    "Advanced Progress Analytics",
    "Personalized Workout Plans",
    "Priority Customer Support",
    "Offline Video Downloads",
    "Custom Meal Planning",
    "Expert Q&A Sessions",
  ]

  const handleUpgrade = async () => {
    setIsLoading(true)

    try {
      // Create Stripe checkout session
      const response = await fetch("/api/create-checkout-session", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          priceId: selectedPlan === "monthly" ? "price_1RvKnJBcIsUXPnbFtOSZg2Q7" : "price_1RvKnJBcIsUXPnbFtOSZg2Q7",
          userId: user?.id,
          userEmail: user?.emailAddresses[0]?.emailAddress,
        }),
      })

      const { url } = await response.json()

      if (url) {
        window.location.href = url
      }
    } catch (error) {
      console.error("Error creating checkout session:", error)
      // Fallback to demo checkout for now
      router.push("/checkout")
    } finally {
      setIsLoading(false)
    }
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen pb-20">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-pink-100 rounded-b-3xl">
        <div className="flex items-center justify-between p-4">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => router.back()}
            className="h-12 w-12 rounded-2xl hover:bg-pink-100"
          >
            <ArrowLeft className="h-6 w-6 text-gray-600" />
          </Button>
          <div className="text-center">
            <h1 className="senior-text-lg font-bold text-gray-800">Upgrade to Premium</h1>
            <p className="senior-text-sm text-gray-600">Unlock your full potential</p>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Content */}
      <div className="p-6">
        {/* Hero Section */}
        <Card className="mb-6 bg-gradient-to-r from-pink-500 to-rose-500 text-white border-0 shadow-xl animate-fade-in rounded-3xl">
          <CardContent className="p-6 text-center">
            <Crown className="w-16 h-16 mx-auto mb-4" />
            <h2 className="senior-text-xl font-bold mb-2">Transform Your Life</h2>
            <p className="senior-text-base opacity-90 leading-relaxed">
              Join thousands of women who've unlocked their full potential with Premium
            </p>
          </CardContent>
        </Card>

        {/* Plan Toggle */}
        <div className="mb-6 animate-slide-up">
          <div className="bg-white/80 rounded-3xl p-2 flex">
            <Button
              onClick={() => setSelectedPlan("monthly")}
              className={`flex-1 h-12 senior-text-base rounded-2xl transition-all duration-300 ${
                selectedPlan === "monthly"
                  ? "bg-gradient-to-r from-pink-500 to-rose-500 text-white shadow-md"
                  : "bg-transparent text-gray-600 hover:bg-pink-50"
              }`}
            >
              Monthly
            </Button>
            <Button
              onClick={() => setSelectedPlan("yearly")}
              className={`flex-1 h-12 senior-text-base rounded-2xl transition-all duration-300 relative ${
                selectedPlan === "yearly"
                  ? "bg-gradient-to-r from-pink-500 to-rose-500 text-white shadow-md"
                  : "bg-transparent text-gray-600 hover:bg-pink-50"
              }`}
            >
              Yearly
              {selectedPlan === "yearly" && (
                <Badge className="absolute -top-2 -right-2 bg-gradient-to-r from-amber-400 to-orange-400 text-white border-0 senior-text-sm">
                  <Star className="w-3 h-3 mr-1" />
                  Best Value
                </Badge>
              )}
            </Button>
          </div>
        </div>

        {/* Premium Plan Card */}
        <Card
          className="mb-6 bg-gradient-to-br from-amber-50 to-orange-50 border-amber-200 shadow-xl animate-slide-up rounded-3xl"
          style={{ animationDelay: "0.2s" }}
        >
          <CardContent className="p-6">
            <div className="text-center mb-6">
              <div className="flex items-center justify-center mb-4">
                <Crown className="w-8 h-8 text-amber-500 mr-2" />
                <h3 className="senior-text-xl font-bold text-gray-800">Premium Plan</h3>
              </div>

              <div className="mb-4">
                <span className="senior-text-3xl font-bold text-gray-800">${plans[selectedPlan].price}</span>
                <span className="senior-text-base text-gray-600">/{plans[selectedPlan].period}</span>
              </div>

              {plans[selectedPlan].savings && (
                <Badge className="bg-gradient-to-r from-green-400 to-emerald-400 text-white border-0 senior-text-sm mb-4">
                  <Zap className="w-4 h-4 mr-1" />
                  {plans[selectedPlan].savings}
                </Badge>
              )}

              <p className="senior-text-base text-gray-600 leading-relaxed">
                Everything you need for your complete transformation journey
              </p>
            </div>

            {/* Features List */}
            <div className="space-y-3 mb-6">
              {premiumFeatures.map((feature, index) => (
                <div key={index} className="flex items-center space-x-3">
                  <div className="w-6 h-6 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                    <Check className="w-4 h-4 text-green-500" />
                  </div>
                  <span className="senior-text-base text-gray-700">{feature}</span>
                </div>
              ))}
            </div>

            {/* Upgrade Button */}
            <Button
              onClick={handleUpgrade}
              disabled={isLoading}
              className="w-full h-16 senior-text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-3xl shadow-lg transition-all duration-300 hover:scale-105 disabled:opacity-50"
            >
              {isLoading ? (
                <div className="flex items-center">
                  <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-white mr-3"></div>
                  Processing...
                </div>
              ) : (
                <>
                  <Sparkles className="w-6 h-6 mr-3" />
                  Upgrade to Premium
                </>
              )}
            </Button>
          </CardContent>
        </Card>

        {/* Guarantee */}
        <Card
          className="bg-gradient-to-r from-green-50 to-emerald-50 border-green-200 animate-slide-up rounded-3xl"
          style={{ animationDelay: "0.4s" }}
        >
          <CardContent className="p-6 text-center">
            <div className="w-12 h-12 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Check className="w-6 h-6 text-green-500" />
            </div>
            <h4 className="senior-text-lg font-bold text-gray-800 mb-2">30-Day Money-Back Guarantee</h4>
            <p className="senior-text-base text-gray-600 leading-relaxed">
              Try Premium risk-free. If you're not completely satisfied, get a full refund within 30 days.
            </p>
          </CardContent>
        </Card>
      </div>

      <BottomNavigation />
    </div>
  )
}
