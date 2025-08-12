"use client"

import { useEffect, useState } from "react"
import { useRouter } from "next/navigation"
import { useUser } from "@clerk/nextjs"
import { Button } from "@/components/ui/button"
import { Heart, Play } from "lucide-react"

export default function StartScreen() {
  const [isLoaded, setIsLoaded] = useState(false)
  const router = useRouter()
  const { isSignedIn, isLoaded: userLoaded } = useUser()

  useEffect(() => {
    if (userLoaded && isSignedIn) {
      // Check if user has completed onboarding
      const hasCompletedOnboarding = localStorage.getItem("onboarding-completed")
      if (hasCompletedOnboarding) {
        router.push("/dashboard")
      } else {
        router.push("/onboarding")
      }
      return
    }
    setIsLoaded(true)
  }, [router, isSignedIn, userLoaded])

  const handleLogin = () => {
    router.push("/sign-in")
  }

  if (!isLoaded || !userLoaded) {
    return (
      <div className="app-container gradient-bg flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-pink-500"></div>
      </div>
    )
  }

  return (
    <div className="app-container relative overflow-hidden">
      {/* Hero Background Image */}
      <div className="absolute inset-0">
        <img src="/sexy-fitness-woman-hero.png" alt="Fitness inspiration" className="w-full h-full object-cover" />
        <div className="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent" />
      </div>

      {/* Content Overlay */}
      <div className="relative z-10 flex flex-col justify-end min-h-screen p-6 text-white">
        {/* Logo/Brand Area */}
        <div className="text-center mb-8 animate-fade-in">
          <div className="w-20 h-20 bg-gradient-to-br from-pink-400 to-rose-500 rounded-full flex items-center justify-center mb-4 mx-auto shadow-2xl backdrop-blur-sm bg-white/10">
            <Heart className="w-10 h-10 text-white" />
          </div>
          <h1 className="senior-text-2xl font-bold mb-3 text-shadow-lg">SeniorFit</h1>
          <p className="senior-text-base opacity-90 leading-relaxed max-w-sm mx-auto">
            Transform your body, boost your confidence, feel amazing
          </p>
        </div>

        {/* Action Button - Only Login */}
        <div className="w-full space-y-4 animate-slide-up">
          <Button
            onClick={handleLogin}
            className="w-full h-16 senior-text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-2xl shadow-2xl transition-all duration-300 hover:scale-105 backdrop-blur-sm"
          >
            <Play className="w-6 h-6 mr-3" />
            Start Your Transformation
          </Button>
        </div>

        {/* Bottom Text */}
        <p className="senior-text-sm text-white/70 mt-6 text-center leading-relaxed">
          Join thousands of women transforming their lives
        </p>
      </div>
    </div>
  )
}
