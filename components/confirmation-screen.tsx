"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import Image from "next/image"

interface ConfirmationScreensProps {
  onComplete: () => void
  onRestart: () => void
}

const confirmationScreens = [
  {
    id: 1,
    image: "/accept/first.webp",
    alt: "Ready to be more fit and healthier again?",
  },
  {
    id: 2,
    image: "/accept/second.webp",
    alt: "Ready for your friends to ask your secret?",
  },
  {
    id: 3,
    image: "/accept/third.webp",
    alt: "Ready to make them and you proud?",
  },
]

export function ConfirmationScreens({ onComplete, onRestart }: ConfirmationScreensProps) {
  const [currentScreen, setCurrentScreen] = useState(0)

  const handleYes = () => {
    console.log(`Confirmation screen ${currentScreen + 1}: YES clicked`)
    if (currentScreen < confirmationScreens.length - 1) {
      // Move to next confirmation screen
      setCurrentScreen((prev) => prev + 1)
    } else {
      // All confirmations complete, start plan generation
      console.log("All confirmations complete, calling onComplete")
      onComplete()
    }
  }

  const handleNo = () => {
    console.log("NO clicked, restarting onboarding")
    // Restart onboarding from beginning
    onRestart()
  }

  const currentScreenData = confirmationScreens[currentScreen]

  return (
    <div className="app-container bg-white min-h-screen flex flex-col">
      {/* Image - Full width but not full height */}
      <div className="flex-1 flex items-center justify-center p-4">
        <div className="w-full max-w-md animate-fade-in">
          <Image
            src={currentScreenData.image || "/placeholder.svg"}
            width={400}
            height={600}
            alt={currentScreenData.alt}
            className="w-full h-auto object-contain rounded-3xl -mt-[200px]"
            priority
          />
        </div>
      </div>

      {/* Fixed Bottom Buttons */}
      <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-gray-100 p-4 shadow-lg">
        <div className="max-w-md mx-auto">
          <div className="grid grid-cols-2 gap-4">
            {/* No Button */}
            <Button
              onClick={handleNo}
              variant="outline"
              className="h-16 text-lg border-2 border-gray-300 text-gray-700 hover:bg-gray-50 font-bold rounded-3xl transition-all duration-300 hover:scale-105 bg-transparent"
            >
              No
            </Button>

            {/* Yes Button */}
            <Button
              onClick={handleYes}
              className="h-16 text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-3xl shadow-xl transition-all duration-300 hover:scale-105"
            >
              Sì
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}
