"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { useUser } from "@clerk/nextjs"
import { OnboardingQuestion } from "@/components/onboarding-question"
import { PersonalizedPlan } from "@/components/personalized-plan"
import { PricingPlans } from "@/components/pricing-plans"
import { useSupabaseClient } from "@/lib/supabase"
import { Heart } from "lucide-react"

const questions = [
  {
    id: "age",
    title: "What's your age?",
    subtitle: "This helps us create the perfect plan for you",
    type: "age-selector",
    options: ["40-50", "51-60", "61-70", "71+"],
  },
  {
    id: "fitness_level",
    title: "How would you describe your current fitness level?",
    subtitle: "Be honest - we'll meet you where you are",
    type: "single-choice",
    options: ["Complete Beginner", "Some Experience", "Fairly Active", "Very Active"],
  },
  {
    id: "primary_goal",
    title: "What's your main goal?",
    subtitle: "Choose what matters most to you right now",
    type: "single-choice",
    options: ["Lose Weight", "Reduce Pain", "Feel Younger", "Build Strength", "Improve Balance", "Boost Energy"],
  },
  {
    id: "health_conditions",
    title: "Do you have any health concerns?",
    subtitle: "We'll customize exercises to keep you safe",
    type: "multiple-choice",
    options: ["Back Pain", "Knee Problems", "Arthritis", "High Blood Pressure", "Diabetes", "None of the above"],
  },
  {
    id: "workout_time",
    title: "How much time can you dedicate daily?",
    subtitle: "Even 10 minutes can make a difference",
    type: "single-choice",
    options: ["10-15 minutes", "15-20 minutes", "20-30 minutes", "30+ minutes"],
  },
  {
    id: "preferred_time",
    title: "When do you prefer to exercise?",
    subtitle: "Let's fit this into your routine",
    type: "single-choice",
    options: ["Early Morning", "Mid Morning", "Afternoon", "Evening", "Flexible"],
  },
  {
    id: "motivation",
    title: "What motivates you most?",
    subtitle: "We'll use this to keep you inspired",
    type: "single-choice",
    options: ["Looking Great", "Feeling Strong", "Being Independent", "Having Energy", "Reducing Pain"],
  },
  {
    id: "exercise_preference",
    title: "What type of exercises appeal to you?",
    subtitle: "Choose what sounds most enjoyable",
    type: "multiple-choice",
    options: ["Gentle Stretching", "Light Cardio", "Strength Training", "Balance Work", "Yoga-style", "Dance-inspired"],
  },
  {
    id: "current_activity",
    title: "How active are you currently?",
    subtitle: "This helps us start at the right level",
    type: "single-choice",
    options: ["Mostly Sedentary", "Light Walking", "Some Exercise", "Regular Exercise"],
  },
  {
    id: "biggest_challenge",
    title: "What's your biggest fitness challenge?",
    subtitle: "We'll help you overcome this",
    type: "single-choice",
    options: ["Lack of Time", "Low Energy", "Physical Limitations", "Don't Know Where to Start", "Staying Motivated"],
  },
]

export default function OnboardingPage() {
  const [currentQuestion, setCurrentQuestion] = useState(0)
  const [answers, setAnswers] = useState<Record<string, any>>({})
  const [showPlan, setShowPlan] = useState(false)
  const [showPricing, setShowPricing] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const router = useRouter()
  const { user } = useUser()
  const { getSupabaseClient } = useSupabaseClient()

  const handleAnswer = (questionId: string, answer: any) => {
    setAnswers((prev) => ({ ...prev, [questionId]: answer }))
  }

  const handleNext = () => {
    if (currentQuestion < questions.length - 1) {
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
      router.push("/checkout")
    }
  }

  if (isLoading) {
    return (
      <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 flex items-center justify-center">
        <div className="text-center animate-fade-in">
          <div className="w-24 h-24 bg-gradient-to-br from-pink-400 to-rose-500 rounded-full flex items-center justify-center mb-6 mx-auto animate-pulse">
            <Heart className="w-12 h-12 text-white" />
          </div>
          <h2 className="senior-text-xl font-bold text-gray-800 mb-4">Creating Your Personalized Plan</h2>
          <p className="senior-text-base text-gray-600 mb-6">
            Analyzing your answers to design the perfect fitness journey...
          </p>
          <div className="flex justify-center space-x-2">
            <div className="w-3 h-3 bg-pink-500 rounded-full animate-bounce"></div>
            <div className="w-3 h-3 bg-pink-500 rounded-full animate-bounce" style={{ animationDelay: "0.1s" }}></div>
            <div className="w-3 h-3 bg-pink-500 rounded-full animate-bounce" style={{ animationDelay: "0.2s" }}></div>
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

  return (
    <OnboardingQuestion
      question={questions[currentQuestion]}
      currentStep={currentQuestion + 1}
      totalSteps={questions.length}
      answer={answers[questions[currentQuestion].id]}
      onAnswer={handleAnswer}
      onNext={handleNext}
      onPrevious={handlePrevious}
      canGoNext={!!answers[questions[currentQuestion].id]}
    />
  )
}
