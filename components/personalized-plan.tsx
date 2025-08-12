"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Heart, Sparkles, Target, Clock, TrendingUp, Star } from "lucide-react"

interface PersonalizedPlanProps {
  answers: Record<string, any>
  onGetPlan: () => void
}

export function PersonalizedPlan({ answers, onGetPlan }: PersonalizedPlanProps) {
  // Generate plan based on answers
  const generatePlanDetails = () => {
    const goal = answers.primary_goal || "Feel Younger"
    const timeframe = answers.workout_time?.includes("10-15")
      ? "3 weeks"
      : answers.workout_time?.includes("15-20")
        ? "4 weeks"
        : "6 weeks"

    const benefits = {
      "Lose Weight": ["Burn calories effectively", "Boost metabolism", "Tone your body"],
      "Reduce Pain": ["Strengthen supporting muscles", "Improve flexibility", "Reduce inflammation"],
      "Feel Younger": ["Increase energy levels", "Improve posture", "Enhance vitality"],
      "Build Strength": ["Build lean muscle", "Improve bone density", "Increase power"],
      "Improve Balance": ["Prevent falls", "Enhance stability", "Build confidence"],
      "Boost Energy": ["Improve circulation", "Enhance stamina", "Feel more alive"],
    }

    return {
      goal,
      timeframe,
      benefits: benefits[goal as keyof typeof benefits] || benefits["Feel Younger"],
    }
  }

  const plan = generatePlanDetails()

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen">
      <div className="p-6 pt-12">
        <div className="text-center mb-8 animate-fade-in">
          <div className="w-20 h-20 bg-gradient-to-br from-pink-400 to-rose-500 rounded-full flex items-center justify-center mb-4 mx-auto shadow-2xl">
            <Sparkles className="w-10 h-10 text-white" />
          </div>
          <h1 className="senior-text-2xl font-bold text-gray-800 mb-3">Your Personalized Plan is Ready!</h1>
          <p className="senior-text-base text-gray-600 leading-relaxed">
            Based on your answers, we've created the perfect fitness journey for you
          </p>
        </div>

        {/* Plan Overview */}
        <Card className="mb-6 bg-gradient-to-r from-pink-500 to-rose-500 text-white border-0 shadow-xl animate-slide-up">
          <CardContent className="p-6">
            <div className="text-center">
              <h2 className="senior-text-xl font-bold mb-2">Your Goal: {plan.goal}</h2>
              <p className="senior-text-lg opacity-90 mb-4">
                You can achieve amazing results in just <span className="font-bold">{plan.timeframe}</span>!
              </p>
              <Badge className="bg-white/20 text-white border-white/30 senior-text-sm">Customized Just For You</Badge>
            </div>
          </CardContent>
        </Card>

        {/* Benefits */}
        <div className="mb-6 animate-slide-up" style={{ animationDelay: "0.2s" }}>
          <h3 className="senior-text-lg font-bold text-gray-800 mb-4 flex items-center">
            <Target className="w-5 h-5 text-pink-500 mr-2" />
            What You'll Achieve
          </h3>
          <div className="space-y-3">
            {plan.benefits.map((benefit, index) => (
              <Card key={benefit} className="bg-white/80 border-pink-200 shadow-md">
                <CardContent className="p-4">
                  <div className="flex items-center space-x-3">
                    <div className="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center">
                      <Star className="w-4 h-4 text-green-500" />
                    </div>
                    <span className="senior-text-base text-gray-800">{benefit}</span>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>

        {/* Plan Features */}
        <div className="mb-8 animate-slide-up" style={{ animationDelay: "0.4s" }}>
          <h3 className="senior-text-lg font-bold text-gray-800 mb-4 flex items-center">
            <Heart className="w-5 h-5 text-pink-500 mr-2" />
            Your Plan Includes
          </h3>
          <div className="grid grid-cols-2 gap-4">
            <Card className="bg-white/80 border-pink-200">
              <CardContent className="p-4 text-center">
                <Clock className="w-8 h-8 text-pink-500 mx-auto mb-2" />
                <p className="senior-text-sm font-semibold text-gray-800">Daily Workouts</p>
                <p className="senior-text-sm text-gray-600">{answers.workout_time || "15-20 min"}</p>
              </CardContent>
            </Card>
            <Card className="bg-white/80 border-pink-200">
              <CardContent className="p-4 text-center">
                <TrendingUp className="w-8 h-8 text-pink-500 mx-auto mb-2" />
                <p className="senior-text-sm font-semibold text-gray-800">Progress Tracking</p>
                <p className="senior-text-sm text-gray-600">See your results</p>
              </CardContent>
            </Card>
          </div>
        </div>

        {/* Success Message */}
        <Card
          className="mb-8 bg-gradient-to-r from-green-50 to-emerald-50 border-green-200 animate-slide-up"
          style={{ animationDelay: "0.6s" }}
        >
          <CardContent className="p-6 text-center">
            <h4 className="senior-text-lg font-bold text-gray-800 mb-2">🎉 You're Going to Look & Feel Amazing!</h4>
            <p className="senior-text-base text-gray-600 leading-relaxed">
              Thousands of women have transformed their lives with our personalized approach. You're next!
            </p>
          </CardContent>
        </Card>

        {/* CTA Button */}
        <div className="animate-slide-up" style={{ animationDelay: "0.8s" }}>
          <Button
            onClick={onGetPlan}
            className="w-full h-16 senior-text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-2xl shadow-xl transition-all duration-300 hover:scale-105"
          >
            Get My Plan Now
            <Sparkles className="w-6 h-6 ml-2" />
          </Button>
        </div>
      </div>
    </div>
  )
}
