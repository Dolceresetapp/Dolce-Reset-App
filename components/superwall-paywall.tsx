"use client"

import { useEffect, useState } from "react"
import { useUser } from "@clerk/nextjs"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Check, Crown, Sparkles, Star, Zap, Loader2 } from "lucide-react"

interface SuperwallPaywallProps {
  answers: Record<string, any>
  onSkip?: () => void
}

export function SuperwallPaywall({ answers, onSkip }: SuperwallPaywallProps) {
  const { user } = useUser()
  const [isLoading, setIsLoading] = useState(false)

  const premiumFeatures = [
    "50+ Esercizi Premium",
    "AI Personal Trainer",
    "Piani Alimentari Personalizzati",
    "Supporto 1-on-1",
    "Analisi Avanzate",
    "Contenuti Esclusivi",
    "Supporto Prioritario",
    "Accesso Offline",
  ]

  const handleSubscribe = () => {
    setIsLoading(true)

    // Build Superwall Web Checkout URL with user data
    const superwallAppUrl = process.env.NEXT_PUBLIC_SUPERWALL_APP_URL
    const placementId = process.env.NEXT_PUBLIC_SUPERWALL_PLACEMENT_ID || "onboarding_paywall"

    // Construct the Superwall checkout URL
    // Format: https://yourapp.superwall.app/p/{placement_id}
    const checkoutUrl = new URL(`${superwallAppUrl}/p/${placementId}`)

    // Add user identification params for tracking
    if (user?.id) {
      checkoutUrl.searchParams.set("user_id", user.id)
    }
    if (user?.emailAddresses?.[0]?.emailAddress) {
      checkoutUrl.searchParams.set("email", user.emailAddresses[0].emailAddress)
    }

    // Add custom attributes from onboarding
    if (answers.goal) {
      checkoutUrl.searchParams.set("goal", answers.goal)
    }

    // Redirect to Superwall checkout
    window.location.href = checkoutUrl.toString()
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen">
      <div className="p-6 pt-12">
        {/* Header */}
        <div className="text-center mb-8 animate-fade-in">
          <div className="w-20 h-20 bg-gradient-to-br from-pink-400 to-rose-500 rounded-full flex items-center justify-center mb-4 mx-auto shadow-2xl">
            <Crown className="w-10 h-10 text-white" />
          </div>
          <h1 className="senior-text-2xl font-bold text-gray-800 mb-3">
            Il Tuo Piano è Pronto!
          </h1>
          <p className="senior-text-base text-gray-600 leading-relaxed">
            Sblocca il tuo potenziale completo con Premium
          </p>
        </div>

        {/* Premium Plan Card */}
        <Card className="mb-6 bg-gradient-to-br from-pink-500 to-rose-500 text-white border-0 shadow-xl animate-slide-up relative overflow-hidden">
          {/* Decorative elements */}
          <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16" />
          <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/10 rounded-full translate-y-12 -translate-x-12" />

          <Badge className="absolute -top-0 left-1/2 transform -translate-x-1/2 translate-y-3 bg-gradient-to-r from-amber-400 to-orange-400 text-white border-0 senior-text-sm px-4 py-1">
            <Star className="w-4 h-4 mr-1" />
            OFFERTA LIMITATA
          </Badge>

          <CardContent className="p-6 pt-10 relative z-10">
            <div className="text-center mb-6">
              <div className="w-16 h-16 bg-white/20 rounded-2xl flex items-center justify-center mx-auto mb-4">
                <Crown className="w-8 h-8 text-white" />
              </div>
              <h3 className="senior-text-xl font-bold mb-2">Dolce Reset Premium</h3>

              {/* Pricing */}
              <div className="mb-2">
                <span className="senior-text-sm line-through opacity-70">€9,99/mese</span>
              </div>
              <p className="senior-text-3xl font-bold">
                €3,90<span className="senior-text-base font-normal">/mese</span>
              </p>
              <p className="senior-text-sm opacity-90 mt-1">
                Pagato annualmente a €47
              </p>

              <Badge className="mt-3 bg-green-500 text-white border-0">
                <Zap className="w-3 h-3 mr-1" />
                Risparmi il 60%
              </Badge>
            </div>

            {/* Features */}
            <div className="space-y-3 mb-6">
              {premiumFeatures.map((feature) => (
                <div key={feature} className="flex items-center space-x-3">
                  <div className="w-5 h-5 bg-white/20 rounded-full flex items-center justify-center flex-shrink-0">
                    <Check className="w-3 h-3 text-white" />
                  </div>
                  <span className="senior-text-base text-white">{feature}</span>
                </div>
              ))}
            </div>

            {/* CTA Button */}
            <Button
              onClick={handleSubscribe}
              disabled={isLoading}
              className="w-full h-14 senior-text-lg bg-white text-pink-600 hover:bg-gray-50 font-bold rounded-2xl shadow-lg transition-all duration-300 hover:scale-105 disabled:opacity-70"
            >
              {isLoading ? (
                <div className="flex items-center">
                  <Loader2 className="w-5 h-5 mr-2 animate-spin" />
                  Caricamento...
                </div>
              ) : (
                <div className="flex items-center">
                  <Sparkles className="w-5 h-5 mr-2" />
                  Inizia Ora - 3 Giorni Gratis
                </div>
              )}
            </Button>

            {/* Trial info */}
            <p className="text-center text-white/80 text-sm mt-3">
              Prova gratuita di 3 giorni. Cancella quando vuoi.
            </p>
          </CardContent>
        </Card>

        {/* Trust indicators */}
        <Card className="bg-white/80 border-pink-100 animate-slide-up" style={{ animationDelay: "0.2s" }}>
          <CardContent className="p-4">
            <div className="flex items-center justify-center space-x-6 text-sm text-gray-600">
              <div className="flex items-center space-x-1">
                <Check className="w-4 h-4 text-green-500" />
                <span>Cancella quando vuoi</span>
              </div>
              <div className="flex items-center space-x-1">
                <Check className="w-4 h-4 text-green-500" />
                <span>Pagamento sicuro</span>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Skip option (optional) */}
        {onSkip && (
          <div className="text-center mt-6">
            <button
              onClick={onSkip}
              className="text-gray-500 text-sm underline hover:text-gray-700"
            >
              Continua con la versione gratuita
            </button>
          </div>
        )}

        {/* Guarantee */}
        <div className="text-center mt-6 animate-slide-up" style={{ animationDelay: "0.4s" }}>
          <p className="text-xs text-gray-500 leading-relaxed px-4">
            Garanzia soddisfatti o rimborsati entro 30 giorni.
            Nessun rischio, nessun impegno.
          </p>
        </div>
      </div>
    </div>
  )
}
