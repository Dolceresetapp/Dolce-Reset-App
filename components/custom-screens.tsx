"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Gift, Stethoscope, CheckCircle, ArrowRight, Star } from "lucide-react"
import Image from "next/image"

interface CustomScreenProps {
  type: string
  answers: Record<string, any>
  onContinue: () => void
}

export function CustomScreen({ type, answers, onContinue }: CustomScreenProps) {
  const generateCustomOutput = () => {
    // Safety check for answers object
    if (!answers) return "With SeniorFit, transform your body and feel amazing in just 30 days!"

    const urgentGoals = answers.urgent_improvement || []
    const bodyArea = answers.body_part_focus || "full body"

    const goalText = Array.isArray(urgentGoals)
      ? urgentGoals.join(" and ").replace(/_/g, " ")
      : urgentGoals.replace(/_/g, " ")

    const areaText = bodyArea.replace(/_/g, " ")

    return `With SeniorFit, in just a few weeks you can improve ${goalText} and see visible changes in your ${areaText}!`
  }

  const calculateBMI = () => {
    if (!answers || !answers.height || !answers.current_weight) return null

    const height = Number.parseFloat(answers.height) / 100
    const weight = Number.parseFloat(answers.current_weight)
    if (height && weight) {
      return (weight / (height * height)).toFixed(1)
    }
    return null
  }

  const getBMICategory = (bmi: number) => {
    if (bmi < 18.5) return { category: "Underweight", color: "text-blue-600", message: "Let's build healthy muscle!" }
    if (bmi < 25) return { category: "Normal", color: "text-green-600", message: "Perfect! Let's maintain and tone!" }
    if (bmi < 30)
      return { category: "Overweight", color: "text-orange-600", message: "Great potential for transformation!" }
    return { category: "Obese", color: "text-red-600", message: "Amazing journey ahead!" }
  }

  if (type === "custom-output") {
    return (
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col">
        <div className="flex-1 p-4 pt-8">
          {/* Header */}
          <div className="text-center mb-6 animate-fade-in">
            <Badge className="bg-purple-100 text-purple-700 text-sm mb-4 px-4 py-2 rounded-full">OUTPUT CUSTOM</Badge>
            <h1 className="text-lg font-bold text-gray-800 mb-4 leading-tight">{generateCustomOutput()}</h1>
          </div>

          {/* Before/After Image */}
          <Card className="mb-6 bg-white/90 border-purple-200 shadow-xl animate-slide-up rounded-3xl overflow-hidden">
            <CardContent className="p-0">
              <div className="relative">
                <Image
                  src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-Refhj3o5S2aKqesBCwE1mZzTfrIEnZ.png"
                  alt="Before and after transformation"
                  width={400}
                  height={300}
                  className="w-full h-64 object-cover"
                />
                <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/70 to-transparent p-4">
                  <div className="flex justify-between text-white">
                    <div className="text-center">
                      <p className="text-sm font-bold">GIORNO 1</p>
                    </div>
                    <div className="text-center">
                      <p className="text-sm font-bold">GIORNO 34</p>
                    </div>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Success Message */}
          <Card className="mb-6 bg-gradient-to-r from-green-50 to-emerald-50 border-green-200 animate-slide-up">
            <CardContent className="p-6 text-center">
              <CheckCircle className="w-12 h-12 text-green-500 mx-auto mb-4" />
              <h3 className="text-lg font-bold text-gray-800 mb-2">Your Transformation Awaits!</h3>
              <p className="text-sm text-gray-600 leading-relaxed">
                Based on your goals, this personalized plan will help you achieve visible results in just 30 days!
              </p>
            </CardContent>
          </Card>
        </div>

        {/* Continue Button - Only for custom screens showing information */}
        <div className="p-4">
          <Button
            onClick={onContinue}
            className="w-full h-14 text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105"
          >
            Continue
            <ArrowRight className="w-5 h-5 ml-2" />
          </Button>
        </div>
      </div>
    )
  }

  if (type === "gift-box") {
    return (
      <div className="app-container bg-gradient-to-br from-amber-50 via-orange-50 to-yellow-50 min-h-screen flex flex-col">
        <div className="flex-1 flex items-center justify-center p-6">
          <Card className="bg-gradient-to-r from-amber-400 to-orange-500 text-white border-0 shadow-2xl animate-fade-in rounded-3xl">
            <CardContent className="p-8 text-center">
              <div className="text-6xl mb-6 animate-bounce">🎁</div>
              <h1 className="text-2xl font-bold mb-4">Special Gift for You!</h1>
              <p className="text-lg opacity-90 mb-6 leading-relaxed">
                You're about to unlock exclusive content designed just for your transformation journey!
              </p>
              <div className="bg-white/20 rounded-2xl p-4 mb-6">
                <p className="text-sm font-medium">🎉 Personalized workout plan</p>
                <p className="text-sm font-medium">🎉 Custom nutrition guide</p>
                <p className="text-sm font-medium">🎉 Progress tracking tools</p>
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="p-4">
          <Button
            onClick={onContinue}
            className="w-full h-14 text-lg bg-gradient-to-r from-amber-500 to-orange-500 hover:from-amber-600 hover:to-orange-600 text-white font-bold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105"
          >
            <Gift className="w-6 h-6 mr-2" />
            Continue
          </Button>
        </div>
      </div>
    )
  }

  if (type === "bmi-analysis") {
    const bmi = calculateBMI()
    const bmiData = bmi ? getBMICategory(Number.parseFloat(bmi)) : null

    return (
      <div className="app-container bg-gradient-to-br from-green-50 via-emerald-50 to-teal-50 min-h-screen flex flex-col">
        <div className="flex-1 p-4 pt-8">
          <div className="text-center mb-6 animate-fade-in">
            <h1 className="text-xl font-bold text-gray-800 mb-2">Your BMI Analysis</h1>
            <p className="text-sm text-gray-600">Based on your height and weight</p>
          </div>

          {bmi && bmiData && (
            <Card className="mb-6 bg-gradient-to-r from-green-500 to-emerald-500 text-white border-0 shadow-xl animate-slide-up rounded-3xl">
              <CardContent className="p-6 text-center">
                <div className="text-4xl font-bold mb-2">{bmi}</div>
                <p className="text-lg opacity-90 mb-4">{bmiData.category}</p>
                <div className="bg-white/20 rounded-2xl p-4">
                  <p className="text-sm font-medium">{bmiData.message}</p>
                  <p className="text-xs opacity-90 mt-2">9% of people have your BMI - Perfect for transformation!</p>
                </div>
              </CardContent>
            </Card>
          )}

          <Card className="bg-white/90 border-green-200 shadow-lg animate-slide-up">
            <CardContent className="p-6 text-center">
              <CheckCircle className="w-12 h-12 text-green-500 mx-auto mb-4" />
              <h3 className="text-lg font-bold text-gray-800 mb-2">Excellent Starting Point!</h3>
              <p className="text-sm text-gray-600 leading-relaxed">
                Your body metrics show great potential for achieving your fitness goals. Let's create your perfect plan!
              </p>
            </CardContent>
          </Card>
        </div>

        <div className="p-4">
          <Button
            onClick={onContinue}
            className="w-full h-14 text-lg bg-gradient-to-r from-green-500 to-emerald-500 hover:from-green-600 hover:to-emerald-600 text-white font-bold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105"
          >
            Continue
            <ArrowRight className="w-5 h-5 ml-2" />
          </Button>
        </div>
      </div>
    )
  }

  if (type === "doctor-screen") {
    return (
      <div className="app-container bg-gradient-to-br from-blue-50 via-cyan-50 to-teal-50 min-h-screen flex flex-col">
        <div className="flex-1 p-4 pt-8">
          <div className="text-center mb-6 animate-fade-in">
            <Stethoscope className="w-16 h-16 text-blue-500 mx-auto mb-4" />
            <h1 className="text-xl font-bold text-gray-800 mb-2">Doctor Recommended</h1>
            <p className="text-sm text-gray-600">Trusted by healthcare professionals</p>
          </div>

          <Card className="mb-6 bg-gradient-to-r from-blue-500 to-cyan-500 text-white border-0 shadow-xl animate-slide-up rounded-3xl">
            <CardContent className="p-6">
              <div className="flex items-center space-x-4 mb-4">
                <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center">
                  <Stethoscope className="w-8 h-8 text-white" />
                </div>
                <div>
                  <h3 className="text-lg font-bold">Dr. Sarah Johnson</h3>
                  <p className="text-sm opacity-90">Sports Medicine Specialist</p>
                </div>
              </div>
              <div className="bg-white/20 rounded-2xl p-4">
                <p className="text-sm leading-relaxed">
                  "This app provides safe, effective exercises specifically designed for women. The personalized
                  approach ensures optimal results while minimizing injury risk."
                </p>
              </div>
            </CardContent>
          </Card>

          <Card className="bg-white/90 border-blue-200 shadow-lg animate-slide-up">
            <CardContent className="p-6">
              <div className="grid grid-cols-2 gap-4 text-center">
                <div>
                  <div className="text-2xl font-bold text-blue-600">95%</div>
                  <p className="text-xs text-gray-600">Doctor Approval</p>
                </div>
                <div>
                  <div className="text-2xl font-bold text-blue-600">Safe</div>
                  <p className="text-xs text-gray-600">For All Ages</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        <div className="p-4">
          <Button
            onClick={onContinue}
            className="w-full h-14 text-lg bg-gradient-to-r from-blue-500 to-cyan-500 hover:from-blue-600 hover:to-cyan-600 text-white font-bold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105"
          >
            Continue
            <ArrowRight className="w-5 h-5 ml-2" />
          </Button>
        </div>
      </div>
    )
  }

  if (type === "comparison") {
    return (
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col">
        <div className="flex-1 p-4 pt-8">
          <div className="text-center mb-6 animate-fade-in">
            <Badge className="bg-purple-100 text-purple-700 text-sm mb-4 px-4 py-2 rounded-full">OUTPUT CUSTOM</Badge>
            <h1 className="text-lg font-bold text-gray-800 mb-2">Why Choose Our Method</h1>
          </div>

          <div className="grid grid-cols-2 gap-3 animate-slide-up">
            {/* Other Solutions */}
            <Card className="bg-red-50 border-red-200 rounded-2xl">
              <CardContent className="p-4">
                <h3 className="text-sm font-bold text-red-700 mb-3 text-center">OTHER SOLUTIONS</h3>
                <div className="space-y-2">
                  <div className="flex items-center space-x-2">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    <p className="text-xs text-gray-700">Expensive gym memberships</p>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    <p className="text-xs text-gray-700">Strict diets</p>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    <p className="text-xs text-gray-700">No support</p>
                  </div>
                  <div className="flex items-center space-x-2">
                    <div className="w-2 h-2 bg-red-500 rounded-full"></div>
                    <p className="text-xs text-gray-700">Generic methods</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Our Solution */}
            <Card className="bg-green-50 border-green-200 rounded-2xl">
              <CardContent className="p-4">
                <h3 className="text-sm font-bold text-green-700 mb-3 text-center">SENIORFIT</h3>
                <div className="space-y-2">
                  <div className="flex items-center space-x-2">
                    <CheckCircle className="w-3 h-3 text-green-500" />
                    <p className="text-xs text-gray-700">Home workouts</p>
                  </div>
                  <div className="flex items-center space-x-2">
                    <CheckCircle className="w-3 h-3 text-green-500" />
                    <p className="text-xs text-gray-700">No strict diet</p>
                  </div>
                  <div className="flex items-center space-x-2">
                    <CheckCircle className="w-3 h-3 text-green-500" />
                    <p className="text-xs text-gray-700">24/7 support</p>
                  </div>
                  <div className="flex items-center space-x-2">
                    <CheckCircle className="w-3 h-3 text-green-500" />
                    <p className="text-xs text-gray-700">Personalized plan</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>

          <Card className="mt-6 bg-gradient-to-r from-green-50 to-emerald-50 border-green-200 animate-slide-up">
            <CardContent className="p-6 text-center">
              <Star className="w-12 h-12 text-green-500 mx-auto mb-4" />
              <h3 className="text-lg font-bold text-gray-800 mb-2">The Smart Choice</h3>
              <p className="text-sm text-gray-600 leading-relaxed">
                Join thousands who chose the effective, sustainable path to transformation!
              </p>
            </CardContent>
          </Card>
        </div>

        <div className="p-4">
          <Button
            onClick={onContinue}
            className="w-full h-14 text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105"
          >
            Continue
            <ArrowRight className="w-5 h-5 ml-2" />
          </Button>
        </div>
      </div>
    )
  }

  return null
}
