"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { OnboardingIntro } from "@/components/onboarding-intro"
import { EmotionalQuestion } from "@/components/emotional-question"
import { SuperwallPaywall } from "@/components/superwall-paywall"
import { emotionalQuestions } from "@/lib/onboarding-questions"
import { PlanGeneration } from "@/components/plan-generations"
import { ConfirmationScreens } from "@/components/confirmation-screen"

export default function OnboardingPage() {
  const [showIntro, setShowIntro] = useState(true)
  const [currentQuestion, setCurrentQuestion] = useState(0)
  const [answers, setAnswers] = useState<Record<string, any>>({})
  const [showConfirmation, setShowConfirmation] = useState(false)
  const [showPlanGeneration, setShowPlanGeneration] = useState(false)
  const [showPricing, setShowPricing] = useState(false)
  const router = useRouter()

  const handleIntroComplete = () => {
    setShowIntro(false)
  }

  const handleAnswer = (questionId: string, answer: any) => {
    setAnswers((prev) => ({ ...prev, [questionId]: answer }))
  }

  const handleNext = () => {
    if (currentQuestion < emotionalQuestions.length - 1) {
      setCurrentQuestion((prev) => prev + 1)
    } else {
      setShowConfirmation(true)
    }
  }

  const handlePrevious = () => {
    if (currentQuestion > 0) {
      setCurrentQuestion((prev) => prev - 1)
    }
  }

  const handleConfirmationComplete = async () => {
    // Get all data from localStorage
    const getAllStoredData = () => {
      const storedData: Record<string, any> = {}
      if (typeof window !== "undefined") {
        for (let i = 0; i < localStorage.length; i++) {
          const key = localStorage.key(i)
          if (key?.startsWith("onboarding_")) {
            const cleanKey = key.replace("onboarding_", "")
            const value = localStorage.getItem(key)
            if (value) {
              try {
                storedData[cleanKey] = JSON.parse(value)
              } catch {
                storedData[cleanKey] = value
              }
            }
          }
        }
      }
      return storedData
    }

    const storedData = getAllStoredData()
    const finalAnswers = { ...answers, ...storedData }

    // Calculate BMI if we have height and weight
    if (finalAnswers.height && finalAnswers.current_weight) {
      const height = Number.parseFloat(finalAnswers.height) / 100
      const weight = Number.parseFloat(finalAnswers.current_weight)
      const bmi = (weight / (height * height)).toFixed(1)
      finalAnswers.bmi = bmi
    }

    // Store in localStorage for now
    if (typeof window !== "undefined") {
      localStorage.setItem("onboarding_answers", JSON.stringify(finalAnswers))
    }

    setAnswers(finalAnswers)
    setShowConfirmation(false)
    setShowPlanGeneration(true)
  }

  const handleConfirmationRestart = () => {
    if (typeof window !== "undefined") {
      const keys = Object.keys(localStorage)
      keys.forEach((key) => {
        if (key.startsWith("onboarding_")) {
          localStorage.removeItem(key)
        }
      })
    }

    setShowConfirmation(false)
    setShowPlanGeneration(false)
    setShowPricing(false)
    setCurrentQuestion(0)
    setAnswers({})
    setShowIntro(true)
  }

  const handlePlanComplete = () => {
    setShowPlanGeneration(false)
    setShowPricing(true)
  }

  const handleSkipPaywall = () => {
    document.cookie = "onboarding-completed=true; path=/; max-age=31536000"
    // Redirect to app download or home
    router.push("/")
  }

  const canGoNext = () => {
    const currentQ = emotionalQuestions[currentQuestion]
    const answer = answers[currentQ.id]

    if (currentQ.type === "custom-screen") {
      return true
    }

    if (currentQ.customScreenType === "hurray-screen") {
      return true
    }

    if (currentQ.type === "input") {
      return answer && answer.toString().trim() !== ""
    }

    if (currentQ.type === "multiple-choice") {
      return answer && Array.isArray(answer) && answer.length > 0
    }

    return !!answer
  }

  if (showPricing) {
    return <SuperwallPaywall answers={answers} onSkip={handleSkipPaywall} />
  }

  if (showPlanGeneration) {
    return <PlanGeneration answers={answers} onComplete={handlePlanComplete} />
  }

  if (showConfirmation) {
    return <ConfirmationScreens onComplete={handleConfirmationComplete} onRestart={handleConfirmationRestart} />
  }

  if (showIntro) {
    return <OnboardingIntro onContinue={handleIntroComplete} />
  }

  return (
    <EmotionalQuestion
      question={emotionalQuestions[currentQuestion]}
      currentStep={currentQuestion + 1}
      totalSteps={emotionalQuestions.length}
      answer={answers[emotionalQuestions[currentQuestion].id]}
      answers={answers}
      onAnswer={handleAnswer}
      onNext={handleNext}
      onPrevious={handlePrevious}
      canGoNext={canGoNext()}
    />
  )
}
