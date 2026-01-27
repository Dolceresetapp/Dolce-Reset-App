"use client"

import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Play } from "lucide-react"
import Image from "next/image"
import ConsentNotice from "@/components/agree"

export default function Sales() {
  const router = useRouter()

  const handleStartJourney = () => {
    router.push("/onboarding")
  }

  return (
    <div className="app-container relative overflow-hidden">
      {/* Hero Background Image */}
      <div className="absolute inset-0">
        <Image
          src="/custom/start.webp"
          alt="Fitness inspiration"
          fill
          priority
          sizes="100vw"
          className="object-cover"
        />
      </div>

      {/* Content Overlay */}
      <div className="relative z-10 flex flex-col justify-center top-24 min-h-screen p-6 text-white">
        {/* Logo/Brand Area */}
        <div className="text-center mb-4 animate-fade-in">
          <h1 className="senior-text-lg font-bold text-shadow-lg">
            Forma Fisica e Salute In Modo Semplice Per Donne
          </h1>
        </div>

        {/* Action Button */}
        <div className="w-full animate-slide-up">
          <Button
            onClick={handleStartJourney}
            className="w-full h-16 senior-text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-2xl shadow-2xl transition-all duration-300 hover:scale-105 backdrop-blur-sm"
          >
            <Play className="w-6 h-6 mr-3" />
            Inizia la tua trasformazione
          </Button>
        </div>
        <ConsentNotice />
      </div>
    </div>
  )
}
