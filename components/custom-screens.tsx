"use client"

import { Button } from "@/components/ui/button"
import { ArrowRight } from "lucide-react"
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

  if (type === "custom-output") {
    return (
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col overflow-hidden">
        <div className="flex-1 flex flex-col items-center justify-center p-4" style={{ height: "80vh" }}>
          {/* Header */}
          

          {/* Before/After Image - Full size without overlay */}
          <div className="flex-1 flex flex-col items-center justify-center w-full max-w-md">
            <div className="text-center mb-6 animate-fade-in">
              <h1 className="text-lg font-bold text-gray-800 mb-4 leading-tight">{generateCustomOutput()}</h1>
            </div>
            <Image
              src="/custom/beforeafter.png"
              alt="Before and after transformation"
              width={400}
              height={300}
              className="w-full h-auto object-contain rounded-3xl"
            />
          </div>
        </div>

        {/* Fixed Bottom Button */}
        <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-purple-100 p-4 shadow-lg">
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
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col overflow-hidden">
        <div className="flex-1 flex flex-col items-center justify-center p-6" style={{ height: "80vh" }}>
          <div className="text-center mb-8">
            <h1 className="text-xl font-bold text-gray-800 mb-8">Wait until end there is some gift for you</h1>
          </div>
          <div className="flex-1 flex items-center justify-center">
            <Image
              src="/custom/gift.png"
              alt="Special Gift"
              width={300}
              height={300}
              className="w-80 h-80 object-contain"
            />
          </div>
        </div>

        {/* Fixed Bottom Button */}
        <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-purple-100 p-4 shadow-lg">
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
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col overflow-hidden">
        <div className="flex-1 flex flex-col items-center justify-center p-6" style={{ height: "80vh" }}>
          <div className="text-center mb-8">
            <h1 className="text-xl font-bold text-gray-800 mb-8">
              Hai Un Ottimo Potenziale Per Spaccare Ogni Traguardo
            </h1>
          </div>
          <div className="flex-1 flex items-center justify-center">
            <Image
              src="/custom/graph.png"
              alt="BMI Graph"
              width={300}
              height={300}
              className="w-full h-auto object-contain max-w-md"
            />
          </div>
        </div>

        {/* Fixed Bottom Button */}
        <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-purple-100 p-4 shadow-lg">
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
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col overflow-hidden">
        <div className="flex-1 flex flex-col items-center justify-center p-6" style={{ height: "80vh" }}>
          <div className="flex-1 flex items-center justify-center">
            <Image
              src="/custom/doctor.png"
              alt="Doctor Recommendation"
              width={300}
              height={300}
              className="w-full h-auto object-contain max-w-md"
            />
          </div>
        </div>

        {/* Fixed Bottom Button */}
        <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-purple-100 p-4 shadow-lg">
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
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col overflow-hidden">
        <div className="flex-1 flex flex-col items-center justify-center p-4" style={{ height: "80vh" }}>
          <div className="flex-1 flex items-center justify-center">
            <Image
              src={"/custom/why.png"}
              alt="Why Choose Our Method"
              width={400}
              height={300}
              className="w-full h-auto object-contain max-w-md"
            />
          </div>
        </div>

        {/* Fixed Bottom Button */}
        <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-purple-100 p-4 shadow-lg">
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
