"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Dialog, DialogContent } from "@/components/ui/dialog"
import { ArrowLeft, Play, X } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"
import Image from "next/image"
import exerciseData from "@/data/exercises.json"

export default function ExerciseVideosPage({ params }: { params: { category: string; level: string } }) {
  const router = useRouter()
  const [selectedVideo, setSelectedVideo] = useState<any>(null)
  const [isVideoModalOpen, setIsVideoModalOpen] = useState(false)

  const categoryData = exerciseData.categories[params.category as keyof typeof exerciseData.categories]
  const levelData = categoryData?.levels[params.level as keyof typeof categoryData.levels]
  const videos = levelData?.videos || []

  const getCategoryTitle = (category: string) => {
    return categoryData?.title || "Exercise Category"
  }

  const handleVideoClick = (video: any) => {
    setSelectedVideo(video)
    setIsVideoModalOpen(true)
  }

  const closeVideoModal = () => {
    setIsVideoModalOpen(false)
    setSelectedVideo(null)
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
            <p className="text-sm text-gray-600 capitalize">{levelData?.title} Level</p>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Videos Grid */}
      <div className="p-6">
        <div className="grid grid-cols-2 gap-4">
          {videos.map((video: any, index: number) => (
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
                </div>
                <div className="pb-3">
                  <h3 className="text-md font-semibold text-gray-800 text-center leading-tight">{video.title}</h3>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      <Dialog open={isVideoModalOpen} onOpenChange={setIsVideoModalOpen}>
        <DialogContent className="bg-black border-0 p-0 max-w-4xl w-full aspect-video">
          <div className="relative w-full h-[60vh]">
            {/* Close Button */}
            <Button
              variant="ghost"
              size="icon"
              onClick={closeVideoModal}
              className="absolute top-4 right-4 z-50 h-12 w-12 rounded-full bg-white/20 hover:bg-white/30 text-white"
            >
              <X className="h-6 w-6" />
            </Button>

            {/* Video Player */}
            {selectedVideo && (
              <iframe
                src={selectedVideo.videoUrl}
                className="w-full h-full"
                frameBorder="0"
                allow="autoplay; fullscreen; picture-in-picture"
                allowFullScreen
                title={selectedVideo.title}
              />
            )}
          </div>
        </DialogContent>
      </Dialog>


      <BottomNavigation />
    </div>
  )
}
