"use client"

import { useState, useEffect } from "react"
import { useUser } from "@clerk/nextjs"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Star, Users, CheckCircle } from "lucide-react"
import SalesPage from "./sales"
import AutoSlider from "./testimonials"
import Image from "next/image"
import { useRouter } from "next/navigation"

interface PlanGenerationProps {
  answers: Record<string, any>
  onComplete: () => void
}

const testimonials = [
  {
    name: "Sarah M.",
    age: 52,
    rating: 5,
    text: "Lost 15kg in 3 months! I feel 20 years younger and more confident than ever. This program changed everything for me.",
  },
  {
    name: "Maria L.",
    age: 48,
    rating: 5,
    text: "My back pain is completely gone and I have so much energy now. Best decision I ever made for my health!",
  },
  {
    name: "Jennifer K.",
    age: 55,
    rating: 5,
    text: "I can finally wear the clothes I want. My confidence is through the roof and I feel amazing every day!",
  },
  {
    name: "Lisa R.",
    age: 49,
    rating: 5,
    text: "Best investment I ever made. The results speak for themselves - I'm a completely new person!",
  },
]

const progressSteps = [
  { label: "Analizzando i tuoi obiettivi", percentage: 100 },
  { label: "Analisi dei parametri del corpo", percentage: 100 },
  { label: "Scelta degli allenamenti adatti alle tue esigenze", percentage: 100 },
  { label: "Generazione del tuo piano d'azione", percentage: 100 },
]


