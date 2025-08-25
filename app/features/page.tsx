"use client"

import { useRouter } from "next/navigation"
import { BottomNavigation } from "@/components/bottom-navigation"
import Image from "next/image"
import Header from "@/components/header"
import exerciseData from "@/data/exercises.json"

export default function FeaturesPage() {
  const router = useRouter()

  const exerciseCategories = Object.entries(exerciseData.categories).map(([id, category]) => ({
    id,
    ...category,
  }))

  const handleCategoryClick = (categoryId: string) => {
    router.push(`/exercises/${categoryId}`)
  }

  return (
    <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen pb-20">
      {/* Header */}
      <Header />

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
                <div className={`bg-white rounded-2xl p-4 mb-3 flex items-center justify-center h-24`}>
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
