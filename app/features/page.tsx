"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { useUser } from "@clerk/nextjs"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, Stethoscope, ChefHat, Users, Crown, Lock, Sparkles, Heart, Play } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"

const features = [
  {
    id: "exercises",
    title: "Exercise Library",
    description: "Access our complete collection of age-appropriate workouts",
    icon: Play,
    color: "from-pink-500 to-rose-500",
    isPremium: false,
    path: "/dashboard",
    benefits: ["15+ Free exercises", "Progress tracking", "Video guidance"],
  },
  {
    id: "ai-doctor",
    title: "AI Health Doctor",
    description: "Get personalized health advice and wellness guidance",
    icon: Stethoscope,
    color: "from-blue-500 to-cyan-500",
    isPremium: true,
    path: "/ai-doctor",
    benefits: ["24/7 health support", "Personalized advice", "Symptom checker"],
  },
  {
    id: "ai-chef",
    title: "AI Nutrition Chef",
    description: "Custom meal plans designed for your health goals",
    icon: ChefHat,
    color: "from-green-500 to-emerald-500",
    isPremium: true,
    path: "/ai-chef",
    benefits: ["Custom meal plans", "Healthy recipes", "Nutrition tracking"],
  },
  {
    id: "community",
    title: "Premium Community",
    description: "Connect with like-minded women on their wellness journey",
    icon: Users,
    color: "from-purple-500 to-pink-500",
    isPremium: true,
    path: "/community",
    benefits: ["Exclusive groups", "Expert Q&A", "Success stories"],
  },
  {
    id: "premium-exercises",
    title: "Premium Exercises",
    description: "Advanced workouts with celebrity trainers",
    icon: Crown,
    color: "from-amber-500 to-orange-500",
    isPremium: true,
    path: "/premium",
    benefits: ["50+ premium workouts", "Celebrity trainers", "Advanced programs"],
  },
]

export default function FeaturesPage() {
  const router = useRouter()
  const { user } = useUser()
  const [isPremium] = useState(false) // This should come from your user data

  const handleFeatureClick = (feature: (typeof features)[0]) => {
    if (feature.isPremium && !isPremium) {
      // Show upgrade modal or redirect to pricing
      router.push("/pricing")
      return
    }
    router.push(feature.path)
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen pb-20">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-pink-100">
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
        <div className="mb-6 bg-gradient-to-r from-pink-500 to-rose-500 rounded-3xl text-white border-0 shadow-xl animate-fade-in">
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
        </div>

        {/* Features Grid */}
        <div className="space-y-4">
          {features.map((feature, index) => (
            <Card
              key={feature.id}
              className={`card-hover cursor-pointer border-0 shadow-md animate-slide-up rounded-3xl ${
                feature.isPremium && !isPremium ? "bg-gradient-to-r from-gray-50 to-gray-100" : "bg-white/80"
              }`}
              style={{ animationDelay: `${index * 0.1}s` }}
              onClick={() => handleFeatureClick(feature)}
            >
              <CardContent className="p-6">
                <div className="flex items-start space-x-4">
                  <div
                    className={`w-14 h-14 bg-gradient-to-br ${feature.color} rounded-3xl flex items-center justify-center shadow-lg relative`}
                  >
                    <feature.icon className="w-7 h-7 text-white" />
                    {feature.isPremium && !isPremium && (
                      <div className="absolute -top-1 -right-1 w-6 h-6 bg-amber-400 rounded-full flex items-center justify-center">
                        <Lock className="w-3 h-3 text-white" />
                      </div>
                    )}
                  </div>

                  <div className="flex-1">
                    <div className="flex items-center justify-between mb-2">
                      <h3 className="senior-text-lg font-bold text-gray-800">{feature.title}</h3>
                      {feature.isPremium && (
                        <Badge
                          className={`${
                            isPremium
                              ? "bg-gradient-to-r from-amber-400 to-orange-400 text-white"
                              : "bg-gray-200 text-gray-600"
                          } border-0 senior-text-sm rounded-2xl`}
                        >
                          {isPremium ? "Premium" : "Premium"}
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

                    {feature.isPremium && !isPremium && (
                      <div className="mt-4 pt-4 border-t border-gray-200">
                        <Button
                          size="sm"
                          className="bg-gradient-to-r from-amber-400 to-orange-400 hover:from-amber-500 hover:to-orange-500 text-white font-semibold rounded-2xl"
                        >
                          <Crown className="w-4 h-4 mr-2" />
                          Upgrade to Access
                        </Button>
                      </div>
                    )}
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Upgrade CTA for Free Users */}
        {!isPremium && (
          <Card
            className="mt-8 bg-gradient-to-r from-amber-50 to-orange-50 border-amber-200 animate-slide-up rounded-3xl"
            style={{ animationDelay: "0.6s" }}
          >
            <CardContent className="p-6 text-center">
              <Crown className="w-12 h-12 text-amber-500 mx-auto mb-4" />
              <h3 className="senior-text-lg font-bold text-gray-800 mb-2">Unlock Your Full Potential</h3>
              <p className="senior-text-base text-gray-600 mb-4 leading-relaxed">
                Get access to all premium features and transform your wellness journey
              </p>
              <Button
                onClick={() => router.push("/pricing")}
                className="bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600 text-white font-bold rounded-2xl h-12 senior-text-base px-8"
              >
                <Sparkles className="w-5 h-5 mr-2" />
                Upgrade Now
              </Button>
            </CardContent>
          </Card>
        )}
      </div>

      <BottomNavigation />
    </div>
  )
}
