"use client"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, Heart, Zap, Shield, Smile, ArrowRight } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"

const categories = [
  {
    id: "young",
    title: "Feel Young Again",
    description: "Exercises to restore youthful energy and vitality",
    icon: Heart,
    color: "from-pink-500 to-rose-500",
    image: "/main.png",
  },
  {
    id: "pain",
    title: "Pain Relief",
    description: "Gentle movements to reduce aches and pains",
    icon: Shield,
    color: "from-blue-500 to-cyan-500",
    image: "/main.png",
  },
  {
    id: "strength",
    title: "Build Strength",
    description: "Safe strength training for mature women",
    icon: Zap,
    color: "from-green-500 to-emerald-500",
    image: "/main.png",
  },
  {
    id: "flexibility",
    title: "Stay Flexible",
    description: "Maintain and improve your flexibility",
    icon: Smile,
    color: "from-purple-500 to-pink-500",
    image: "/main.png",
  },
]

export default function PremiumExercisesPage() {
  const router = useRouter()

  const handleCategoryClick = (categoryId: string) => {
    router.push(`/premium/${categoryId}`)
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
            <h1 className="senior-text-lg font-bold text-gray-800">Premium Exercises</h1>
            <p className="senior-text-sm text-gray-600">Choose your focus area</p>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Content */}
      <div className="p-6">
        {/* Welcome Card */}
        <Card className="mb-6 bg-gradient-to-r from-amber-500 to-orange-500 text-white border-0 shadow-xl animate-fade-in rounded-3xl">
          <CardContent className="p-6">
            <div className="flex items-center justify-center text-center">
              <div>
                <h2 className="senior-text-lg font-bold mb-2">Premium Exercise Categories</h2>
                <p className="senior-text-base opacity-90">Choose the area you want to focus on today</p>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Categories Grid */}
        <div className="space-y-4">
          {categories.map((category, index) => (
            <Card
              key={category.id}
              className="card-hover cursor-pointer border-0 shadow-md animate-slide-up rounded-3xl bg-white/80"
              style={{ animationDelay: `${index * 0.1}s` }}
              onClick={() => handleCategoryClick(category.id)}
            >
              <CardContent className="p-0">
                <div className="relative">
                  <img
                    src={category.image || "/placeholder.svg"}
                    alt={category.title}
                    className="w-full h-48 object-cover rounded-3xl"
                  />
                  <div
                    className={`absolute top-4 left-4 w-12 h-12 bg-gradient-to-br ${category.color} rounded-full flex items-center justify-center shadow-lg`}
                  >
                    <category.icon className="w-6 h-6 text-white" />
                  </div>
                  <Badge className="absolute top-4 right-4 bg-white/90 text-gray-700 senior-text-sm rounded-xl">
                    Premium
                  </Badge>
                </div>

                <div className="p-6">
                  <h3 className="senior-text-lg font-bold text-gray-800 mb-2">{category.title}</h3>
                  <p className="senior-text-base text-gray-600 mb-4 leading-relaxed">{category.description}</p>

                  <Button className="w-full h-12 senior-text-base bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-semibold rounded-xl shadow-md transition-all duration-300 hover:scale-105">
                    Explore Exercises
                    <ArrowRight className="w-5 h-5 ml-2" />
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
