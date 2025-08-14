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

  useEffect(() => {
    if (question.type === "input") {
      setInputValue(answer || "")
    } else if (question.type === "multiple-choice") {
      setSelectedOptions(Array.isArray(answer) ? answer : [])
    }
  }, [question.id, answer, question.type])

  const handleInputChange = (value: string) => {
    setInputValue(value)
    onAnswer(question.id, value)
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
    if (inputValue.trim()) {
      onNext()
    }
  }

  if (question.type === "custom-screen") {
    return <CustomScreen type={question.customScreenType || ""} answers={answers} onContinue={onNext} />
  }

  return (
    <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen flex flex-col">
      {/* Progress Bar */}
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

      {/* Content */}
      <div className="flex-1 p-4">
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
            </div>
            {inputValue && (
              <Button
                onClick={handleInputSubmit}
                className="w-full h-12 text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-2xl shadow-lg transition-all duration-300 hover:scale-105"
              >
                Continue
                <ArrowRight className="w-5 h-5 ml-2" />
              </Button>
            )}
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

        {question.type === "multiple-choice" && selectedOptions.length > 0 && (
          <div className="mt-6">
            <Button
              onClick={onNext}
              className="w-full h-12 text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-2xl shadow-lg transition-all duration-300 hover:scale-105"
            >
              Continue
              <ArrowRight className="w-5 h-5 ml-2" />
            </Button>
          </div>
        )}
      </div>
    </div>
  )
}
