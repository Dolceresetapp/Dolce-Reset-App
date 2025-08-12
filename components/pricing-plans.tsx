"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Check, Crown, Heart, Sparkles, Star, Zap } from "lucide-react"

interface PricingPlansProps {
  onPlanSelect: (planType: "free" | "premium") => void
  answers: Record<string, any>
}

export function PricingPlans({ onPlanSelect, answers }: PricingPlansProps) {
  const freeFeatures = ["5 Basic Exercises", "Progress Tracking", "Community Access", "Weekly Tips"]

  const premiumFeatures = [
    "50+ Premium Exercises",
    "AI Personal Trainer",
    "Custom Meal Plans",
    "1-on-1 Support",
    "Advanced Analytics",
    "Exclusive Content",
    "Priority Support",
    "Offline Access",
  ]

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen">
      <div className="p-6 pt-12">
        <div className="text-center mb-8 animate-fade-in">
          <div className="w-20 h-20 bg-gradient-to-br from-pink-400 to-rose-500 rounded-full flex items-center justify-center mb-4 mx-auto shadow-2xl">
            <Crown className="w-10 h-10 text-white" />
          </div>
          <h1 className="senior-text-2xl font-bold text-gray-800 mb-3">Choose Your Plan</h1>
          <p className="senior-text-base text-gray-600 leading-relaxed">Start your transformation journey today</p>
        </div>

        {/* Free Plan */}
        <Card className="mb-6 bg-white/80 border-pink-200 shadow-lg animate-slide-up">
          <CardContent className="p-6">
            <div className="text-center mb-6">
              <div className="w-12 h-12 bg-gradient-to-br from-blue-400 to-cyan-400 rounded-xl flex items-center justify-center mx-auto mb-3">
                <Heart className="w-6 h-6 text-white" />
              </div>
              <h3 className="senior-text-xl font-bold text-gray-800 mb-2">Free Plan</h3>
              <p className="senior-text-2xl font-bold text-gray-800">
                $0<span className="senior-text-base font-normal">/month</span>
              </p>
              <p className="senior-text-sm text-gray-600 mt-2">Perfect to get started</p>
            </div>

            <div className="space-y-3 mb-6">
              {freeFeatures.map((feature, index) => (
                <div key={feature} className="flex items-center space-x-3">
                  <div className="w-5 h-5 bg-green-100 rounded-full flex items-center justify-center">
                    <Check className="w-3 h-3 text-green-500" />
                  </div>
                  <span className="senior-text-base text-gray-700">{feature}</span>
                </div>
              ))}
            </div>

            <Button
              onClick={() => onPlanSelect("free")}
              variant="outline"
              className="w-full h-12 senior-text-base border-2 border-pink-300 text-pink-600 hover:bg-pink-50 font-semibold rounded-xl"
            >
              Start Free
            </Button>
          </CardContent>
        </Card>

        {/* Premium Plan */}
        <Card
          className="mb-6 bg-gradient-to-br from-pink-500 to-rose-500 text-white border-0 shadow-xl animate-slide-up relative"
          style={{ animationDelay: "0.2s" }}
        >
          <Badge className="absolute -top-3 left-1/2 transform -translate-x-1/2 bg-gradient-to-r from-amber-400 to-orange-400 text-white border-0 senior-text-sm">
            <Star className="w-4 h-4 mr-1" />
            MOST POPULAR
          </Badge>

          <CardContent className="p-6">
            <div className="text-center mb-6">
              <div className="w-12 h-12 bg-white/20 rounded-xl flex items-center justify-center mx-auto mb-3">
                <Crown className="w-6 h-6 text-white" />
              </div>
              <h3 className="senior-text-xl font-bold mb-2">Premium Plan</h3>
              <p className="senior-text-2xl font-bold">
                $29<span className="senior-text-base font-normal">/month</span>
              </p>
              <p className="senior-text-sm opacity-90 mt-2">Complete transformation package</p>
            </div>

            <div className="space-y-3 mb-6">
              {premiumFeatures.map((feature, index) => (
                <div key={feature} className="flex items-center space-x-3">
                  <div className="w-5 h-5 bg-white/20 rounded-full flex items-center justify-center">
                    <Check className="w-3 h-3 text-white" />
                  </div>
                  <span className="senior-text-base text-white">{feature}</span>
                </div>
              ))}
            </div>

            <Button
              onClick={() => onPlanSelect("premium")}
              className="w-full h-12 senior-text-base bg-white text-pink-600 hover:bg-gray-50 font-bold rounded-xl shadow-lg transition-all duration-300 hover:scale-105"
            >
              <Sparkles className="w-5 h-5 mr-2" />
              Start Premium
            </Button>
          </CardContent>
        </Card>

        {/* Special Offer */}
        <Card
          className="bg-gradient-to-r from-amber-50 to-orange-50 border-amber-200 animate-slide-up"
          style={{ animationDelay: "0.4s" }}
        >
          <CardContent className="p-6 text-center">
            <Zap className="w-8 h-8 text-amber-500 mx-auto mb-3" />
            <h4 className="senior-text-lg font-bold text-gray-800 mb-2">🎁 Special Launch Offer</h4>
            <p className="senior-text-base text-gray-600 leading-relaxed">
              Get your first month for just $9.99! Limited time offer for new members.
            </p>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
