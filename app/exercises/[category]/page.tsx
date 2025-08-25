"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { ArrowLeft } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"
import exerciseData from "@/data/exercises.json"

const exerciseLevels = [
  {
    id: "beginner",
    title: "Principiante",
    description: "Perfect for those just starting their fitness journey",
  },
  {
    id: "intermediate",
    title: "Intermedio",
    description: "For those with some exercise experience",
  },
]

export default function ExerciseLevelPage({ params }: { params: { category: string } }) {
  const router = useRouter()
  const [selectedLevel, setSelectedLevel] = useState<string>("")

  const getCategoryTitle = (category: string) => {
    const categoryData = exerciseData.categories[category as keyof typeof exerciseData.categories]
    return categoryData?.title || "Exercise Category"
  }

  const handleContinue = () => {
    if (selectedLevel) {
      router.push(`/exercises/${params.category}/${selectedLevel}`)
    }
  }

  return (
    <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen pb-20">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-purple-100 rounded-b-3xl">
        <div className="flex items-center justify-between p-4">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => router.back()}
            className="h-12 w-12 rounded-2xl hover:bg-purple-100"
          >
            <ArrowLeft className="h-6 w-6 text-gray-600" />
          </Button>
          <div className="text-center">
            <h1 className="text-xl font-bold text-pink-600">Seleziona Livello</h1>
            <p className="text-md text-pink-600">{getCategoryTitle(params.category)}</p>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Level Selection */}
      <div className="p-6 flex-1">
        <div className="space-y-4 mb-0">
          {exerciseLevels.map((level) => (
            <div
              key={level.id}
              className={`cursor-pointer border-2 bg-pink-100 transition-all duration-300 rounded-3xl ${
                selectedLevel === level.id
                  ? "border-purple-400 bg-purple-50 shadow-lg"
                  : "border-gray-200 hover:border-purple-300 hover:shadow-md"
              }`}
              onClick={() => setSelectedLevel(level.id)}
            >
              <div className="p-6">
                <div className="flex items-center space-x-4">
                  <div
                    className={`w-6 h-6 rounded-full border-2 border-pink-500 flex items-center justify-center ${
                      selectedLevel === level.id ? "border-pink-500 bg-pink-500" : "border-gray-300"
                    }`}
                  >
                    {selectedLevel === level.id && <div className="w-3 h-3 bg-white rounded-full"></div>}
                  </div>
                  <div>
                    <h3 className="text-lg font-semibold">{level.title}</h3>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Fixed Continue Button */}
      <div className="p-4">
        <div className="max-w-md mx-auto">
          <Button
            onClick={handleContinue}
            disabled={!selectedLevel}
            className="w-full h-14 text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-semibold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Continua
          </Button>
        </div>
      </div>

      <BottomNavigation />
    </div>
  )
}
