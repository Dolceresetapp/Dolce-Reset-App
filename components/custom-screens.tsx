"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
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

  const calculateBMI = (height: number, weight: number) => {
    if (!height || !weight || height <= 0 || weight <= 0) return "0.0"
    const heightInM = height / 100
    return (weight / (heightInM * heightInM)).toFixed(1)
  }

  const getBMICategory = (bmi: number) => {
    if (bmi < 18.5)
      return {
        category: "Underweight",
        color: "text-blue-600",
        message: "You need to gain some healthy weight!",
        status: "needs improvement",
      }
    if (bmi < 25)
      return {
        category: "Normal",
        color: "text-green-600",
        message: "Your BMI is in the healthy range!",
        status: "good",
      }
    if (bmi < 30)
      return {
        category: "Overweight",
        color: "text-orange-600",
        message: "You could benefit from losing some weight.",
        status: "needs improvement",
      }
    return {
      category: "Obese",
      color: "text-red-600",
      message: "It's important to work on weight management.",
      status: "needs improvement",
    }
  }

  const getBMIDifficulty = (currentBMI: number, targetBMI: number) => {
    const difference = Math.abs(currentBMI - targetBMI)
    if (difference <= 2) return { level: "Easy", color: "text-green-600", message: "This is an achievable goal!" }
    if (difference <= 5)
      return { level: "Moderate", color: "text-orange-600", message: "With dedication, this is definitely possible!" }
    return {
      level: "Challenging",
      color: "text-red-600",
      message: "This will require commitment, but it's achievable!",
    }
  }

  if (type === "custom-output") {
    return (
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col overflow-hidden">
        <div className="flex-1 flex flex-col items-center justify-center p-4" style={{ height: "80vh" }}>
          {/* Header */}
          <div className="text-center mb-6 animate-fade-in">
            <h1 className="text-lg font-bold text-gray-800 mb-4 leading-tight">{generateCustomOutput()}</h1>
          </div>

          {/* Before/After Image - Full size without overlay */}
          <div className="flex-1 flex items-center justify-center w-full max-w-md">
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

  if (type === "current-bmi") {
    // Get values with proper validation
    const height = answers?.height ? Number.parseFloat(answers.height) : null
    const weight = answers?.current_weight ? Number.parseFloat(answers.current_weight) : null

    // Safety checks for answers
    if (!height || !weight || height <= 0 || weight <= 0) {
      return (
        <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col overflow-hidden">
          <div className="flex-1 flex items-center justify-center p-6" style={{ height: "80vh" }}>
            <div className="text-center">
              <p className="text-gray-600">Loading BMI analysis...</p>
              <p className="text-sm text-gray-500 mt-2">
                Height: {height || "Not set"}, Weight: {weight || "Not set"}
              </p>
            </div>
          </div>
          <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-purple-100 p-4 shadow-lg">
            <Button
              onClick={onContinue}
              className="w-full h-14 text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105"
            >
              Continue <ArrowRight className="w-5 h-5 ml-2" />
            </Button>
          </div>
        </div>
      )
    }

    const bmi = Number.parseFloat(calculateBMI(height, weight))
    const bmiInfo = getBMICategory(bmi)

    return (
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col overflow-hidden">
        <div className="flex-1 flex items-center justify-center p-6" style={{ height: "80vh" }}>
          <div className="text-center max-w-md">
            <h1 className="text-xl font-bold text-gray-800 mb-6">Your Current BMI Analysis</h1>

            <Card className="mb-6 bg-white/90 shadow-lg">
              <CardContent className="p-6">
                <div className="text-center">
                  <div className="text-4xl font-bold text-purple-600 mb-2">{bmi}</div>
                  <div className={`text-lg font-semibold mb-3 ${bmiInfo.color}`}>{bmiInfo.category}</div>
                  <div className="text-sm text-gray-600 mb-4">Formula: BMI = Weight (kg) ÷ Height² (m²)</div>
                  <div className="text-sm text-gray-600 mb-4">
                    {weight}kg ÷ ({(height / 100).toFixed(2)}m)² = {bmi}
                  </div>
                  <div
                    className={`text-sm font-medium p-3 rounded-lg ${
                      bmiInfo.status === "good" ? "bg-green-50 text-green-700" : "bg-orange-50 text-orange-700"
                    }`}
                  >
                    {bmiInfo.message}
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>

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

  if (type === "target-bmi") {
    // Get values with proper validation
    const height = answers?.height ? Number.parseFloat(answers.height) : null
    const currentWeight = answers?.current_weight ? Number.parseFloat(answers.current_weight) : null
    const targetWeight = answers?.target_weight ? Number.parseFloat(answers.target_weight) : null

    // Safety checks for answers
    if (!height || !currentWeight || !targetWeight || height <= 0 || currentWeight <= 0 || targetWeight <= 0) {
      return (
        <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col overflow-hidden">
          <div className="flex-1 flex items-center justify-center p-6" style={{ height: "80vh" }}>
            <div className="text-center">
              <p className="text-gray-600">Loading target BMI analysis...</p>
              <p className="text-sm text-gray-500 mt-2">
                Height: {height || "Not set"}, Current: {currentWeight || "Not set"}, Target:{" "}
                {targetWeight || "Not set"}
              </p>
            </div>
          </div>
          <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-purple-100 p-4 shadow-lg">
            <Button
              onClick={onContinue}
              className="w-full h-14 text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105"
            >
              Continue <ArrowRight className="w-5 h-5 ml-2" />
            </Button>
          </div>
        </div>
      )
    }

    const currentBMI = Number.parseFloat(calculateBMI(height, currentWeight))
    const targetBMI = Number.parseFloat(calculateBMI(height, targetWeight))
    const targetBMIInfo = getBMICategory(targetBMI)
    const difficulty = getBMIDifficulty(currentBMI, targetBMI)

    return (
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col overflow-hidden">
        <div className="flex-1 flex items-center justify-center p-6" style={{ height: "80vh" }}>
          <div className="text-center max-w-md">
            <h1 className="text-xl font-bold text-gray-800 mb-6">Your Target BMI Analysis</h1>

            <Card className="mb-6 bg-white/90 shadow-lg">
              <CardContent className="p-6">
                <div className="grid grid-cols-2 gap-4 mb-4">
                  <div className="text-center">
                    <div className="text-sm text-gray-600 mb-1">Current BMI</div>
                    <div className="text-2xl font-bold text-gray-700">{currentBMI}</div>
                  </div>
                  <div className="text-center">
                    <div className="text-sm text-gray-600 mb-1">Target BMI</div>
                    <div className={`text-2xl font-bold ${targetBMIInfo.color}`}>{targetBMI}</div>
                  </div>
                </div>

                <div className="text-center mb-4">
                  <div className={`text-lg font-semibold mb-2 ${targetBMIInfo.color}`}>
                    Target: {targetBMIInfo.category}
                  </div>
                  <div
                    className={`text-sm p-3 rounded-lg mb-3 ${
                      targetBMIInfo.status === "good" ? "bg-green-50 text-green-700" : "bg-orange-50 text-orange-700"
                    }`}
                  >
                    {targetBMIInfo.message}
                  </div>
                </div>

                <div className="border-t pt-4">
                  <div className={`text-lg font-semibold mb-2 ${difficulty.color}`}>Difficulty: {difficulty.level}</div>
                  <div
                    className={`text-sm p-3 rounded-lg ${
                      difficulty.level === "Easy"
                        ? "bg-green-50 text-green-700"
                        : difficulty.level === "Moderate"
                          ? "bg-orange-50 text-orange-700"
                          : "bg-red-50 text-red-700"
                    }`}
                  >
                    {difficulty.message}
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </div>

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

