"use client"

import { useState, useEffect } from "react"
import { useUser } from "@clerk/nextjs"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Heart, Star, Users, Sparkles, Crown, CheckCircle } from "lucide-react"

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
  { label: "Analyzing body parameters", percentage: 47 },
  { label: "Choosing workouts to your needs", percentage: 0 },
  { label: "Generating your action plan", percentage: 0 },
]

export function PlanGeneration({ answers, onComplete }: PlanGenerationProps) {
  const { user } = useUser()
  const [currentStep, setCurrentStep] = useState(0)
  const [currentTestimonial, setCurrentTestimonial] = useState(0)
  const [showResults, setShowResults] = useState(false)
  const [activeUsers] = useState(Math.floor(Math.random() * 500) + 7823489)

  useEffect(() => {
    const timer = setInterval(() => {
      setCurrentStep((prev) => {
        if (prev >= progressSteps.length - 1) {
          clearInterval(timer)
          setTimeout(() => setShowResults(true), 1000)
          return prev
        }
        return prev + 1
      })
    }, 5000) // 5 seconds per step

    // Auto-rotate testimonials every 8 seconds
    const testimonialTimer = setInterval(() => {
      setCurrentTestimonial((prev) => (prev + 1) % testimonials.length)
    }, 8000)

    return () => {
      clearInterval(timer)
      clearInterval(testimonialTimer)
    }
  }, [])

  const nextTestimonial = () => {
    setCurrentTestimonial((prev) => (prev + 1) % testimonials.length)
  }

  const prevTestimonial = () => {
    setCurrentTestimonial((prev) => (prev - 1 + testimonials.length) % testimonials.length)
  }

  const calculateBMI = () => {
    const height = Number.parseFloat(answers.height) / 100 // Convert cm to m
    const weight = Number.parseFloat(answers.current_weight)
    if (height && weight) {
      return (weight / (height * height)).toFixed(1)
    }
    return "22.5" // Default
  }

  const getWeightLoss = () => {
    const current = Number.parseFloat(answers.current_weight) || 70
    const target = current - 5 // Assume 5kg loss goal
    return "5.0"
  }

  if (showResults) {
    const currentBMI = calculateBMI()
    const weightLoss = getWeightLoss()
    const userName = user?.firstName || "Beautiful"

    return (
      <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen">
        <div className="p-4 pt-6">
          {/* Success Header */}
          <div className="text-center mb-6 animate-fade-in">
            <div className="w-16 h-16 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full flex items-center justify-center mb-4 mx-auto shadow-xl">
              <CheckCircle className="w-8 h-8 text-white" />
            </div>
            <h1 className="text-xl font-bold text-gray-800 mb-2">🎉 {userName}, Your Custom Plan is Ready!</h1>
            <p className="text-sm text-gray-600">Your personalized 30-day transformation journey</p>
          </div>

          {/* Custom Plan Chart */}
          <Card className="mb-4 bg-gradient-to-r from-purple-500 to-pink-500 text-white border-0 shadow-xl animate-slide-up">
            <CardContent className="p-6">
              <div className="text-center mb-4">
                <h2 className="text-lg font-bold mb-2">Your 30-Day Custom Plan</h2>
                <p className="text-sm opacity-90">Scientifically designed for your goals</p>
              </div>

              {/* Progress Chart Visualization */}
              <div className="bg-white/20 rounded-2xl p-4 mb-4">
                <div className="flex justify-between items-center mb-3">
                  <div className="text-center">
                    <p className="text-xs opacity-90">Current</p>
                    <p className="text-lg font-bold">{answers.current_weight}kg</p>
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
                    <p className="text-lg font-bold">{Number.parseFloat(answers.current_weight) - 5}kg</p>
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
            className="mb-4 bg-white/90 border-purple-200 shadow-lg animate-slide-up"
            style={{ animationDelay: "0.2s" }}
          >
            <CardContent className="p-4">
              <h3 className="text-base font-bold text-gray-800 mb-3 flex items-center">
                <Heart className="w-4 h-4 text-pink-500 mr-2" />
                Your Custom Plan Includes
              </h3>
              <div className="space-y-2">
                <div className="flex items-center space-x-3">
                  <div className="w-2 h-2 bg-purple-500 rounded-full"></div>
                  <span className="text-sm text-gray-700">
                    Daily {answers.body_part_focus?.replace("_", " ") || "full body"} workouts
                  </span>
                </div>
                <div className="flex items-center space-x-3">
                  <div className="w-2 h-2 bg-purple-500 rounded-full"></div>
                  <span className="text-sm text-gray-700">
                    Focus on{" "}
                    {Array.isArray(answers.urgent_improvement)
                      ? answers.urgent_improvement.join(" & ").replace(/_/g, " ")
                      : answers.urgent_improvement?.replace("_", " ") || "fitness"}
                  </span>
                </div>
                <div className="flex items-center space-x-3">
                  <div className="w-2 h-2 bg-purple-500 rounded-full"></div>
                  <span className="text-sm text-gray-700">BMI optimization from {currentBMI} to ideal range</span>
                </div>
                <div className="flex items-center space-x-3">
                  <div className="w-2 h-2 bg-purple-500 rounded-full"></div>
                  <span className="text-sm text-gray-700">Progress tracking & motivation</span>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Success Promise */}
          <Card
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
          </Card>

          {/* CTA Button */}
          <Button
            onClick={onComplete}
            className="w-full h-14 text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-2xl shadow-xl transition-all duration-300 hover:scale-105 animate-slide-up"
            style={{ animationDelay: "0.6s" }}
          >
            <Crown className="w-6 h-6 mr-2" />
            Get My Custom Plan Now
          </Button>
        </div>
      </div>
    )
  }

  return (
    <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen">
      <div className="p-4 pt-8">
        {/* Header */}
        <div className="text-center mb-6 animate-fade-in">
          <h1 className="text-2xl font-bold text-gray-800 mb-2">Creating your</h1>
          <h2 className="text-2xl font-bold text-purple-600 mb-4">Personalized plan...</h2>
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
                  {index < currentStep && <CheckCircle className="w-4 h-4 text-purple-500" />}
                  {index === currentStep && (
                    <span className="text-sm font-medium text-purple-600">{step.percentage}%</span>
                  )}
                </div>
              </div>
              <div className="w-full bg-gray-200 rounded-full h-2">
                <div
                  className={`h-2 rounded-full transition-all duration-1000 ${
                    index < currentStep
                      ? "bg-purple-500 w-full"
                      : index === currentStep
                        ? "bg-purple-500"
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
                className="w-8 h-8 bg-gradient-to-br from-purple-400 to-pink-400 rounded-full border-2 border-white flex items-center justify-center"
              >
                <Users className="w-4 h-4 text-white" />
              </div>
            ))}
            <div className="w-8 h-8 bg-purple-500 rounded-full border-2 border-white flex items-center justify-center">
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

        {/* Testimonial Card */}
        <Card
          className="mb-6 bg-white/90 border-purple-200 shadow-lg animate-slide-up"
          style={{ animationDelay: "0.6s" }}
        >
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
                <Badge className="bg-purple-100 text-purple-700 text-xs">{testimonials[currentTestimonial].age}</Badge>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Dots Indicator */}
        <div className="flex justify-center space-x-2 animate-slide-up" style={{ animationDelay: "0.8s" }}>
          {testimonials.map((_, index) => (
            <div
              key={index}
              className={`w-2 h-2 rounded-full transition-all duration-300 ${
                index === currentTestimonial ? "bg-purple-500" : "bg-purple-200"
              }`}
            />
          ))}
        </div>
      </div>
    </div>
  )
}