export function PlanGeneration({ answers, onComplete }: PlanGenerationProps) {
  const { user } = useUser()
  const router = useRouter()
  const [currentStep, setCurrentStep] = useState(0)
  const [currentTestimonial, setCurrentTestimonial] = useState(0)
  const [showResults, setShowResults] = useState(false)
  const [showPricingDialog, setShowPricingDialog] = useState(false)
  const [activeUsers] = useState(Math.floor(Math.random() * 500) + 7823489)

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentStep((prev) => {
        if (prev >= progressSteps.length - 1) {
          clearInterval(timer)
          setTimeout(() => setShowResults(true), 500)
          return prev
        }
        return prev + 1
      })
    }, 1250) // 1.25 seconds per step = 5 seconds total

    return () => {
      clearInterval(timer)
    }
  }, [])

  // Manual testimonial navigation functions
  const nextTestimonial = () => {
    setCurrentTestimonial((prev) => (prev + 1) % testimonials.length)
  }

  const prevTestimonial = () => {
    setCurrentTestimonial((prev) => (prev - 1 + testimonials.length) % testimonials.length)
  }

  const goToTestimonial = (index: number) => {
    setCurrentTestimonial(index)
  }

  const calculateBMI = () => {
    // Get from localStorage as fallback
    const getStoredValue = (key: string) => {
      const fromAnswers = answers[key]
      const fromLocalStorage = typeof window !== "undefined" ? localStorage.getItem(`onboarding_${key}`) : null
      return fromAnswers || fromLocalStorage
    }

    const height = Number.parseFloat(getStoredValue("height")) / 100 // Convert cm to m
    const weight = Number.parseFloat(getStoredValue("current_weight"))
    if (height && weight) {
      return (weight / (height * height)).toFixed(1)
    }
    return "22.5" // Default
  }

  const getWeightLoss = () => {
    const getStoredValue = (key: string) => {
      const fromAnswers = answers[key]
      const fromLocalStorage = typeof window !== "undefined" ? localStorage.getItem(`onboarding_${key}`) : null
      return fromAnswers || fromLocalStorage
    }

    const current = Number.parseFloat(getStoredValue("current_weight")) || 70
    const target = Number.parseFloat(getStoredValue("target_weight")) || current - 5
    return Math.abs(current - target).toFixed(1)
  }

  const handleContinue = () => {
    router.push("/checkout")
  }

  if (showResults) {
    const currentBMI = calculateBMI()
    const weightLoss = getWeightLoss()
    const userName = user?.firstName || "Beautiful"

    // Get user's actual goals from localStorage
    const getStoredValue = (key: string) => {
      const fromAnswers = answers[key]
      const fromLocalStorage = typeof window !== "undefined" ? localStorage.getItem(`onboarding_${key}`) : null
      return fromAnswers || fromLocalStorage
    }

    const urgentGoal = getStoredValue("urgent_improvement") || "weight_loss"
    const bodyFocus = getStoredValue("body_part_focus") || "full_body"
    const currentWeight = getStoredValue("current_weight") || "65"
    const targetWeight = getStoredValue("target_weight") || "60"

    return (
      <>
        <div className="app-container bg-gradient-to-br from-rose-50 via-pink-50 to-red-50 min-h-screen pb-20">
          <div className="p-4 pt-6">


            {/* Custom Plan Chart */}
            <Card className="mb-4  border-0 shadow-xl animate-slide-up">
              <CardContent className="p-6">
                <div className="text-center mb-4">
                  <h2 className="text-xl font-bold mb-2">Il tuo piano personalizzato di 30 giorni è pronto!</h2>
                  <p className="text-sm opacity-90">Scientificamente progettato per i tuoi obiettivi</p>
                </div>

                {/* Visualizzazione del grafico dei progressi */}
                <div className="bg-white/20 rounded-2xl p-4 mb-4">
                  <div className="flex justify-between items-center mb-3">
                    <div className="text-center">
                      <p className="text-xs opacity-90">Attuale</p>
                      <p className="text-lg font-bold">{currentWeight}kg</p>
                      <p className="text-xs opacity-75">indice massa corporea {currentBMI}</p>
                    </div>
                    <div className="flex-1 mx-4">
                      <div className="relative">
                        <div className="w-full bg-white/30 rounded-full h-3">
                          <div className="bg-gradient-to-r from-yellow-400 to-green-400 h-3 rounded-full w-full animate-pulse"></div>
                        </div>
                        <div className="text-center mt-2">
                          <p className="text-xs font-bold">Trasformazione di 30 giorni</p>
                        </div>
                      </div>
                    </div>
                    <div className="text-center">
                      <p className="text-xs opacity-90">Obiettivo</p>
                      <p className="text-lg font-bold">{targetWeight}kg</p>
                      <p className="text-xs opacity-75">indice massa corporea {(Number.parseFloat(currentBMI) - 1.5).toFixed(1)}</p>
                    </div>
                  </div>
                </div>


                {/* Key Metrics */}
                <div className="grid grid-cols-3 gap-3">
                  <div className="bg-white/20 rounded-xl p-3 text-center">
                    <p className="text-lg font-bold">{weightLoss}kg</p>
                    <p className="text-xs opacity-90">Perdita di peso</p>
                  </div>
                  <div className="bg-white/20 rounded-xl p-3 text-center">
                    <p className="text-lg font-bold">30</p>
                    <p className="text-xs opacity-90">Giorni</p>
                  </div>
                  <div className="bg-white/20 rounded-xl p-3 text-center">
                    <p className="text-lg font-bold">15min</p>
                    <p className="text-xs opacity-90">Ogni giorno</p>
                  </div>
                </div>

              </CardContent>
            </Card>



            <AutoSlider />

          </div>

          {/* Fixed Bottom CTA Button */}
          <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-pink-100 p-4 shadow-lg">
            <Button
              onClick={handleContinue}
              className="w-full h-18 text-xl bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-light rounded-2xl shadow-xl transition-all duration-300 hover:scale-105 animate-slide-up leading-snug text-center whitespace-normal px-4"
              style={{ animationDelay: "0.6s" }}
            >
              Inizia il piano con 3 giorni gratis<br />vedi se ti piace
            </Button>

          </div>
        </div>
      </>
    )
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 via-pink-50 to-red-50 min-h-screen">
      <div className="p-4 pt-8">
        {/* Header */}
        <div className="text-center mb-6 animate-fade-in">
          <h1 className="text-2xl font-bold text-gray-800 mb-2">Creando il tuo</h1>
          <h2 className="text-2xl font-bold text-pink-600 mb-4">Piano personalizzato...</h2>

        </div>

        {/* Progress Steps */}
        <div className="space-y-4 mb-6">
          {progressSteps.map((step, index) => (
            <div key={index} className="animate-slide-up" style={{ animationDelay: `${index * 0.1}s` }}>
              <div className="flex justify-between items-center mb-2">
                <span className={`text-sm font-medium ${index <= currentStep ? "text-gray-800" : "text-gray-400"}`}>
                  {step.label}
                </span>
                <div className="flex items-center space-x-2">
                  {index < currentStep && <CheckCircle className="w-4 h-4 text-pink-500" />}
                  {index === currentStep && (
                    <span className="text-sm font-medium text-pink-600">{step.percentage}%</span>
                  )}
                </div>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div
                  className={`h-2 rounded-full transition-all duration-1000 ${index < currentStep
                    ? "bg-pink-500 w-full"
                    : index === currentStep
                      ? "bg-pink-500"
                      : "bg-gray-200 w-0"
                    }`}
                  style={{
                    width: index < currentStep ? "100%" : index === currentStep ? `${step.percentage}%` : "0%",
                  }}
                />
              </div>
            </div>
          ))}
        </div>

        {/* User Avatars */}
        <div
          className="flex justify-center mb-4 animate-slide-up"
          style={{ animationDelay: "0.4s" }}
        >
          <div className="flex -space-x-2">
            {["t1.png", "t2.png", "t3.png", "t4.png", "t5.png"].map((img, i) => (
              <div
                key={i}
                className="w-8 h-8 rounded-full border-2 border-white overflow-hidden flex items-center justify-center"
              >
                <img
                  src={`/testimonials/${img}`} // 👈 adjust path if needed
                  alt={`User ${i + 1}`}
                  className="w-full h-full object-cover"
                />
              </div>
            ))}
          </div>
        </div>



        {/* Trusted By */}
        <div className="text-center mb-6 animate-slide-up" style={{ animationDelay: "0.5s" }}>
          <h3 className="text-lg font-bold text-gray-800 mb-2">
            Affidato da oltre {activeUsers.toLocaleString()} clienti
          </h3>
        </div>

        <AutoSlider />
      </div>
    </div>
  )
}
