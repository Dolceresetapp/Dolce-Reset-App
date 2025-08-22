"use client"

import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { ArrowLeft, Play } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"
import Image from "next/image"

// Exercise videos JSON data
const exerciseVideos = [
  {
    id: 1,
    title: "Morning Energy Boost",
    thumbnail: "/icons/7.png",
    videoUrl: "/demo-video.mp4",
    duration: "12 min",
  },
  {
    id: 2,
    title: "Gentle Strength Builder",
    thumbnail: "/icons/7.png",
    videoUrl: "/demo-video.mp4",
    duration: "15 min",
  },
  {
    id: 3,
    title: "Flexibility Flow",
    thumbnail: "/icons/7.png",
    videoUrl: "/demo-video.mp4",
    duration: "18 min",
  },
  {
    id: 4,
    title: "Core Confidence",
    thumbnail: "/icons/7.png",
    videoUrl: "/demo-video.mp4",
    duration: "20 min",
  },
  {
    id: 5,
    title: "Balance & Stability",
    thumbnail: "/icons/7.png",
    videoUrl: "/demo-video.mp4",
    duration: "14 min",
  },
  {
    id: 6,
    title: "Relaxation Routine",
    thumbnail: "/icons/7.png",
    videoUrl: "/demo-video.mp4",
    duration: "16 min",
  },
]

export default function ExerciseVideosPage({ params }: { params: { category: string; level: string } }) {
  const router = useRouter()

  const getCategoryTitle = (category: string) => {
    const titles = {
      "muscle-toning": "Tonificazione Muscolare",
      "joint-pain": "Dolore Articolare",
      "stress-relief": "Rilassamento",
      "fat-burning": "Scellimento Grasso",
      "yoga-chair": "Yoga Sedia",
      "pilates-principianti": "Pilates Principianti",
    }
    return titles[category as keyof typeof titles] || "Exercise Category"
  }

  const handleVideoClick = (video: (typeof exerciseVideos)[0]) => {
    router.push(`/exercise/${video.id}`)
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
            <h1 className="text-lg font-bold text-purple-600">{getCategoryTitle(params.category)}</h1>
            <p className="text-sm text-gray-600 capitalize">{params.level} Level</p>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Videos Grid */}
      <div className="p-6">
        <div className="grid grid-cols-2 gap-4">
          {exerciseVideos.map((video, index) => (
            <div
              key={video.id}
              className="cursor-pointer rounded-xl mt-5 bg-pink-100"
              style={{ animationDelay: `${index * 0.1}s` }}
              onClick={() => handleVideoClick(video)}
            >
              <div className="p-0">
                <div className="relative p-4">
                  <Image
                    src={video.thumbnail || "/placeholder.svg"}
                    alt={video.title}
                    width={200}
                    height={120}
                    className="w-full h-32 object-cover rounded-3xl"
                  />
                  <div className="absolute inset-0 rounded-3xl flex items-center justify-center p-4">
                    <div className="w-12 h-12 bg-white/90 rounded-full flex items-center justify-center shadow-lg">
                      <Play className="w-6 h-6 text-purple-500 ml-1" />
                    </div>
                  </div>
                  {/* <div className="absolute bottom-2 right-2 bg-black/70 text-white text-xs px-2 py-1 rounded-full">
                    {video.duration}
                  </div> */}
                </div>
                <div className="pb-3">
                  <h3 className="text-md font-semibold text-gray-800 text-center leading-tight">{video.title}</h3>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      <BottomNavigation />
    </div>
  )
}
