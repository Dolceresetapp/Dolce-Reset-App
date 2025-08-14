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

export default function OnboardingPage() {
  const [showIntro, setShowIntro] = useState(true)
  const [currentQuestion, setCurrentQuestion] = useState(0)
  const [answers, setAnswers] = useState<Record<string, any>>({})
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
      generatePersonalizedPlan()
    }
  }

  const handlePrevious = () => {
    if (currentQuestion > 0) {
      setCurrentQuestion((prev) => prev - 1)
    }
  }

  const generatePersonalizedPlan = async () => {
    // Calculate BMI if we have height and weight
    if (answers.height && answers.current_weight) {
      const height = Number.parseFloat(answers.height) / 100 // Convert cm to m
      const weight = Number.parseFloat(answers.current_weight)
      const bmi = (weight / (height * height)).toFixed(1)
      setAnswers((prev) => ({ ...prev, bmi }))
    }

    // Save answers to database
    try {
      const supabase = await getSupabaseClient()
      await supabase.from("user_onboarding").insert({
        user_id: user?.id,
        answers: { ...answers, bmi: answers.bmi },
        completed_at: new Date().toISOString(),
      })
    } catch (error) {
      console.error("Error saving onboarding data:", error)
    }

    setShowPlanGeneration(true)
  }

  const handlePlanComplete = () => {
    setShowPlanGeneration(false)
    setShowPricing(true)
  }

  const handlePlanSelection = async (planType: "free" | "premium") => {
    // Set onboarding completed cookie
    document.cookie = "onboarding-completed=true; path=/; max-age=31536000" // 1 year

    if (planType === "free") {
      router.push("/dashboard")
    } else {
      router.push("/pricing")
    }
  }

  const canGoNext = () => {
    const currentQ = emotionalQuestions[currentQuestion]
    const answer = answers[currentQ.id]

    if (currentQ.type === "input") {
      return answer && answer.toString().trim() !== ""
    }

    return !!answer
  }

  if (showPricing) {
    return <PricingPlans onPlanSelect={handlePlanSelection} answers={answers} />
  }

  if (showPlanGeneration) {
    return <PlanGeneration answers={answers} onComplete={handlePlanComplete} />
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
      onAnswer={handleAnswer}
      onNext={handleNext}
      onPrevious={handlePrevious}
      canGoNext={canGoNext()}
    />
  )
}
