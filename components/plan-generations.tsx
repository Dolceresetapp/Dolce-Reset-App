"use client"

import { useState, useEffect } from "react"
import { useUser } from "@clerk/nextjs"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Heart, Star, Users, Sparkles, CheckCircle, ChevronLeft, ChevronRight } from "lucide-react"
import { PricingDialog } from "./pricing-dialog"
import SalesPage from "./sales"
import AutoSlider from "./testimonials"

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
  { label: "Scanning your goals", percentage: 100 },
  { label: "Analyzing body parameters", percentage: 100 },
  { label: "Choosing workouts to your needs", percentage: 100 },
  { label: "Generating your action plan", percentage: 100 },
]

export function PlanGeneration({ answers, onComplete }: PlanGenerationProps) {
  const { user } = useUser()
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
            {/* Success Header */}
            {/* <div className="text-center mb-6 animate-fade-in">
              <div className="w-16 h-16 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full flex items-center justify-center mb-4 mx-auto shadow-xl">
                <CheckCircle className="w-8 h-8 text-white" />
              </div>
              <h1 className="text-xl font-bold text-gray-800 mb-2">🎉 {userName}, Your Custom Plan is Ready!</h1>
              <p className="text-sm text-gray-600">Your personalized 30-day transformation journey</p>
            </div> */}

            {/* Custom Plan Chart */}
            <Card className="mb-4  border-0 shadow-xl animate-slide-up">
              <CardContent className="p-6">
                <div className="text-center mb-4">
                  <h2 className="text-4xl font-bold mb-2">Your 30-Day Custom Plan</h2>
                  <p className="text-sm opacity-90">Scientifically designed for your goals</p>
                </div>

                {/* Progress Chart Visualization */}
                <div className="bg-white/20 rounded-2xl p-4 mb-4">
                  <div className="flex justify-between items-center mb-3">
                    <div className="text-center">
                      <p className="text-xs opacity-90">Current</p>
                      <p className="text-lg font-bold">{currentWeight}kg</p>
                      <p className="text-xs opacity-75">BMI {currentBMI}</p>
                    </div>
                    <div className="flex-1 mx-4">
                      <div className="relative">
                        <div className="w-full bg-white/30 rounded-full h-3">
                          <div className="bg-gradient-to-r from-yellow-400 to-green-400 h-3 rounded-full w-full animate-pulse"></div>
                        </div>
                        <div className="text-center mt-2">
                          <p className="text-xs font-bold">30 Days Transformation</p>
                        </div>
                      </div>
                    </div>
                    <div className="text-center">
                      <p className="text-xs opacity-90">Target</p>
                      <p className="text-lg font-bold">{targetWeight}kg</p>
                      <p className="text-xs opacity-75">BMI {(Number.parseFloat(currentBMI) - 1.5).toFixed(1)}</p>
                    </div>
                  </div>
                </div>

                {/* Key Metrics */}
                <div className="grid grid-cols-3 gap-3">
                  <div className="bg-white/20 rounded-xl p-3 text-center">
                    <p className="text-lg font-bold">{weightLoss}kg</p>
                    <p className="text-xs opacity-90">Weight Loss</p>
                  </div>
                  <div className="bg-white/20 rounded-xl p-3 text-center">
                    <p className="text-lg font-bold">30</p>
                    <p className="text-xs opacity-90">Days</p>
                  </div>
                  <div className="bg-white/20 rounded-xl p-3 text-center">
                    <p className="text-lg font-bold">15min</p>
                    <p className="text-xs opacity-90">Daily</p>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Custom Plan Features */}
            <Card
              className="mb-4 bg-white/90 border-pink-200 shadow-lg animate-slide-up"
              style={{ animationDelay: "0.2s" }}
            >
              <CardContent className="p-4">
                <h3 className="text-base font-bold text-gray-800 mb-3 flex items-center">
                  <Heart className="w-4 h-4 text-pink-500 mr-2" />
                  Your Custom Plan Includes
                </h3>
                <div className="space-y-2">
                  <div className="flex items-center space-x-3">
                    <div className="w-2 h-2 bg-pink-500 rounded-full"></div>
                    <span className="text-sm text-gray-700">
                      Daily {bodyFocus?.replace("_", " ") || "full body"} workouts
                    </span>
                  </div>
                  <div className="flex items-center space-x-3">
                    <div className="w-2 h-2 bg-pink-500 rounded-full"></div>
                    <span className="text-sm text-gray-700">
                      Focus on {urgentGoal?.replace("_", " ") || "fitness goals"}
                    </span>
                  </div>
                  <div className="flex items-center space-x-3">
                    <div className="w-2 h-2 bg-pink-500 rounded-full"></div>
                    <span className="text-sm text-gray-700">BMI optimization from {currentBMI} to ideal range</span>
                  </div>
                  <div className="flex items-center space-x-3">
                    <div className="w-2 h-2 bg-pink-500 rounded-full"></div>
                    <span className="text-sm text-gray-700">Progress tracking & motivation</span>
                  </div>
                </div>
              </CardContent>
            </Card>

            <AutoSlider />

            {/* Success Promise */}
            {/* <Card
              className="mb-6 bg-gradient-to-r from-green-50 to-emerald-50 border-green-200 shadow-lg animate-slide-up"
              style={{ animationDelay: "0.4s" }}
            >
              <CardContent className="p-4 text-center">
                <Sparkles className="w-8 h-8 text-green-500 mx-auto mb-2" />
                <h4 className="text-base font-bold text-gray-800 mb-2">Your Success is Guaranteed!</h4>
                <p className="text-sm text-gray-600 leading-relaxed">
                  This custom plan is designed specifically for your body type, goals, and lifestyle. Join{" "}
                  {activeUsers.toLocaleString()}+ women already transforming!
                </p>
              </CardContent>
            </Card> */}
            <SalesPage />
          </div>

          {/* Fixed Bottom CTA Button */}
          <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-pink-100 p-4 shadow-lg">
            <Button
              onClick={() => setShowPricingDialog(true)}
              className="w-full h-18 text-xl bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-light rounded-2xl shadow-xl transition-all duration-300 hover:scale-105 animate-slide-up"
              style={{ animationDelay: "0.6s" }}
            >
              <div className="flex flex-col items-center">
                <span>Get My Custom Plan</span>
                <span className="">Start now Free 3 Days</span>
              </div>
            </Button>
          </div>
        </div>

        {/* Pricing Dialog */}
        <PricingDialog open={showPricingDialog} onOpenChange={setShowPricingDialog} />
      </>
    )
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 via-pink-50 to-red-50 min-h-screen">
      <div className="p-4 pt-8">
        {/* Header */}
        <div className="text-center mb-6 animate-fade-in">
          <h1 className="text-2xl font-bold text-gray-800 mb-2">Creating your</h1>
          <h2 className="text-2xl font-bold text-pink-600 mb-4">Personalized plan...</h2>
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
                  className={`h-2 rounded-full transition-all duration-1000 ${
                    index < currentStep
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
        <div className="flex justify-center mb-4 animate-slide-up" style={{ animationDelay: "0.4s" }}>
          <div className="flex -space-x-2">
            {[1, 2, 3, 4, 5].map((i) => (
              <div
                key={i}
                className="w-8 h-8 bg-gradient-to-br from-pink-400 to-rose-400 rounded-full border-2 border-white flex items-center justify-center"
              >
                <Users className="w-4 h-4 text-white" />
              </div>
            ))}
            <div className="w-8 h-8 bg-pink-500 rounded-full border-2 border-white flex items-center justify-center">
              <Star className="w-4 h-4 text-white" />
            </div>
          </div>
        </div>

        {/* Trusted By */}
        <div className="text-center mb-6 animate-slide-up" style={{ animationDelay: "0.5s" }}>
          <h3 className="text-lg font-bold text-gray-800 mb-2">
            Trusted by over {activeUsers.toLocaleString()} clients
          </h3>
        </div>

        {/* Manual Testimonial Card with Navigation */}
        <div className="relative mb-6 animate-slide-up" style={{ animationDelay: "0.6s" }}>
          <Card className="bg-white/90 border-pink-200 shadow-lg">
            <CardContent className="p-6">
              <div className="text-center">
                {/* Rating Stars */}
                <div className="flex items-center justify-center space-x-1 mb-4">
                  {[...Array(testimonials[currentTestimonial].rating)].map((_, i) => (
                    <Star key={i} className="w-5 h-5 fill-yellow-400 text-yellow-400" />
                  ))}
                </div>

                {/* Review Text */}
                <p className="text-sm text-gray-700 leading-relaxed mb-4 italic">
                  "{testimonials[currentTestimonial].text}"
                </p>

                {/* Author */}
                <div className="flex items-center justify-center space-x-2">
                  <p className="text-sm font-bold text-gray-800">{testimonials[currentTestimonial].name}</p>
                  <Badge className="bg-pink-100 text-pink-700 text-xs">{testimonials[currentTestimonial].age}</Badge>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Navigation Arrows */}
          <Button
            onClick={prevTestimonial}
            variant="outline"
            size="icon"
            className="absolute left-2 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-white/90 border-pink-200 hover:bg-pink-50 hover:border-pink-300 shadow-lg"
          >
            <ChevronLeft className="w-5 h-5 text-pink-600" />
          </Button>

          <Button
            onClick={nextTestimonial}
            variant="outline"
            size="icon"
            className="absolute right-2 top-1/2 -translate-y-1/2 w-10 h-10 rounded-full bg-white/90 border-pink-200 hover:bg-pink-50 hover:border-pink-300 shadow-lg"
          >
            <ChevronRight className="w-5 h-5 text-pink-600" />
          </Button>
        </div>

        {/* Clickable Dots Indicator */}
        <div className="flex justify-center space-x-2 animate-slide-up" style={{ animationDelay: "0.8s" }}>
          {testimonials.map((_, index) => (
            <button
              key={index}
              onClick={() => goToTestimonial(index)}
              className={`w-3 h-3 rounded-full transition-all duration-300 ${
                index === currentTestimonial ? "bg-pink-500 scale-110" : "bg-pink-200 hover:bg-pink-300"
              }`}
            />
          ))}
        </div>
      </div>
    </div>
  )
}
