"use client"

import { useEffect, useState } from "react"
import { useRouter, useSearchParams } from "next/navigation"
import { useUser } from "@clerk/nextjs"
import { Card, CardContent } from "@/components/ui/card"
import { Button } from "@/components/ui/button"
import { Check, Crown, Sparkles, Download, ArrowRight } from "lucide-react"
import { useSupabaseClient } from "@/lib/supabase"
import confetti from "canvas-confetti"

export default function SuperwallSuccessPage() {
  const router = useRouter()
  const searchParams = useSearchParams()
  const { user } = useUser()
  const { getSupabaseClient } = useSupabaseClient()
  const [isProcessing, setIsProcessing] = useState(true)

  useEffect(() => {
    // Trigger confetti on mount
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 },
      colors: ["#ec4899", "#f43f5e", "#fbbf24"],
    })

    // Process the successful payment
    const processPayment = async () => {
      try {
        const supabase = await getSupabaseClient()

        // Update user subscription status
        if (user?.id) {
          await supabase
            .from("user_subscriptions")
            .upsert({
              user_id: user.id,
              status: "active",
              source: "superwall_web",
              subscribed_at: new Date().toISOString(),
            })
        }

        // Set subscription cookie
        document.cookie = "subscription-active=true; path=/; max-age=31536000"
        document.cookie = "onboarding-completed=true; path=/; max-age=31536000"
      } catch (error) {
        console.error("Error processing payment:", error)
      } finally {
        setIsProcessing(false)
      }
    }

    processPayment()
  }, [user, getSupabaseClient])

  const handleContinue = () => {
    router.push("/features")
  }

  const handleDownloadApp = () => {
    // Detect platform and redirect to appropriate store
    const userAgent = navigator.userAgent.toLowerCase()
    if (/iphone|ipad|ipod/.test(userAgent)) {
      window.open("https://apps.apple.com/app/dolce-reset", "_blank")
    } else {
      window.open("https://play.google.com/store/apps/details?id=com.dolcereset.app", "_blank")
    }
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen flex items-center justify-center p-6">
      <div className="w-full max-w-md">
        {/* Success Card */}
        <Card className="bg-white shadow-2xl border-0 overflow-hidden animate-fade-in">
          <div className="bg-gradient-to-r from-pink-500 to-rose-500 p-6 text-center text-white">
            <div className="w-20 h-20 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-4">
              <Check className="w-10 h-10 text-white" />
            </div>
            <h1 className="text-2xl font-bold mb-2">Pagamento Completato!</h1>
            <p className="opacity-90">Benvenuta nella famiglia Dolce Reset Premium</p>
          </div>

          <CardContent className="p-6 space-y-6">
            {/* Premium badge */}
            <div className="flex items-center justify-center">
              <div className="bg-gradient-to-r from-amber-100 to-orange-100 px-4 py-2 rounded-full flex items-center space-x-2">
                <Crown className="w-5 h-5 text-amber-600" />
                <span className="font-semibold text-amber-800">Premium Attivo</span>
              </div>
            </div>

            {/* What's included */}
            <div className="space-y-3">
              <h3 className="font-semibold text-gray-800 text-center">Ora hai accesso a:</h3>
              <div className="grid grid-cols-2 gap-2 text-sm">
                {[
                  "50+ Esercizi",
                  "AI Trainer",
                  "Piani Alimentari",
                  "Supporto VIP",
                ].map((feature) => (
                  <div key={feature} className="flex items-center space-x-2 bg-green-50 p-2 rounded-lg">
                    <Check className="w-4 h-4 text-green-500 flex-shrink-0" />
                    <span className="text-gray-700">{feature}</span>
                  </div>
                ))}
              </div>
            </div>

            {/* Action buttons */}
            <div className="space-y-3">
              <Button
                onClick={handleContinue}
                className="w-full h-14 text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-xl shadow-lg"
              >
                <Sparkles className="w-5 h-5 mr-2" />
                Inizia il Tuo Percorso
                <ArrowRight className="w-5 h-5 ml-2" />
              </Button>

              <Button
                onClick={handleDownloadApp}
                variant="outline"
                className="w-full h-12 text-base border-2 border-pink-200 text-pink-600 hover:bg-pink-50 font-semibold rounded-xl"
              >
                <Download className="w-5 h-5 mr-2" />
                Scarica l'App Mobile
              </Button>
            </div>

            {/* Info */}
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
