"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, ArrowRight, Heart } from "lucide-react"

interface Question {
  id: string
  title: string
  subtitle: string
  type: string
  options: string[]
}

interface OnboardingQuestionProps {
  question: Question
  currentStep: number
  totalSteps: number
  answer: any
  onAnswer: (questionId: string, answer: any) => void
  onNext: () => void
  onPrevious: () => void
  canGoNext: boolean
}

export function OnboardingQuestion({
  question,
  currentStep,
  totalSteps,
  answer,
  onAnswer,
  onNext,
  onPrevious,
  canGoNext,
}: OnboardingQuestionProps) {
  const handleOptionSelect = (option: string) => {
    if (question.type === "multiple-choice") {
      const currentAnswers = answer || []
      const newAnswers = currentAnswers.includes(option)
        ? currentAnswers.filter((a: string) => a !== option)
        : [...currentAnswers, option]
      onAnswer(question.id, newAnswers)
    } else {
      onAnswer(question.id, option)
    }
  }

  const isSelected = (option: string) => {
    if (question.type === "multiple-choice") {
      return answer?.includes(option) || false
    }
    return answer === option
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-pink-100">
        <div className="flex items-center justify-between p-4">
          <Button
            variant="ghost"
            size="icon"
            onClick={onPrevious}
            disabled={currentStep === 1}
            className="h-12 w-12 rounded-full hover:bg-pink-100"
          >
            <ArrowLeft className="h-6 w-6 text-gray-600" />
          </Button>

          <div className="flex items-center space-x-2">
            <Heart className="w-5 h-5 text-pink-500" />
            <Badge className="bg-pink-100 text-pink-700 senior-text-sm">
              {currentStep} of {totalSteps}
            </Badge>
          </div>

          <div className="w-12" />
        </div>

        {/* Progress Bar */}
        <div className="px-4 pb-4">
          <div className="w-full bg-pink-100 rounded-full h-2">
            <div
              className="bg-gradient-to-r from-pink-500 to-rose-500 h-2 rounded-full transition-all duration-500"
              style={{ width: `${(currentStep / totalSteps) * 100}%` }}
            />
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="p-6 pb-24">
        <div className="animate-fade-in">
          <h1 className="senior-text-xl font-bold text-gray-800 mb-3 leading-tight">{question.title}</h1>
          <p className="senior-text-base text-gray-600 mb-8 leading-relaxed">{question.subtitle}</p>

          <div className="space-y-4">
            {question.options.map((option, index) => (
              <Card
                key={option}
                className={`card-hover cursor-pointer transition-all duration-300 animate-slide-up ${
                  isSelected(option)
                    ? "border-pink-500 bg-gradient-to-r from-pink-50 to-rose-50 shadow-lg"
                    : "border-pink-200 bg-white/80 hover:border-pink-300"
                }`}
                style={{ animationDelay: `${index * 0.1}s` }}
                onClick={() => handleOptionSelect(option)}
              >
                <CardContent className="p-6">
                  <div className="flex items-center justify-between">
                    <span className="senior-text-base font-medium text-gray-800">{option}</span>
                    <div
                      className={`w-6 h-6 rounded-full border-2 transition-all duration-200 ${
                        isSelected(option) ? "border-pink-500 bg-pink-500" : "border-gray-300"
                      }`}
                    >
                      {isSelected(option) && <div className="w-full h-full rounded-full bg-white scale-50"></div>}
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </div>

      {/* Fixed Bottom Button */}
      <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-pink-100 p-4">
        <div className="max-w-md mx-auto">
          <Button
            onClick={onNext}
            disabled={!canGoNext}
            className="w-full h-14 senior-text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-2xl shadow-lg transition-all duration-300 hover:scale-105 disabled:opacity-50 disabled:hover:scale-100"
          >
            {currentStep === totalSteps ? "Create My Plan" : "Next"}
            <ArrowRight className="w-5 h-5 ml-2" />
          </Button>
        </div>
      </div>
    </div>
  )
}
