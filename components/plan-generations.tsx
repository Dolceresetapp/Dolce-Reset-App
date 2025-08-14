"use client"

import { useState, useEffect } from "react"
import { useUser } from "@clerk/nextjs"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Heart, Star, Users, TrendingUp, Sparkles, Crown, CheckCircle, ChevronLeft, ChevronRight } from "lucide-react"
import Image from "next/image"

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

export function PlanGeneration({ answers, onComplete }: PlanGenerationProps) {
  const { user } = useUser()
  const [progress, setProgress] = useState(0)
  const [currentTestimonial, setCurrentTestimonial] = useState(0)
  const [showResults, setShowResults] = useState(false)
  const [activeUsers] = useState(Math.floor(Math.random() * 500) + 2847)

  useEffect(() => {
    const timer = setInterval(() => {
      setProgress((prev) => {
        if (prev >= 100) {
          clearInterval(timer)
          setTimeout(() => setShowResults(true), 500)
          return 100
        }
        return prev + 2.5 // Slower progress for 40 seconds (100 / 2.5 = 40 seconds)
      })
    }, 1000) // Update every second

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

  const calculateTargetBMI = () => {
    const height = Number.parseFloat(answers.height) / 100 // Convert cm to m
    const targetWeight = Number.parseFloat(answers.target_weight)
    if (height && targetWeight) {
      return (targetWeight / (height * height)).toFixed(1)
    }
    return "20.5" // Default
  }

  const getWeightLoss = () => {
    const current = Number.parseFloat(answers.current_weight) || 70
    const target = Number.parseFloat(answers.target_weight) || 60
    return Math.abs(current - target).toFixed(1)
  }

  if (showResults) {
    const currentBMI = calculateBMI()
    const targetBMI = calculateTargetBMI()
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
                    <p className="text-lg font-bold">{answers.target_weight}kg</p>
                    <p className="text-xs opacity-75">BMI {targetBMI}</p>
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
                  <span className="text-sm text-gray-700">Daily {answers.body_part_focus || "full body"} workouts</span>
                </div>
                <div className="flex items-center space-x-3">
                  <div className="w-2 h-2 bg-purple-500 rounded-full"></div>
                  <span className="text-sm text-gray-700">Personalized for {answers.age || "your age"} group</span>
                </div>
                <div className="flex items-center space-x-3">
                  <div className="w-2 h-2 bg-purple-500 rounded-full"></div>
                  <span className="text-sm text-gray-700">
                    Focus on {answers.urgent_improvement?.replace("_", " ") || "fitness"}
                  </span>
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
          <div className="w-16 h-16 bg-gradient-to-br from-purple-400 to-pink-500 rounded-full flex items-center justify-center mb-4 mx-auto shadow-xl animate-pulse">
            <Heart className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-xl font-bold text-gray-800 mb-2">
            Creating Your Custom Plan, {user?.firstName || "Beautiful"}!
          </h1>
          <p className="text-sm text-gray-600">Analyzing your data for the perfect 30-day transformation...</p>
        </div>

        {/* Progress Bar */}
        <div className="mb-6 animate-slide-up">
          <div className="flex justify-between items-center mb-2">
            <span className="text-sm font-medium text-gray-700">Building Your Custom Plan</span>
            <span className="text-sm font-medium text-purple-600">{Math.round(progress)}%</span>
          </div>
          <div className="w-full bg-purple-100 rounded-full h-3">
            <div
              className="bg-gradient-to-r from-purple-500 to-pink-500 h-3 rounded-full transition-all duration-1000"
              style={{ width: `${progress}%` }}
            />
          </div>
        </div>

        {/* Before/After Image */}
        <Card
          className="mb-4 bg-white/90 border-purple-200 shadow-lg animate-slide-up"
          style={{ animationDelay: "0.2s" }}
        >
          <CardContent className="p-4">
            <h3 className="text-base font-bold text-gray-800 mb-3 text-center">Real 30-Day Transformations</h3>
            <div className="relative rounded-xl overflow-hidden">
              <Image
                src="/bodyparts/beforeafter.png"
                alt="Before and after transformation"
                width={400}
                height={500}
                className="w-full h-[500px] object-contain rounded-3xl"
              />
              {/* <div className="absolute inset-0 bg-gradient-to-t from-black/50 to-transparent flex items-end">
                <div className="p-3 text-white">
                  <p className="text-sm font-bold">Amazing Results in Just 30 Days!</p>
                  <p className="text-xs opacity-90">Your custom plan delivers real results</p>
                </div>
              </div> */}
            </div>
          </CardContent>
        </Card>

        {/* Live Stats */}
        <div className="grid grid-cols-2 gap-3 mb-4 animate-slide-up" style={{ animationDelay: "0.3s" }}>
          <Card className="bg-gradient-to-r from-blue-50 to-cyan-50 border-blue-200">
            <CardContent className="p-3 text-center">
              <Users className="w-5 h-5 text-blue-500 mx-auto mb-1" />
              <p className="text-sm font-bold text-gray-800">{activeUsers.toLocaleString()}</p>
              <p className="text-xs text-gray-600">Active Users</p>
            </CardContent>
          </Card>
          <Card className="bg-gradient-to-r from-green-50 to-emerald-50 border-green-200">
            <CardContent className="p-3 text-center">
              <TrendingUp className="w-5 h-5 text-green-500 mx-auto mb-1" />
              <p className="text-sm font-bold text-gray-800">94%</p>
              <p className="text-xs text-gray-600">Success Rate</p>
            </CardContent>
          </Card>
        </div>

        {/* Testimonial Slider - No Profile Images */}
        <Card
          className="mb-4 bg-white/90 border-purple-200 shadow-lg animate-slide-up"
          style={{ animationDelay: "0.4s" }}
        >
          <CardContent className="p-4">
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-base font-bold text-gray-800">Success Stories</h3>
              <div className="flex space-x-2">
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={prevTestimonial}
                  className="h-8 w-8 rounded-full hover:bg-purple-100"
                >
                  <ChevronLeft className="h-4 w-4" />
                </Button>
                <Button
                  variant="ghost"
                  size="icon"
                  onClick={nextTestimonial}
                  className="h-8 w-8 rounded-full hover:bg-purple-100"
                >
                  <ChevronRight className="h-4 w-4" />
                </Button>
              </div>
            </div>

            <div className="text-center">
              {/* Rating Stars */}
              <div className="flex items-center justify-center space-x-1 mb-3">
                {[...Array(testimonials[currentTestimonial].rating)].map((_, i) => (
                  <Star key={i} className="w-4 h-4 fill-yellow-400 text-yellow-400" />
                ))}
              </div>

              {/* Review Text */}
              <p className="text-sm text-gray-700 leading-relaxed mb-3 italic">
                "{testimonials[currentTestimonial].text}"
              </p>

              {/* Author - No Profile Image */}
              <div className="flex items-center justify-center space-x-2">
                <p className="text-sm font-bold text-gray-800">{testimonials[currentTestimonial].name}</p>
                <Badge className="bg-purple-100 text-purple-700 text-xs">
                  Age {testimonials[currentTestimonial].age}
                </Badge>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Dots Indicator */}
        <div className="flex justify-center space-x-2 animate-slide-up" style={{ animationDelay: "0.6s" }}>
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
