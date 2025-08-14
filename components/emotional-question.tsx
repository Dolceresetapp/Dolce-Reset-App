"use client"

import { useState, useEffect } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, ArrowRight } from "lucide-react"
import Image from "next/image"
import type { EmotionalQuestion as OnboardingQuestion } from "@/lib/onboarding-questions"
import { CustomScreen } from "./custom-screens"

interface EmotionalQuestionProps {
  question: OnboardingQuestion
  currentStep: number
  totalSteps: number
  answer: any
  answers: Record<string, any>
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
  answers,
  onAnswer,
  onNext,
  onPrevious,
  canGoNext,
}: EmotionalQuestionProps) {
  const [inputValue, setInputValue] = useState("")
  const [selectedOptions, setSelectedOptions] = useState<string[]>([])
  const [ageError, setAgeError] = useState("")

  // Auto-advance past BMI analysis screens
  useEffect(() => {
    if (
      question.type === "custom-screen" &&
      (question.customScreenType === "current-bmi" || question.customScreenType === "target-bmi")
    ) {
      const timer = setTimeout(() => {
        onNext()
      }, 100)
      return () => clearTimeout(timer)
    }
  }, [question.type, question.customScreenType, onNext])

  // Get values for BMI calculations - try answers first, then localStorage as fallback
  const getHeightValue = (): number | null => {
    const fromAnswers = answers?.height ? Number.parseFloat(String(answers.height)) : null
    const fromLocalStorage =
      typeof window !== "undefined" ? Number.parseFloat(localStorage.getItem(`onboarding_height`) || "") : null
    return fromAnswers || fromLocalStorage
  }

  const getCurrentWeightValue = (): number | null => {
    const fromAnswers = answers?.current_weight ? Number.parseFloat(String(answers.current_weight)) : null
    const fromLocalStorage =
      typeof window !== "undefined" ? Number.parseFloat(localStorage.getItem(`onboarding_current_weight`) || "") : null
    return fromAnswers || fromLocalStorage
  }

  const getTargetWeightValue = (): number | null => {
    const fromAnswers = answers?.target_weight ? Number.parseFloat(String(answers.target_weight)) : null
    const fromLocalStorage =
      typeof window !== "undefined" ? Number.parseFloat(localStorage.getItem(`onboarding_target_weight`) || "") : null
    return fromAnswers || fromLocalStorage
  }

  const userHeight = getHeightValue()
  const currentWeight = getCurrentWeightValue()
  const targetWeight = getTargetWeightValue()

  // Helper functions for localStorage
  const saveToLocalStorage = (key: string, value: string) => {
    if (typeof window !== "undefined") {
      localStorage.setItem(`onboarding_${key}`, value)
    }
  }

  const calculateBMI = (height: number, weight: number) => {
    if (!height || !weight || height <= 0 || weight <= 0) return "0.0"
    const heightInM = height / 100
    return (weight / (heightInM * heightInM)).toFixed(1)
  }

  const getBMIStatus = (bmi: number) => {
    if (bmi < 18.5)
      return { status: "Underweight", color: "text-blue-600", message: "You may need to gain some healthy weight." }
    if (bmi < 25) return { status: "Normal", color: "text-green-600", message: "Your BMI is in the healthy range! 👍" }
    if (bmi < 30)
      return { status: "Overweight", color: "text-orange-600", message: "You could benefit from losing some weight." }
    return { status: "Obese", color: "text-red-600", message: "It's important to work on weight management." }
  }

  const getTargetBMIFeedback = (currentBMI: number, targetBMI: number) => {
    const difference = Math.abs(currentBMI - targetBMI)
    if (difference <= 2)
      return {
        level: "Easily achievable",
        color: "text-green-600",
        message: "This is a realistic and healthy goal! 🎯",
      }
    if (difference <= 5)
      return {
        level: "Achievable",
        color: "text-orange-600",
        message: "With dedication, this goal is definitely possible! 💪",
      }
    return {
      level: "Challenging",
      color: "text-red-600",
      message: "This will require commitment, but it's achievable with time! 🔥",
    }
  }

  useEffect(() => {
    if (question.type === "input") {
      setInputValue(answer || "")
    } else if (question.type === "multiple-choice") {
      setSelectedOptions(Array.isArray(answer) ? answer : [])
    }
    // Scroll to top when question changes
    window.scrollTo({ top: 0, behavior: "smooth" })
  }, [question.id, answer, question.type])

  const handleInputChange = (value: string) => {
    setInputValue(value)
    onAnswer(question.id, value)

    // Save to localStorage immediately for important values
    if (question.id === "height" && value) {
      saveToLocalStorage("height", value)
    }
    if (question.id === "current_weight" && value) {
      saveToLocalStorage("current_weight", value)
    }
    if (question.id === "target_weight" && value) {
      saveToLocalStorage("target_weight", value)
    }

    // Age validation
    if (question.id === "age") {
      const age = Number.parseInt(value)
      if (age && (age < 16 || age > 79)) {
        setAgeError("Sorry, our program is designed for ages 16-79 only.")
      } else {
        setAgeError("")
      }
    }
  }

  const handleSingleChoice = (optionId: string) => {
    onAnswer(question.id, optionId)
    // Auto-advance for single choice questions after a short delay
    setTimeout(() => {
      onNext()
    }, 400)
  }

  const handleMultipleChoice = (optionId: string) => {
    const newSelection = selectedOptions.includes(optionId)
      ? selectedOptions.filter((id) => id !== optionId)
      : [...selectedOptions, optionId]

    setSelectedOptions(newSelection)
    onAnswer(question.id, newSelection)
  }

  const handleInputSubmit = () => {
    if (question.id === "age") {
      const age = Number.parseInt(inputValue)
      if (age < 16 || age > 79) {
        return // Don't proceed if age is invalid
      }
    }

    if (inputValue.trim()) {
      onNext()
    }
  }

  if (question.type === "custom-screen") {
    return <CustomScreen type={question.customScreenType || ""} answers={answers} onContinue={onNext} />
  }

  // For current weight input, use the current inputValue for real-time calculation
  const currentInputWeight = question.id === "current_weight" && inputValue ? Number.parseFloat(inputValue) : null
  // For target weight input, use the current inputValue for real-time calculation
  const currentInputTargetWeight = question.id === "target_weight" && inputValue ? Number.parseFloat(inputValue) : null

  return (
    <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col">
      {/* Fixed Progress Bar at Top */}
      <div className="fixed top-0 left-0 right-0 z-50 bg-white/95 backdrop-blur-sm">
        <div className="w-full bg-white/50 h-2">
          <div
            className="h-full bg-gradient-to-r from-purple-500 to-pink-500 transition-all duration-500 ease-out"
            style={{ width: `${(currentStep / totalSteps) * 100}%` }}
          />
        </div>

        {/* Header */}
        <div className="flex items-center justify-between p-4">
          <Button
            variant="ghost"
            size="icon"
            onClick={onPrevious}
            className="text-gray-600 hover:text-gray-800"
            disabled={currentStep === 1}
          >
            <ArrowLeft className="w-5 h-5" />
          </Button>
          <Badge variant="secondary" className="bg-white/80 text-gray-700">
            {currentStep} / {totalSteps}
          </Badge>
          <div className="w-10" />
        </div>
      </div>

      {/* Content with top padding to account for fixed header */}
      <div className="flex-1 pt-20 pb-24 p-4 overflow-y-auto">
        <div className="text-left mb-8 animate-fade-in">
          <h1 className="text-xl font-bold text-gray-800 mb-2 leading-tight">{question.title}</h1>
          {question.subtitle && <p className="text-sm text-gray-600">{question.subtitle}</p>}
        </div>

        {question.type === "input" && (
          <div className="space-y-4 animate-slide-up">
            <div className="relative">
              <Input
                type={question.inputType || "text"}
                placeholder={question.placeholder}
                value={inputValue}
                onChange={(e) => handleInputChange(e.target.value)}
                className="h-12 text-lg border-2 border-purple-200 focus:border-purple-400 rounded-2xl px-4"
                min={question.min}
                max={question.max}
                onKeyPress={(e) => {
                  if (e.key === "Enter") {
                    handleInputSubmit()
                  }
                }}
              />

              {/* Height BMI Note */}
              {question.id === "height" && inputValue && Number.parseFloat(inputValue) > 0 && (
                <div className="mt-3 p-3 bg-blue-50 border border-blue-200 rounded-xl">
                  <p className="text-sm text-blue-700">
                    📏 We're collecting your height to calculate your BMI (Body Mass Index) for personalized
                    recommendations.
                  </p>
                </div>
              )}

              {/* Current Weight BMI Calculation - Only show when user is typing */}
              {question.id === "current_weight" &&
                currentInputWeight &&
                currentInputWeight > 0 &&
                userHeight &&
                userHeight > 0 && (
                  <div className="mt-3 p-3 bg-white border border-gray-200 rounded-xl">
                    <div className="text-center">
                      <p className="text-sm text-gray-600 mb-2">Your Current BMI</p>
                      {(() => {
                        const bmi = Number.parseFloat(calculateBMI(userHeight, currentInputWeight))
                        const bmiInfo = getBMIStatus(bmi)
                        return (
                          <>
                            <p className="text-2xl font-bold text-purple-600 mb-1">{bmi}</p>
                            <p className={`text-sm font-medium ${bmiInfo.color} mb-2`}>{bmiInfo.status}</p>
                            <p className="text-sm text-gray-700">{bmiInfo.message}</p>
                          </>
                        )
                      })()}
                    </div>
                  </div>
                )}

              {/* Target Weight BMI Calculation - Only show when user is typing */}
              {question.id === "target_weight" &&
                currentInputTargetWeight &&
                currentInputTargetWeight > 0 &&
                userHeight &&
                userHeight > 0 &&
                currentWeight &&
                currentWeight > 0 && (
                  <div className="mt-3 p-3 bg-white border border-gray-200 rounded-xl">
                    <div className="text-center">
                      <p className="text-sm text-gray-600 mb-2">Target BMI Analysis</p>
                      {(() => {
                        const currentBMI = Number.parseFloat(calculateBMI(userHeight, currentWeight))
                        const targetBMI = Number.parseFloat(calculateBMI(userHeight, currentInputTargetWeight))
                        const feedback = getTargetBMIFeedback(currentBMI, targetBMI)
                        const targetBMIInfo = getBMIStatus(targetBMI)
                        return (
                          <>
                            <div className="grid grid-cols-2 gap-4 mb-3">
                              <div>
                                <p className="text-xs text-gray-500">Current BMI</p>
                                <p className="text-lg font-bold text-gray-700">{currentBMI}</p>
                              </div>
                              <div>
                                <p className="text-xs text-gray-500">Target BMI</p>
                                <p className={`text-lg font-bold ${targetBMIInfo.color}`}>{targetBMI}</p>
                              </div>
                            </div>
                            <p className={`text-sm font-medium ${targetBMIInfo.color} mb-2`}>
                              Target: {targetBMIInfo.status}
                            </p>
                            <p className="text-sm text-gray-700 mb-3">{targetBMIInfo.message}</p>

                            {/* Achievement Level */}
                            <div
                              className={`p-3 rounded-lg ${
                                feedback.level === "Easily achievable"
                                  ? "bg-green-50 border border-green-200"
                                  : feedback.level === "Achievable"
                                    ? "bg-orange-50 border border-orange-200"
                                    : "bg-red-50 border border-red-200"
                              }`}
                            >
                              <p className={`text-sm font-medium ${feedback.color} mb-1`}>🎯 {feedback.level}</p>
                              <p className="text-sm text-gray-700">{feedback.message}</p>
                            </div>
                          </>
                        )
                      })()}
                    </div>
                  </div>
                )}

              {ageError && (
                <div className="mt-2 p-3 bg-red-50 border border-red-200 rounded-xl">
                  <p className="text-sm text-red-600 font-medium">{ageError}</p>
                </div>
              )}
            </div>
          </div>
        )}

        {(question.type === "single-choice" || question.type === "multiple-choice") && (
          <div className="space-y-3 animate-slide-up">
            {question.options.map((option, index) => (
              <Card
                key={option.id}
                className={`cursor-pointer -py-3 transition-all duration-300 hover:scale-105 border-2 ${
                  question.type === "single-choice"
                    ? answer === option.id
                      ? "border-purple-400 bg-purple-50 shadow-lg"
                      : "border-gray-200 hover:border-purple-300"
                    : selectedOptions.includes(option.id)
                      ? "border-purple-400 bg-purple-50 shadow-lg"
                      : "border-gray-200 hover:border-purple-300"
                } rounded-2xl overflow-hidden`}
                onClick={() =>
                  question.type === "single-choice" ? handleSingleChoice(option.id) : handleMultipleChoice(option.id)
                }
                style={{
                  animationDelay: `${index * 100}ms`,
                }}
              >
                <CardContent className="p-4 flex items-center space-x-4">
                  {/* Image or Emoji on the left */}
                  {option.image && (
                    <div className="w-16 h-16 relative flex-shrink-0 rounded-xl overflow-hidden">
                      <Image
                        src={option.image || "/placeholder.svg"}
                        alt={option.label}
                        fill
                        className="object-cover"
                      />
                    </div>
                  )}
                  {option.emoji && !option.image && (
                    <div className="w-16 h-16 flex-shrink-0 flex items-center justify-center bg-gradient-to-br from-purple-100 to-pink-100 rounded-xl">
                      <span className="text-2xl">{option.emoji}</span>
                    </div>
                  )}

                  {/* Text content on the right */}
                  <div className="flex-1 text-left">
                    <p className="text-base font-medium text-gray-800 leading-tight">{option.label}</p>
                    {option.description && <p className="text-sm text-gray-600 mt-1">{option.description}</p>}
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>

      {/* Fixed Bottom Button */}
      {((question.type === "input" && inputValue && !ageError) ||
        (question.type === "multiple-choice" && selectedOptions.length > 0)) && (
        <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-purple-100 p-4 shadow-lg">
          <Button
            onClick={question.type === "input" ? handleInputSubmit : onNext}
            className="w-full h-12 text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-2xl shadow-lg transition-all duration-300 hover:scale-105"
          >
            Continue
            <ArrowRight className="w-5 h-5 ml-2" />
          </Button>
        </div>
      )}
    </div>
  )
}
