"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Heart } from "lucide-react"
import Image from "next/image"

interface OnboardingIntroProps {
  onContinue: () => void
}

export function OnboardingIntro({ onContinue }: OnboardingIntroProps) {
  const [currentScreen, setCurrentScreen] = useState(2)

  const handleFirstContinue = () => {
    setCurrentScreen(2)
  }

  const handleSecondContinue = () => {
    onContinue()
  }

  // First Screen (existing)
  if (currentScreen === 1) {
    return (
      <div className="app-container flex flex-col place-items-center justify-center bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen">
        <div className="p-6 pt-12 pb-24 flex-1 flex flex-col items-center justify-center">
         

          {/* Rating Card */}
          <div className="flex justify-center items-center w-full">
            <Image src="/custom/onboarding.webp" width={500} height={500} alt="first" className="object-contain" />
          </div>

          {/* Benefits Preview */}
          <br />
        </div>

        {/* Fixed Bottom Button */}
        <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-purple-100 p-4 shadow-lg">
          <div className="max-w-md mx-auto">
            <Button
              onClick={handleFirstContinue}
              className="w-full h-16 senior-text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105"
            >
              <Heart className="w-6 h-6 mr-3" />
              Continua
            </Button>
          </div>
        </div>
      </div>
    )
  }

  // Second Screen (new)
  return (
    <div className="app-container bg-white min-h-screen relative">
      {/* Full Screen Image */}
      <div className="flex items-center justify-center min-h-screen p-4">
        <div className="w-full max-w-md animate-fade-in">
          <Image
            src="/second.webp"
            width={500}
            height={800}
            alt="Benefits overview"
            className="w-full h-auto"
            priority
          />
        </div>
      </div>

      {/* Fixed Bottom Button */}
      <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-purple-100 p-4 shadow-lg">
        <div className="max-w-md mx-auto">
          <Button
            onClick={handleSecondContinue}
            className="w-full h-16 senior-text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105"
          >
            <Heart className="w-6 h-6 mr-3" />
            Continua
          </Button>
        </div>
      </div>
    </div>
  )
}

