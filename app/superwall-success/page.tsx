"use client"

import { useEffect } from "react"
import { Card, CardContent } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Check, Crown } from "lucide-react"
import Image from "next/image"

// TODO: Remplacer ces URLs par les vrais liens App Store et Play Store
const IOS_APP_URL = "https://apps.apple.com/app/dolce-reset" // À REMPLACER
const ANDROID_APP_URL = "https://play.google.com/store/apps/details?id=com.dolcereset.app" // À REMPLACER

export default function SuperwallSuccessPage() {
  useEffect(() => {
    // Set subscription cookie
    document.cookie = "subscription-active=true; path=/; max-age=31536000"
    document.cookie = "onboarding-completed=true; path=/; max-age=31536000"

    // Dynamic import for confetti (optional)
    import("canvas-confetti").then((confetti) => {
      confetti.default({
        particleCount: 100,
        spread: 70,
        origin: { y: 0.6 },
        colors: ["#ec4899", "#f43f5e", "#fbbf24"],
      })
    }).catch(() => {
      // Confetti not available, that's fine
    })
  }, [])

  const handleDownloadIOS = () => {
    window.open(IOS_APP_URL, "_blank")
  }

  const handleDownloadAndroid = () => {
    window.open(ANDROID_APP_URL, "_blank")
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen flex items-center justify-center p-6">
      <div className="w-full max-w-md">
        <Card className="bg-white shadow-2xl border-0 overflow-hidden animate-fade-in">
          <div className="bg-gradient-to-r from-pink-500 to-rose-500 p-6 text-center text-white">
            <div className="w-24 h-24 rounded-2xl overflow-hidden mx-auto mb-4 shadow-lg">
              <Image
                src="/icon.jpeg"
                alt="Dolce Reset"
                width={96}
                height={96}
                className="w-full h-full object-cover"
              />
            </div>
            <h1 className="text-2xl font-bold mb-2">Pagamento Completato!</h1>
            <p className="opacity-90">Benvenuta nella famiglia Dolce Reset Premium</p>
          </div>

          <CardContent className="p-6 space-y-6">
            <div className="flex items-center justify-center">
              <div className="bg-gradient-to-r from-amber-100 to-orange-100 px-4 py-2 rounded-full flex items-center space-x-2">
                <Crown className="w-5 h-5 text-amber-600" />
                <span className="font-semibold text-amber-800">Premium Attivo</span>
              </div>
            </div>

            <div className="space-y-3">
              <h3 className="font-semibold text-gray-800 text-center">Ora hai accesso a:</h3>
              <div className="grid grid-cols-2 gap-2 text-sm">
                {["50+ Esercizi", "AI Trainer", "Piani Alimentari", "Supporto VIP"].map((feature) => (
                  <div key={feature} className="flex items-center space-x-2 bg-green-50 p-2 rounded-lg">
                    <Check className="w-4 h-4 text-green-500 flex-shrink-0" />
                    <span className="text-gray-700">{feature}</span>
                  </div>
                ))}
              </div>
            </div>

            <div className="space-y-3">
              <p className="text-center text-gray-700 font-medium">Scarica l'App:</p>

              <Button
                onClick={handleDownloadIOS}
                className="w-full h-14 text-lg bg-black hover:bg-gray-800 text-white font-bold rounded-xl shadow-lg flex items-center justify-center gap-3"
              >
                <svg className="w-6 h-6" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/>
                </svg>
                Scarica per iPhone
              </Button>

              <Button
                onClick={handleDownloadAndroid}
                className="w-full h-14 text-lg bg-[#01875f] hover:bg-[#017a56] text-white font-bold rounded-xl shadow-lg flex items-center justify-center gap-3"
              >
                <svg className="w-6 h-6" viewBox="0 0 24 24" fill="currentColor">
                  <path d="M3.609 1.814L13.792 12 3.61 22.186a.996.996 0 01-.61-.92V2.734a1 1 0 01.609-.92zm10.89 10.893l2.302 2.302-10.937 6.333 8.635-8.635zm3.199-3.198l2.807 1.626a1 1 0 010 1.73l-2.808 1.626L15.206 12l2.492-2.491zM5.864 2.658L16.8 8.99l-2.302 2.302-8.634-8.634z"/>
                </svg>
                Scarica per Android
              </Button>
            </div>

            <p className="text-xs text-gray-500 text-center">
              Il tuo abbonamento è attivo su tutti i dispositivi.
              Usa la stessa email per accedere all'app.
            </p>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
