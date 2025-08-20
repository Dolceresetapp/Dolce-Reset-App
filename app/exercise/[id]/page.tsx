"use client"

import { useState, useRef, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, Play, Pause, RotateCcw, Volume2, Heart, CheckCircle } from "lucide-react"

const exerciseData = {
  1: {
    title: "Morning Glow Routine",
    description: "Wake up radiant and energized like never before",
    duration: "15:00",
    instructor: "Sophia Martinez",
    videoUrl: "/placeholder-video.mp4",
    steps: [
      "Start with confident posture",
      "Awaken your inner glow with gentle movements",
      "Feel the energy flowing through your body",
      "Embrace your beautiful, strong self",
      "End with a radiant smile - you've got this!",
    ],
  },
}

export default function ExercisePlayer({ params }: { params: { id: string } }) {
  const router = useRouter()
  const videoRef = useRef<HTMLVideoElement>(null)
  const [isPlaying, setIsPlaying] = useState(false)
  const [currentTime, setCurrentTime] = useState(0)
  const [duration, setDuration] = useState(0)
  const [completed, setCompleted] = useState(false)

  const exercise = exerciseData[1] // Default to first exercise

  useEffect(() => {
    const video = videoRef.current
    if (!video) return

    const updateTime = () => setCurrentTime(video.currentTime)
    const updateDuration = () => setDuration(video.duration)
    const handleEnded = () => {
      setCompleted(true)
      setIsPlaying(false)
    }

    video.addEventListener("timeupdate", updateTime)
    video.addEventListener("loadedmetadata", updateDuration)
    video.addEventListener("ended", handleEnded)

    return () => {
      video.removeEventListener("timeupdate", updateTime)
      video.removeEventListener("loadedmetadata", updateDuration)
      video.removeEventListener("ended", handleEnded)
    }
  }, [])

  const togglePlay = () => {
    const video = videoRef.current
    if (!video) return

    if (isPlaying) {
      video.pause()
    } else {
      video.play()
    }
    setIsPlaying(!isPlaying)
  }

  const restart = () => {
    const video = videoRef.current
    if (!video) return

    video.currentTime = 0
    setCompleted(false)
    if (!isPlaying) {
      video.play()
      setIsPlaying(true)
    }
  }

  const formatTime = (time: number) => {
    const minutes = Math.floor(time / 60)
    const seconds = Math.floor(time % 60)
    return `${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`
  }

  const progressPercentage = duration > 0 ? (currentTime / duration) * 100 : 0

  return (
    <div className="app-container bg-black">
      {/* Header */}
      <div className="absolute top-0 left-0 right-0 z-50 bg-gradient-to-b from-black/70 to-transparent p-4">
        <div className="flex items-center justify-between">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => router.back()}
            className="h-12 w-12 rounded-full bg-white/20 hover:bg-white/30 text-white"
          >
            <ArrowLeft className="h-6 w-6" />
          </Button>
          <div className="text-center">
            <h1 className="senior-text-base font-semibold text-white">{exercise.title}</h1>
            <p className="senior-text-sm text-white/80">with {exercise.instructor}</p>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Video Player */}
      <div className="relative h-screen">
        <video ref={videoRef} className="w-full h-full object-cover" poster="/confident-woman-workout.png">
          <source src={exercise.videoUrl} type="video/mp4" />
          Your browser does not support the video tag.
        </video>

        {/* Completion Overlay */}
        {completed && (
          <div className="absolute inset-0 bg-black/80 flex items-center justify-center animate-fade-in">
            <Card className="mx-4 bg-white border-0 shadow-2xl">
              <CardContent className="p-8 text-center">
                <div className="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-4">
                  <CheckCircle className="w-8 h-8 text-green-500" />
                </div>
                <h2 className="senior-text-xl font-bold text-gray-800 mb-2">You're Glowing!</h2>
                <p className="senior-text-base text-gray-600 mb-6">
                  Amazing work! You're one step closer to your most radiant, confident self.
                </p>
                <div className="space-y-3">
                  <Button onClick={restart} className="w-full h-12 senior-text-base bg-pink-500 hover:bg-pink-600">
                    <RotateCcw className="w-5 h-5 mr-2" />
                    Do It Again
                  </Button>
                  <Button
                    onClick={() => router.push("/dashboard")}
                    variant="outline"
                    className="w-full h-12 senior-text-base"
                  >
                    Back to Exercises
                  </Button>
                </div>
              </CardContent>
            </Card>
          </div>
        )}

        {/* Controls Overlay */}
        <div className="absolute bottom-0 left-0 right-0 bg-gradient-to-t from-black/80 to-transparent p-6">
          {/* Progress Bar */}
          <div className="mb-6">
            <div className="flex justify-between items-center mb-2">
              <span className="senior-text-sm text-white/80">{formatTime(currentTime)}</span>
              <span className="senior-text-sm text-white/80">{formatTime(duration)}</span>
            </div>
            <div className="w-full bg-white/20 rounded-full h-2">
              <div
                className="bg-pink-500 h-2 rounded-full transition-all duration-300"
                style={{ width: `${progressPercentage}%` }}
              />
            </div>
          </div>

          {/* Control Buttons */}
          <div className="flex items-center justify-center space-x-6">
            <Button
              variant="ghost"
              size="icon"
              className="h-12 w-12 rounded-full bg-white/20 hover:bg-white/30 text-white"
            >
              <Volume2 className="h-6 w-6" />
            </Button>

            <Button
              onClick={togglePlay}
              size="icon"
              className="h-16 w-16 rounded-full bg-pink-500 hover:bg-pink-600 text-white shadow-lg"
            >
              {isPlaying ? <Pause className="h-8 w-8" /> : <Play className="h-8 w-8 ml-1" />}
            </Button>

            <Button
              onClick={restart}
              variant="ghost"
              size="icon"
              className="h-12 w-12 rounded-full bg-white/20 hover:bg-white/30 text-white"
            >
              <RotateCcw className="h-6 w-6" />
            </Button>
          </div>
        </div>
      </div>

      {/* Exercise Steps (Hidden during video, shown when paused) */}
      {/* {!isPlaying && !completed && (
        <div className="absolute right-4 top-1/2 transform -translate-y-1/2 w-80 animate-slide-up">
          <Card className="bg-white/95 backdrop-blur-sm border-0 shadow-xl">
            <CardContent className="p-6">
              <h3 className="senior-text-lg font-semibold text-gray-800 mb-4 flex items-center">
                <Heart className="w-5 h-5 text-pink-500 mr-2" />
                Exercise Steps
              </h3>
              <div className="space-y-3">
                {exercise.steps.map((step, index) => (
                  <div key={index} className="flex items-start space-x-3">
                    <Badge className="bg-pink-100 text-pink-700 senior-text-sm min-w-[24px] h-6 flex items-center justify-center">
                      {index + 1}
                    </Badge>
                    <p className="senior-text-sm text-gray-700 leading-relaxed">{step}</p>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>
        </div>
      )} */}
    </div>
  )
}
