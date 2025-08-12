"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Menu, Play, Clock, Star, Heart, Zap, Shield, Smile, ArrowRight, Sparkles } from "lucide-react"
import { MobileMenu } from "@/components/mobile-menu"
import { BottomNavigation } from "@/components/bottom-navigation"
import Image from "next/image"

const exercises = [
  {
    id: 1,
    title: "Morning Glow Routine",
    description: "Wake up radiant and energized like never before",
    duration: "15 min",
    difficulty: "Beginner",
    category: "Glow Up",
    image: "/main.png",
    icon: Heart,
    color: "from-pink-400 to-rose-400",
    benefits: ["Glowing skin", "Youthful energy", "Feel 20 years younger"],
  },
  {
    id: 2,
    title: "Sexy Back Sculpting",
    description: "Get that confident, strong, beautiful posture",
    duration: "20 min",
    difficulty: "Beginner",
    category: "Confidence",
    image: "/main.png",
    icon: Shield,
    color: "from-emerald-400 to-teal-400",
    benefits: ["Sexy posture", "Strong & confident", "Turn heads"],
  },
  {
    id: 3,
    title: "Age-Reverse Secrets",
    description: "Look and feel decades younger with these moves",
    duration: "25 min",
    difficulty: "Easy",
    category: "Anti-aging",
    image: "/main.png",
    icon: Sparkles,
    color: "from-purple-400 to-pink-400",
    benefits: ["Look younger", "Feel vibrant", "Boost confidence"],
  },
  {
    id: 4,
    title: "Grace & Elegance",
    description: "Move with the poise and grace of a dancer",
    duration: "18 min",
    difficulty: "Beginner",
    category: "Elegance",
    image: "/main.png",
    icon: Zap,
    color: "from-orange-400 to-amber-400",
    benefits: ["Graceful movement", "Elegant posture", "Feel beautiful"],
  },
  {
    id: 5,
    title: "Flexible & Fabulous",
    description: "Achieve that youthful flexibility and vitality",
    duration: "22 min",
    difficulty: "Easy",
    category: "Flexibility",
    image: "/main.png",
    icon: Smile,
    color: "from-blue-400 to-cyan-400",
    benefits: ["Youthful flexibility", "Feel amazing", "Move like you're 30"],
  },
]

export default function Dashboard() {
  const [menuOpen, setMenuOpen] = useState(false)

  const handlePlayVideo = (exercise: (typeof exercises)[0]) => {
    // Navigate to video player
    window.location.href = `/exercise/${exercise.id}`
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 pb-20">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-pink-100">
        <div className="flex items-center justify-between p-4">
          <div>
            <h1 className="senior-text-lg font-bold text-gray-800">Good Morning!</h1>
            <p className="senior-text-sm text-gray-600">Ready for your wellness journey?</p>
          </div>
          <Button
            variant="ghost"
            size="icon"
            onClick={() => setMenuOpen(true)}
            className="h-12 w-12 rounded-2xl bg-pink-200 hover:bg-pink-100"
          >
            <Menu className="h-6 w-6 text-pink-600" />
          </Button>
        </div>
      </div>

      {/* Welcome Card */}
      <div className="p-4">
        <div className="bg-gradient-to-r from-pink-500 to-rose-500 rounded-3xl text-white border-0 shadow-lg animate-fade-in">
          <CardContent className="p-6">
            <div className="flex items-center justify-center text-center">
              <div>
                <h2 className="senior-text-lg font-bold mb-2">Your Glow-Up Awaits</h2>
                <p className="senior-text-base opacity-90 mb-4">Transform into your most confident, radiant self</p>
                <Badge className="bg-white/20 text-white border-white/30 senior-text-sm rounded-2xl">
                  ✨ Age-Reversing Secrets
                </Badge>
              </div>
            </div>
          </CardContent>
        </div>
      </div>

      {/* Exercise Categories */}
      <div className="px-4 mb-6">
        <h3 className="senior-text-lg font-semibold text-gray-800 mb-4">Choose Your Exercise</h3>

        <div className="space-y-4">
          {exercises.map((exercise, index) => (
            <div
              key={exercise.id}
              className="exercise-card card-hover rounded-3xl border-0 shadow-md animate-slide-up"
              style={{ animationDelay: `${index * 0.1}s` }}
            >
              <CardContent className="p-0">
                <div className="relative">
                  <Image
                    src={exercise.image || "/placeholder.svg"}
                    alt={exercise.title}
                    width={500}
                    height={500}
                    className="w-full h-48 object-cover rounded-3xl"
                  />
                  <div
                    className={`absolute top-4 left-4 w-12 h-12 bg-gradient-to-br ${exercise.color} rounded-full flex items-center justify-center shadow-lg`}
                  >
                    <exercise.icon className="w-6 h-6 text-white" />
                  </div>
                  <Badge className="absolute top-4 right-4 bg-white/90 text-gray-700 senior-text-sm rounded-2xl">
                    {exercise.category}
                  </Badge>
                </div>

                <div className="p-6">
                  <h4 className="senior-text-lg font-bold text-gray-800 mb-2">{exercise.title}</h4>
                  <p className="senior-text-base text-gray-600 mb-4 leading-relaxed">{exercise.description}</p>

                  <div className="flex items-center gap-4 mb-4">
                    <div className="flex items-center gap-1">
                      <Clock className="w-4 h-4 text-pink-500" />
                      <span className="senior-text-sm text-gray-600">{exercise.duration}</span>
                    </div>
                    <div className="flex items-center gap-1">
                      <Star className="w-4 h-4 text-pink-500" />
                      <span className="senior-text-sm text-gray-600">{exercise.difficulty}</span>
                    </div>
                  </div>

                  <div className="mb-4">
                    <p className="senior-text-sm font-medium text-gray-700 mb-2">Benefits:</p>
                    <div className="flex flex-wrap gap-2">
                      {exercise.benefits.map((benefit, idx) => (
                        <Badge
                          key={idx}
                          variant="secondary"
                          className="senior-text-sm bg-pink-50 text-pink-700 rounded-2xl"
                        >
                          {benefit}
                        </Badge>
                      ))}
                    </div>
                  </div>

                  <Button
                    onClick={() => handlePlayVideo(exercise)}
                    className="w-full h-12 senior-text-base bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-semibold rounded-2xl shadow-md transition-all duration-300 hover:scale-105"
                  >
                    <Play className="w-5 h-5 mr-2" />
                    Start Exercise
                    <ArrowRight className="w-5 h-5 ml-2" />
                  </Button>
                </div>
              </CardContent>
            </div>
          ))}
        </div>
      </div>

      <MobileMenu open={menuOpen} onClose={() => setMenuOpen(false)} />
      <BottomNavigation />
    </div>
  )
}
