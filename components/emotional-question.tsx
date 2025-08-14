"use client"
import { useState, useEffect } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, Heart, ArrowRight } from "lucide-react"
import Image from "next/image"

interface EmotionalQuestion {
  id: string
  title: string
  subtitle?: string
  type: "single-choice" | "input"
  options: Array<{
    id: string
    label: string
    emoji?: string
    image?: string
    description?: string
  }>
  image?: string
  inputType?: "text" | "number"
  placeholder?: string
  min?: number
  max?: number
}

interface EmotionalQuestionProps {
  question: EmotionalQuestion
  currentStep: number
  totalSteps: number
  answer: any
  onAnswer: (questionId: string, answer: any) => void
  onNext: () => void
  onPrevious: () => void
  canGoNext: boolean
}

export function EmotionalQuestion({
  question,
  currentStep,
  totalSteps,
  answer,
  onAnswer,
  onNext,
  onPrevious,
  canGoNext,
}: EmotionalQuestionProps) {
  const [inputValue, setInputValue] = useState("")

  // Clear input when question changes
  useEffect(() => {
    setInputValue("")
  }, [question.id])

  const handleOptionSelect = (optionId: string) => {
    onAnswer(question.id, optionId)
    // Auto-advance for single-choice questions
    setTimeout(() => {
      onNext()
    }, 400)
  }

  const handleInputChange = (value: string) => {
    setInputValue(value)
    onAnswer(question.id, value)
  }

  const isSelected = (optionId: string) => {
    return answer === optionId
  }

  // Calculate BMI for target weight input
  const calculateBMI = () => {
    if (question.id === "target_weight" && inputValue) {
      // This is a simplified calculation - in real app you'd get height from previous answers
      const targetWeight = Number.parseFloat(inputValue) || 0
      const height = 165 // Default height for demo
      if (targetWeight > 0 && height > 0) {
        const heightInM = height / 100
        const bmi = (targetWeight / (heightInM * heightInM)).toFixed(1)
        return bmi
      }
    }
    return null
  }

  const bmi = calculateBMI()

  return (
    <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col">
      {/* Compact Header */}
      <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-purple-100">
        <div className="flex items-center justify-between p-3">
          <Button
            variant="ghost"
            size="icon"
            onClick={onPrevious}
            disabled={currentStep === 1}
            className="h-10 w-10 rounded-full hover:bg-purple-100"
          >
            <ArrowLeft className="h-5 w-5 text-gray-600" />
          </Button>

          <div className="flex items-center space-x-2">
            <Heart className="w-4 h-4 text-purple-500" />
            <Badge className="bg-purple-100 text-purple-700 text-sm px-2 py-1">
              {currentStep}/{totalSteps}
            </Badge>
          </div>

          <div className="w-10" />
        </div>

        {/* Compact Progress Bar */}
        <div className="px-3 pb-2">
          <div className="w-full bg-purple-100 rounded-full h-2">
            <div
              className="bg-gradient-to-r from-purple-500 to-pink-500 h-2 rounded-full transition-all duration-500"
              style={{ width: `${(currentStep / totalSteps) * 100}%` }}
            />
          </div>
        </div>
      </div>

      {/* Content - Left Aligned */}
      <div className="flex-1 p-4 flex flex-col">
        <div className="animate-fade-in mb-6">
          <h1 className="text-lg font-bold text-gray-800 mb-2 leading-tight text-left">{question.title}</h1>
          {question.subtitle && <p className="text-sm text-gray-600 leading-relaxed text-left">{question.subtitle}</p>}
        </div>

        {/* Input Type - Left Aligned */}
        {question.type === "input" && (
          <div className="flex-0 flex flex-col">
            <div className="mb-6">
              <input
                type={question.inputType || "text"}
                placeholder={question.placeholder}
                value={inputValue}
                onChange={(e) => handleInputChange(e.target.value)}
                min={question.min}
                max={question.max}
                className="w-full h-16 text-xl px-6 rounded-3xl border-2 border-purple-200 focus:border-purple-500 focus:outline-none bg-white/80 text-left font-bold shadow-lg"
                autoFocus
              />

              {/* BMI Display for target weight */}
              {bmi && (
                <div className="mt-4 p-4 bg-gradient-to-r from-green-50 to-emerald-50 rounded-2xl border border-green-200">
                  <div className="text-left">
                    <p className="text-sm font-medium text-gray-700 mb-1">Your Target BMI</p>
                    <p className="text-2xl font-bold text-green-600">{bmi}</p>
                    <p className="text-xs text-gray-600">
                      {Number.parseFloat(bmi) < 18.5
                        ? "Underweight"
                        : Number.parseFloat(bmi) < 25
                          ? "Normal"
                          : Number.parseFloat(bmi) < 30
                            ? "Overweight"
                            : "Obese"}
                    </p>
                  </div>
                </div>
              )}

              {/* Age-specific encouragement */}
              {question.id === "age" && inputValue && Number.parseFloat(inputValue) >= 18 && (
                <div className="mt-4 p-4 bg-gradient-to-r from-pink-50 to-rose-50 rounded-2xl border border-pink-200">
                  <div className="text-left">
                    <p className="text-sm font-medium text-gray-700 mb-1">Perfect Age for Transformation! 💪</p>
                    <p className="text-sm text-gray-600">
                      {Number.parseFloat(inputValue) < 30
                        ? "You're in your prime - perfect time to build healthy habits!"
                        : Number.parseFloat(inputValue) < 50
                          ? "This is your decade to prioritize your health and feel amazing!"
                          : "Age is just a number - you're never too young to feel your best!"}
                    </p>
                  </div>
                </div>
              )}
            </div>

            {/* Continue Button for Input - Fixed at bottom */}
            <div className="mt-auto">
              <Button
                onClick={onNext}
                disabled={!canGoNext}
                className="w-full h-14 text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105 disabled:opacity-50"
              >
                Continue
                <ArrowRight className="w-5 h-5 ml-2" />
              </Button>
            </div>
          </div>
        )}

        {/* Single Choice Options - Left Aligned */}
        {question.type === "single-choice" && (
          <div className="flex-1 flex flex-col justify-start">
            <div className="space-y-3">
              {question.options.map((option, index) => (
                <Card
                  key={option.id}
                  className={`card-hover cursor-pointer transition-all duration-300 animate-slide-up ${
                    isSelected(option.id)
                      ? "border-purple-500 bg-gradient-to-r from-purple-50 to-pink-50 shadow-lg scale-105"
                      : "border-purple-200 bg-white/80 hover:border-purple-300 hover:shadow-md"
                  }`}
                  style={{ animationDelay: `${index * 0.1}s` }}
                  onClick={() => handleOptionSelect(option.id)}
                >
                  <CardContent className="p-4">
                    <div className="flex items-center space-x-4">
                      {/* Option Image or Emoji */}
                      {option.image ? (
                        <div className="w-12 h-12 rounded-xl overflow-hidden flex-shrink-0 bg-white shadow-sm">
                          <Image
                            src={option.image || "/placeholder.svg"}
                            alt={option.label}
                            width={48}
                            height={48}
                            className="w-full h-full object-cover"
                          />
                        </div>
                      ) : option.emoji ? (
                        <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-purple-100 to-pink-100 flex items-center justify-center flex-shrink-0">
                          <span className="text-2xl">{option.emoji}</span>
                        </div>
                      ) : null}

                      {/* Option Content - Left Aligned */}
                      <div className="flex-1 text-left">
                        <h3 className="text-base font-bold text-gray-800">{option.label}</h3>
                        {option.description && <p className="text-sm text-gray-600 mt-1">{option.description}</p>}
                      </div>

                      {/* Selection Indicator */}
                      <div
                        className={`w-6 h-6 rounded-full border-2 transition-all duration-200 flex items-center justify-center ${
                          isSelected(option.id) ? "border-purple-500 bg-purple-500" : "border-gray-300 bg-white"
                        }`}
                      >
                        {isSelected(option.id) && <div className="w-3 h-3 rounded-full bg-white"></div>}
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  )
}
