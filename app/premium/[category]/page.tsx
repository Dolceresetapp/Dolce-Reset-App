"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, Star, ArrowRight } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"

const difficultyLevels = [
  {
    id: "easy",
    title: "Easy Level",
    description: "Perfect for beginners or gentle recovery days",
    color: "from-green-400 to-emerald-400",
    duration: "10-15 min",
    intensity: "Low",
  },
  {
    id: "hard",
    title: "Advanced Level",
    description: "Challenge yourself with more intensive workouts",
    color: "from-red-400 to-pink-400",
    duration: "20-30 min",
    intensity: "High",
  },
]

export default function CategoryPage({ params }: { params: { category: string } }) {
  const router = useRouter()
  const [selectedCategory] = useState(params.category)

  const getCategoryTitle = (category: string) => {
    const titles = {
      young: "Feel Young Again",
      pain: "Pain Relief",
      strength: "Build Strength",
      flexibility: "Stay Flexible",
    }
    return titles[category as keyof typeof titles] || "Premium Exercises"
  }

  const handleDifficultyClick = (difficulty: string) => {
    router.push(`/premium/${selectedCategory}/${difficulty}`)
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen pb-20">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-pink-100 rounded-b-3xl">
        <div className="flex items-center justify-between p-4">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => router.back()}
            className="h-12 w-12 rounded-2xl hover:bg-pink-100"
          >
            <ArrowLeft className="h-6 w-6 text-gray-600" />
          </Button>
          <div className="text-center">
            <h1 className="senior-text-lg font-bold text-gray-800">{getCategoryTitle(selectedCategory)}</h1>
            <p className="senior-text-sm text-gray-600">Choose your difficulty level</p>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Content */}
      <div className="p-6">
        {/* Welcome Card */}
        <Card className="mb-6 bg-gradient-to-r from-pink-500 to-rose-500 text-white border-0 shadow-xl animate-fade-in rounded-3xl">
          <CardContent className="p-6">
            <div className="flex items-center justify-center text-center">
              <div>
                <h2 className="senior-text-lg font-bold mb-2">Choose Your Level</h2>
                <p className="senior-text-base opacity-90">
                  Start where you feel comfortable and progress at your own pace
                </p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Difficulty Levels */}
        <div className="space-y-4">
          {difficultyLevels.map((level, index) => (
            <Card
              key={level.id}
              className="card-hover cursor-pointer border-0 shadow-md animate-slide-up rounded-3xl bg-white/80"
              style={{ animationDelay: `${index * 0.1}s` }}
              onClick={() => handleDifficultyClick(level.id)}
            >
              <CardContent className="p-6">
                <div className="flex items-start space-x-4">
                  <div
                    className={`w-14 h-14 bg-gradient-to-br ${level.color} rounded-3xl flex items-center justify-center shadow-lg`}
                  >
                    <Star className="w-7 h-7 text-white" />
                  </div>

                  <div className="flex-1">
                    <h3 className="senior-text-lg font-bold text-gray-800 mb-2">{level.title}</h3>
                    <p className="senior-text-base text-gray-600 mb-4 leading-relaxed">{level.description}</p>

                    <div className="flex items-center gap-4 mb-4">
                      <Badge className="bg-pink-100 text-pink-700 senior-text-sm rounded-xl">{level.duration}</Badge>
                      <Badge className="bg-purple-100 text-purple-700 senior-text-sm rounded-xl">
                        {level.intensity} Intensity
                      </Badge>
                    </div>

                    <Button className="w-full h-12 senior-text-base bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-semibold rounded-xl shadow-md transition-all duration-300 hover:scale-105">
                      View Exercises
                      <ArrowRight className="w-5 h-5 ml-2" />
                    </Button>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>

      <BottomNavigation />
    </div>
  )
}
