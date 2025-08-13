"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { useUser } from "@clerk/nextjs"
import { OnboardingIntro } from "@/components/onboarding-intro"
import { EmotionalQuestion } from "@/components/emotional-question"
import { PersonalizedPlan } from "@/components/personalized-plan"
import { PricingPlans } from "@/components/pricing-plans"
import { useSupabaseClient } from "@/lib/supabase"

import { Heart } from "lucide-react"
import { emotionalQuestions } from "@/lib/onboarding-questions"

export default function OnboardingPage() {
  const [showIntro, setShowIntro] = useState(true)
  const [currentQuestion, setCurrentQuestion] = useState(0)
  const [answers, setAnswers] = useState<Record<string, any>>({})
  const [showPlan, setShowPlan] = useState(false)
  const [showPricing, setShowPricing] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
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
    setIsLoading(true)

    // Save answers to database
    try {
      const supabase = await getSupabaseClient()
      await supabase.from("user_onboarding").insert({
        user_id: user?.id,
        answers: answers,
        completed_at: new Date().toISOString(),
      })
    } catch (error) {
      console.error("Error saving onboarding data:", error)
    }

    // Simulate plan generation
    setTimeout(() => {
      setIsLoading(false)
      setShowPlan(true)
    }, 3000)
  }

  const handleGetPlan = () => {
    setShowPlan(false)
    setShowPricing(true)
  }

  const handlePlanSelection = async (planType: "free" | "premium") => {
    // Set onboarding completed cookie
    document.cookie = "onboarding-completed=true; path=/; max-age=31536000" // 1 year

    if (planType === "free") {
      router.push("/dashboard")
    } else {
      // Handle premium plan with Stripe
      router.push("/pricing")
    }
  }

  const canGoNext = () => {
    const currentQ = emotionalQuestions[currentQuestion]
    const answer = answers[currentQ.id]

    if (currentQ.type === "input") {
      return answer && answer.toString().trim() !== ""
    }

    if (currentQ.type === "multiple-choice") {
      return answer && answer.length > 0
    }

    return !!answer
  }

  if (isLoading) {
    return (
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 flex items-center justify-center">
        <div className="text-center animate-fade-in">
          <div className="w-24 h-24 bg-gradient-to-br from-purple-400 to-pink-500 rounded-full flex items-center justify-center mb-6 mx-auto animate-pulse">
            <Heart className="w-12 h-12 text-white" />
          </div>
          <h2 className="senior-text-xl font-bold text-gray-800 mb-4">Creating Your Personalized Plan</h2>
          <p className="senior-text-base text-gray-600 mb-6">
            Analyzing your answers to design the perfect transformation journey...
          </p>
          <div className="flex justify-center space-x-2">
            <div className="w-3 h-3 bg-purple-500 rounded-full animate-bounce"></div>
            <div className="w-3 h-3 bg-purple-500 rounded-full animate-bounce" style={{ animationDelay: "0.1s" }}></div>
            <div className="w-3 h-3 bg-purple-500 rounded-full animate-bounce" style={{ animationDelay: "0.2s" }}></div>
          </div>
        </div>
      </div>
    )
  }

  if (showPricing) {
    return <PricingPlans onPlanSelect={handlePlanSelection} answers={answers} />
  }

  if (showPlan) {
    return <PersonalizedPlan answers={answers} onGetPlan={handleGetPlan} />
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
