"use client"

import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, Crown, Stethoscope, ChefHat, Users, Heart, Lock } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"
import { useCheckPremium } from "@/components/hooks/check-package"

// Feature definitions
const features = [
  {
    id: "premium-exercises",
    title: "Premium Exercises",
    description: "Advanced workouts with celebrity trainers",
    icon: Crown,
    color: "from-amber-500 to-orange-500",
    path: "/premium",
    benefits: ["50+ premium workouts", "Celebrity trainers", "Advanced programs"],
    isPremiumOnly: false, // free feature
  },
  {
    id: "ai-chef",
    title: "AI Nutrition Chef",
    description: "Custom meal plans designed for your health goals",
    icon: ChefHat,
    color: "from-green-500 to-emerald-500",
    path: "/ai-chef",
    benefits: ["Custom meal plans", "Healthy recipes", "Nutrition tracking"],
    isPremiumOnly: true,
  },
  {
    id: "ai-doctor",
    title: "AI Health Doctor",
    description: "Get personalized health advice and wellness guidance",
    icon: Stethoscope,
    color: "from-blue-500 to-cyan-500",
    path: "/ai-doctor",
    benefits: ["24/7 health support", "Personalized advice", "Symptom checker"],
    isPremiumOnly: true,
  },
  {
    id: "community",
    title: "Premium Community",
    description: "Connect with like-minded women on their wellness journey",
    icon: Users,
    color: "from-purple-500 to-pink-500",
    path: "/community",
    benefits: ["Exclusive groups", "Expert Q&A", "Success stories"],
    isPremiumOnly: true,
  },
]

export default function FeaturesPage() {
  const router = useRouter()
  const { isPremium } = useCheckPremium()

  const handleFeatureClick = (feature: (typeof features)[0]) => {
    if (!isPremium && feature.isPremiumOnly) {
      // Free user clicking premium feature → upsell
      router.push("/pricing")
      return
    }
    router.push(feature.path)
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
            <h1 className="senior-text-lg font-bold text-gray-800">Features</h1>
            <p className="senior-text-sm text-gray-600">Discover all our wellness tools</p>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Content */}
      <div className="p-6">
        {/* Welcome Card */}
        <Card className="mb-6 bg-gradient-to-r from-pink-500 to-rose-500 text-white border-0 shadow-xl animate-fade-in rounded-3xl">
          <CardContent className="p-6">
            <div className="flex items-center justify-center text-center">
              <div>
                <h2 className="senior-text-lg font-bold mb-2 flex items-center justify-center">
                  <Heart className="w-6 h-6 mr-2" />
                  Your Wellness Journey
                </h2>
                <p className="senior-text-base opacity-90">
                  Everything you need to transform your health and confidence
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Features Grid */}
        <div className="space-y-4">
          {features.map((feature, index) => (
            <Card
              key={feature.id}
              className="card-hover cursor-pointer border-0 shadow-md animate-slide-up rounded-3xl bg-white/80"
              style={{ animationDelay: `${index * 0.1}s` }}
              onClick={() => handleFeatureClick(feature)}
            >
              <CardContent className="p-6">
                <div className="flex items-start space-x-4">
                  <div
                    className={`w-14 h-14 bg-gradient-to-br ${feature.color} rounded-3xl flex items-center justify-center shadow-lg relative`}
                  >
                    <feature.icon className="w-7 h-7 text-white" />
                    {!isPremium && feature.isPremiumOnly && (
                      <div className="absolute -top-1 -right-1 w-6 h-6 bg-amber-400 rounded-full flex items-center justify-center">
                        <Lock className="w-3 h-3 text-white" />
                      </div>
                    )}
                  </div>

                  <div className="flex-1">
                    <div className="flex items-center justify-between mb-2">
                      <h3 className="senior-text-lg font-bold text-gray-800">{feature.title}</h3>
                      {!isPremium && feature.isPremiumOnly && (
                        <Badge className="bg-gradient-to-r from-amber-400 to-orange-400 text-white border-0 senior-text-sm rounded-xl">
                          Premium
                        </Badge>
                      )}
                    </div>

                    <p className="senior-text-base text-gray-600 mb-4 leading-relaxed">{feature.description}</p>

                    <div className="space-y-2">
                      {feature.benefits.map((benefit, idx) => (
                        <div key={idx} className="flex items-center space-x-2">
                          <div className="w-2 h-2 bg-pink-400 rounded-full" />
                          <span className="senior-text-sm text-gray-600">{benefit}</span>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      <BottomNavigation />
    </div>
  )
}
