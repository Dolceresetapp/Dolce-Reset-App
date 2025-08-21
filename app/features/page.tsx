"use client"

import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { ArrowLeft } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"
import Image from "next/image"

// Exercise categories JSON data
const exerciseCategories = [
  {
    id: "muscle-toning",
    title: "Muscle toning",
    image: "/icons/1.png",
    color: "bg-[#fee5f2]",
    borderColor: "border-pink-200",
  },
  {
    id: "joint-pain",
    title: "Joint pain",
    image: "/icons/2.png",
    color: "bg-[#fee5f2]",
    borderColor: "border-blue-200",
  },
  {
    id: "stress-relief",
    title: "Stress relief",
    image: "/icons/3.png",
    color: "bg-[#fee5f2]",
    borderColor: "border-green-200",
  },
  {
    id: "fat-burning",
    title: "Fat burning",
    image: "/icons/4.png",
    color: "bg-[#fee5f2]",
    borderColor: "border-orange-200",
    featured: true,
  },
  {
    id: "yoga-chair",
    title: "Yoga Chair",
    image: "/icons/5.png",
    color: "bg-[#fee5f2]",
    borderColor: "border-purple-200",
  },
  {
    id: "pilates-principianti",
    title: "Pilates principianti",
    image: "/icons/6.png",
    color: "bg-[#fee5f2]",
    borderColor: "border-indigo-200",
  },
]

export default function FeaturesPage() {
  const router = useRouter()

  const handleCategoryClick = (categoryId: string) => {
    router.push(`/exercises/${categoryId}`)
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
            <h1 className="text-2xl font-bold text-pink-600">Select Category</h1>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Categories Grid */}
      <div className="p-6">
        <div className="grid grid-cols-2 gap-4">
          {exerciseCategories.map((category, index) => (
            <div
              key={category.id}
              className={`cursor-pointer border-2 ${category.color} shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105 animate-fade-in rounded-3xl`}
              onClick={() => handleCategoryClick(category.id)}
            >
              <div className="p-4">
                <div
                  className={`bg-white rounded-2xl p-4 mb-3 flex items-center justify-center h-24`}
                >
                  <Image
                    src={category.image || "/placeholder.svg"}
                    alt={category.title}
                    width={60}
                    height={60}
                    className="object-contain"
                  />
                </div>
                <h3 className="text-center text-sm font-semibold text-gray-800">{category.title}</h3>
              </div>
            </div>
          ))}
        </div>
      </div>

      <BottomNavigation />
    </div>
  )
}
