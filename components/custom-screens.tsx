"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { CheckCircle, ArrowRight, Star } from "lucide-react"
import Image from "next/image"

interface CustomScreenProps {
  type: string
  answers: Record<string, any>
  onContinue: () => void
}

export function CustomScreen({ type, answers, onContinue }: CustomScreenProps) {
  const generateCustomOutput = () => {
    // Safety check for answers object
    if (!answers) return "Jane just changed her body in 30 days!"

    const urgentGoal = answers.urgent_improvement || "weight_loss"
    const bodyArea = answers.body_part_focus || "full_body"
    const currentBody = answers.current_body_type || "average"
    const dreamBody = answers.dream_body || "toned"

    // Convert IDs to readable text
    const goalText = urgentGoal.replace(/_/g, " ")
    const areaText = bodyArea.replace(/_/g, " ")
    const currentBodyText = currentBody.replace(/_/g, " ")
    const dreamBodyText = dreamBody.replace(/_/g, " ")

    return `Jane just changed her ${goalText} and ${areaText} from ${currentBodyText} to ${dreamBodyText} in 30 days!`
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
            {/* <Badge className="bg-purple-100 text-purple-700 text-sm mb-4 px-4 py-2 rounded-full">OUTPUT CUSTOM</Badge> */}
            <h1 className="text-lg font-bold text-gray-800 mb-4 leading-tight">{generateCustomOutput()}</h1>
          </div>

          {/* Before/After Image - Full size without overlay */}
          <div className="mb-6 animate-slide-up rounded-3xl overflow-hidden">
            <Image
              src="/custom/beforeafter.png"
              alt="Before and after transformation"
              width={400}
              height={300}
              className="w-full h-auto object-cover rounded-3xl"
            />
          </div>
        </div>

        {/* Continue Button */}
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
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col">
        <div className="flex-1 flex items-center justify-center p-6">
          <div className="text-center">
            <h1 className="text-xl font-bold text-gray-800 mb-8">Wait until end there is some gift for you</h1>
            <div className="flex justify-center">
              <Image
                src="/custom/gift.png"
                alt="Special Gift"
                width={300}
                height={300}
                className="w-80 h-80 object-contain"
              />
            </div>
          </div>
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

  if (type === "bmi-analysis") {
    return (
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col">
        <div className="flex-1 flex items-center justify-center p-6">
          <div className="text-center">
            <h1 className="text-xl font-bold text-gray-800 mb-8">
              Hai Un Ottimo Potenziale Per Spaccare Ogni Traguardo
            </h1>
            <div className="flex justify-center">
              <Image
                src="/custom/graph.png"
                alt="BMI Graph"
                width={300}
                height={300}
                className="w-full h-auto object-contain"
              />
            </div>
          </div>
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

  if (type === "doctor-screen") {
    return (
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col">
        <div className="flex-1 flex items-center justify-center p-6">
          <div className="text-center">
            {/* <h1 className="text-xl font-bold text-gray-800 mb-8">Doctor Recommended</h1> */}
            <div className="flex justify-center">
              <Image
                src="/custom/doctor.png"
                alt="Doctor Recommendation"
                width={300}
                height={300}
                className="w-full h-auto object-contain"
              />
            </div>
          </div>
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

  if (type === "comparison") {
    return (
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col">
        <div className="flex-1 p-4 pt-8">
         <Image src={'/custom/why.png'} alt="Why Choose Our Method" width={400} height={300} className="w-full h-auto object-contain" />

          
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
