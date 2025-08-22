"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { useUser } from "@clerk/nextjs"
import { OnboardingIntro } from "@/components/onboarding-intro"
import { EmotionalQuestion } from "@/components/emotional-question"
import { PricingPlans } from "@/components/pricing-plans"
import { useSupabaseClient } from "@/lib/supabase"
import { emotionalQuestions } from "@/lib/onboarding-questions"
import { PlanGeneration } from "@/components/plan-generations"
import { ConfirmationScreens } from "@/components/confirmation-screen"
import ConsentNotice from "@/components/agree"

export default function OnboardingPage() {
  const [showIntro, setShowIntro] = useState(true)
  const [currentQuestion, setCurrentQuestion] = useState(0)
  const [answers, setAnswers] = useState<Record<string, any>>({})
  const [showConfirmation, setShowConfirmation] = useState(false)
  const [showPlanGeneration, setShowPlanGeneration] = useState(false)
  const [showPricing, setShowPricing] = useState(false)
  const router = useRouter()
  const { user } = useUser()
  const { getSupabaseClient } = useSupabaseClient()

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
      // All questions completed, show confirmation screens
      console.log("All questions completed, showing confirmation screens")
      setShowConfirmation(true)
    }
  }

  const handlePrevious = () => {
    if (currentQuestion > 0) {
      setCurrentQuestion((prev) => prev - 1)
    }
  }

  const handleConfirmationComplete = async () => {
    console.log("Confirmation complete, starting plan generation")

    // Get all data from localStorage as well
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
                // Try to parse JSON for arrays
                storedData[cleanKey] = JSON.parse(value)
              } catch {
                // If not JSON, store as string
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
      const height = Number.parseFloat(finalAnswers.height) / 100 // Convert cm to m
      const weight = Number.parseFloat(finalAnswers.current_weight)
      const bmi = (weight / (height * height)).toFixed(1)
      finalAnswers.bmi = bmi
    }

    // Save answers to database
    try {
      const supabase = await getSupabaseClient()
      await supabase.from("user_onboarding").insert({
        user_id: user?.id,
        answers: finalAnswers,
        completed_at: new Date().toISOString(),
      })
    } catch (error) {
      console.error("Error saving onboarding data:", error)
    }

    setAnswers(finalAnswers)
    setShowConfirmation(false)
    setShowPlanGeneration(true)
  }

  const handleConfirmationRestart = () => {
    console.log("Restarting onboarding")
    // Clear localStorage
    if (typeof window !== "undefined") {
      const keys = Object.keys(localStorage)
      keys.forEach((key) => {
        if (key.startsWith("onboarding_")) {
          localStorage.removeItem(key)
        }
      })
    }

    // Reset everything and start onboarding from beginning
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

  const handlePlanSelection = async (planType: "free" | "premium") => {
    // Set onboarding completed cookie
    document.cookie = "onboarding-completed=true; path=/; max-age=31536000" // 1 year

    if (planType === "free") {
      router.push("/features")
    } else {
      router.push("/pricing")
    }
  }

  const canGoNext = () => {
    const currentQ = emotionalQuestions[currentQuestion]
    const answer = answers[currentQ.id]

    if (currentQ.type === "custom-screen") {
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
    return <PricingPlans onPlanSelect={handlePlanSelection} answers={answers} />
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
    <>
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
    
    </>
  )
}
