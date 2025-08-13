"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, ArrowRight, Heart } from "lucide-react"
import Image from "next/image"

interface EmotionalQuestion {
  id: string
  title: string
  subtitle?: string
  type: "single-choice" | "multiple-choice" | "body-parts" | "input" | "slider"
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
  const handleOptionSelect = (optionId: string) => {
    if (question.type === "multiple-choice") {
      const currentAnswers = answer || []
      const newAnswers = currentAnswers.includes(optionId)
        ? currentAnswers.filter((a: string) => a !== optionId)
        : [...currentAnswers, optionId]
      onAnswer(question.id, newAnswers)
    } else {
      onAnswer(question.id, optionId)
    }
  }

  const handleInputChange = (value: string) => {
    onAnswer(question.id, value)
  }

  const isSelected = (optionId: string) => {
    if (question.type === "multiple-choice") {
      return answer?.includes(optionId) || false
    }
    return answer === optionId
  }

  return (
    <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-purple-100 rounded-b-3xl">
        <div className="flex items-center justify-between p-4">
          <Button
            variant="ghost"
            size="icon"
            onClick={onPrevious}
            disabled={currentStep === 1}
            className="h-12 w-12 rounded-full hover:bg-purple-100"
          >
            <ArrowLeft className="h-6 w-6 text-gray-600" />
          </Button>

          <div className="flex items-center space-x-2">
            <Heart className="w-5 h-5 text-purple-500" />
            <Badge className="bg-purple-100 text-purple-700 senior-text-sm rounded-xl">
              {currentStep} of {totalSteps}
            </Badge>
          </div>

          <div className="w-12" />
        </div>

        {/* Progress Bar */}
        <div className="px-4 pb-4">
          <div className="w-full bg-purple-100 rounded-full h-3">
            <div
              className="bg-gradient-to-r from-purple-500 to-pink-500 h-3 rounded-full transition-all duration-500"
              style={{ width: `${(currentStep / totalSteps) * 100}%` }}
            />
          </div>
        </div>
      </div>

      {/* Content */}
      <div className="p-6 pb-24">
        {/* Question Image */}
        {question.image && (
          <div className="text-center mb-6 animate-fade-in">
            <div className="relative w-full max-w-sm mx-auto">
              <Image
                src={question.image || "/placeholder.svg"}
                alt="Question illustration"
                width={400}
                height={300}
                className="w-full h-auto rounded-3xl shadow-lg"
              />
            </div>
          </div>
        )}

        <div className="animate-fade-in">
          <h1 className="senior-text-xl font-bold text-gray-800 mb-3 leading-tight text-center">{question.title}</h1>
          {question.subtitle && (
            <p className="senior-text-base text-gray-600 mb-8 leading-relaxed text-center">{question.subtitle}</p>
          )}

          {/* Input Type */}
          {question.type === "input" && (
            <div className="mb-8">
              <input
                type={question.inputType || "text"}
                placeholder={question.placeholder}
                value={answer || ""}
                onChange={(e) => handleInputChange(e.target.value)}
                min={question.min}
                max={question.max}
                className="w-full h-16 senior-text-lg px-6 rounded-3xl border-2 border-purple-200 focus:border-purple-500 focus:outline-none bg-white/80 text-center font-semibold"
              />
            </div>
          )}

          {/* Options */}
          {question.type !== "input" && (
            <div className="space-y-4">
              {question.options.map((option, index) => (
                <Card
                  key={option.id}
                  className={`card-hover cursor-pointer transition-all duration-300 animate-slide-up ${
                    isSelected(option.id)
                      ? "border-purple-500 bg-gradient-to-r from-purple-50 to-pink-50 shadow-xl scale-105"
                      : "border-purple-200 bg-white/80 hover:border-purple-300 hover:shadow-lg"
                  }`}
                  style={{ animationDelay: `${index * 0.1}s` }}
                  onClick={() => handleOptionSelect(option.id)}
                >
                  <CardContent className="p-6">
                    <div className="flex items-center space-x-4">
                      {/* Option Image or Emoji */}
                      {option.image ? (
                        <div className="w-16 h-16 rounded-2xl overflow-hidden flex-shrink-0 bg-white shadow-sm">
                          <Image
                            src={option.image || "/placeholder.svg"}
                            alt={option.label}
                            width={64}
                            height={64}
                            className="w-full h-full object-cover"
                          />
                        </div>
                      ) : option.emoji ? (
                        <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-purple-100 to-pink-100 flex items-center justify-center flex-shrink-0">
                          <span className="text-3xl">{option.emoji}</span>
                        </div>
                      ) : null}

                      {/* Option Content */}
                      <div className="flex-1">
                        <h3 className="senior-text-lg font-bold text-gray-800 mb-1">{option.label}</h3>
                        {option.description && <p className="senior-text-sm text-gray-600">{option.description}</p>}
                      </div>

                      {/* Selection Indicator */}
                      <div
                        className={`w-8 h-8 rounded-full border-3 transition-all duration-200 flex items-center justify-center ${
                          isSelected(option.id) ? "border-purple-500 bg-purple-500" : "border-gray-300 bg-white"
                        }`}
                      >
                        {isSelected(option.id) && <div className="w-4 h-4 rounded-full bg-white"></div>}
                      </div>
                    </div>
                  </CardContent>
                </Card>
              ))}
            </div>
          )}
        </div>
      </div>

      {/* Fixed Bottom Button */}
      <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-purple-100 p-4">
        <div className="max-w-md mx-auto">
          <Button
            onClick={onNext}
            disabled={!canGoNext}
            className="w-full h-14 senior-text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-3xl shadow-lg transition-all duration-300 hover:scale-105 disabled:opacity-50 disabled:hover:scale-100"
          >
            {currentStep === totalSteps ? "Create My Plan" : "Next"}
            <ArrowRight className="w-5 h-5 ml-2" />
          </Button>
        </div>
      </div>
    </div>
  )
}
