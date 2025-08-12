"use client"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, Play, Clock, Star } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"

// Demo videos for now
const exercises = [
  {
    id: 1,
    title: "Morning Energy Boost",
    description: "Start your day with renewed vitality",
    duration: "12 min",
    difficulty: "Easy",
    videoUrl: "/demo-video.mp4",
    image: "/main.png",
  },
  {
    id: 2,
    title: "Gentle Strength Builder",
    description: "Build strength safely and effectively",
    duration: "15 min",
    difficulty: "Easy",
    videoUrl: "/demo-video.mp4",
    image: "/main.png",
  },
  {
    id: 3,
    title: "Flexibility Flow",
    description: "Improve your range of motion",
    duration: "18 min",
    difficulty: "Easy",
    videoUrl: "/demo-video.mp4",
    image: "/main.png",
  },
  {
    id: 4,
    title: "Core Confidence",
    description: "Strengthen your core with confidence",
    duration: "20 min",
    difficulty: "Easy",
    videoUrl: "/demo-video.mp4",
    image: "/main.png",
  },
]

export default function ExerciseListPage({ params }: { params: { category: string; difficulty: string } }) {
  const router = useRouter()

  const getCategoryTitle = (category: string) => {
    const titles = {
      young: "Feel Young Again",
      pain: "Pain Relief",
      strength: "Build Strength",
      flexibility: "Stay Flexible",
    }
    return titles[category as keyof typeof titles] || "Premium Exercises"
  }

  const handlePlayVideo = (exercise: (typeof exercises)[0]) => {
    router.push(`/exercise/${exercise.id}`)
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
            <h1 className="senior-text-lg font-bold text-gray-800">{getCategoryTitle(params.category)}</h1>
            <p className="senior-text-sm text-gray-600">{params.difficulty} Level</p>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Content */}
      <div className="p-6">
        {/* Exercise Videos in Column Layout */}
        <div className="space-y-4">
          {exercises.map((exercise, index) => (
            <Card
              key={exercise.id}
              className="card-hover cursor-pointer border-0 shadow-md animate-slide-up rounded-3xl bg-white/80"
              style={{ animationDelay: `${index * 0.1}s` }}
              onClick={() => handlePlayVideo(exercise)}
            >
              <CardContent className="p-0">
                <div className="relative">
                  <img
                    src={exercise.image || "/placeholder.svg"}
                    alt={exercise.title}
                    className="w-full h-48 object-cover rounded-3xl"
                  />
                  <div className="absolute inset-0 bg-black/20 rounded-3xl flex items-center justify-center">
                    <div className="w-16 h-16 bg-white/90 rounded-full flex items-center justify-center shadow-lg">
                      <Play className="w-8 h-8 text-pink-500 ml-1" />
                    </div>
                  </div>
                  <Badge className="absolute top-4 right-4 bg-white/90 text-gray-700 senior-text-sm rounded-xl">
                    Premium
                  </Badge>
                </div>

                <div className="p-6">
                  <h3 className="senior-text-lg font-bold text-gray-800 mb-2">{exercise.title}</h3>
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

                  <Button className="w-full h-12 senior-text-base bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-semibold rounded-xl shadow-md transition-all duration-300 hover:scale-105">
                    <Play className="w-5 h-5 mr-2" />
                    Start Exercise
                  </Button>
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
