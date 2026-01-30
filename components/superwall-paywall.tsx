"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Check, Crown, Sparkles, Star, Zap, Loader2 } from "lucide-react"

interface SuperwallPaywallProps {
  answers: Record<string, any>
  email: string
  onSkip?: () => void
}

export function SuperwallPaywall({ answers, email, onSkip }: SuperwallPaywallProps) {
  const [isLoading, setIsLoading] = useState(false)

  const premiumFeatures = [
    "50+ Esercizi Premium",
    "AI Personal Trainer",
    "Piani Alimentari Personalizzati",
    "Supporto 1-on-1",
    "Analisi Avanzate",
    "Contenuti Esclusivi",
  ]

  const handleSubscribe = () => {
    setIsLoading(true)

    // Superwall Web Checkout URL from environment
    const superwallDomain = process.env.NEXT_PUBLIC_SUPERWALL_APP_URL || "https://httpdolceresetapponlinesign-in.superwall.app"
    const placementId = process.env.NEXT_PUBLIC_SUPERWALL_PLACEMENT_ID || "onboarding_paywall"

    // Construct the Superwall checkout URL
    const checkoutUrl = new URL(`${superwallDomain}/${placementId}`)

    // Pass email for Superwall and Stripe prefill
    checkoutUrl.searchParams.set("$user_email", email)
    checkoutUrl.searchParams.set("email", email)
    checkoutUrl.searchParams.set("prefill_email", email)

    // Add custom attributes from onboarding
    if (answers.goal) {
      checkoutUrl.searchParams.set("goal", answers.goal)
    }

    // Redirect to Superwall checkout
    window.location.href = checkoutUrl.toString()
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen">
      <div className="p-6 pt-8">
        {/* Header */}
        <div className="text-center mb-6 animate-fade-in">
          <div className="w-16 h-16 bg-gradient-to-br from-pink-400 to-rose-500 rounded-full flex items-center justify-center mb-3 mx-auto shadow-2xl">
            <Crown className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-2xl font-bold text-gray-800 mb-2">
            Sblocca il Tuo Piano
          </h1>
          <p className="text-base text-gray-600">
            Inizia la tua trasformazione oggi
          </p>
        </div>

        {/* Premium Plan Card */}
        <Card className="mb-4 bg-gradient-to-br from-pink-500 to-rose-500 text-white border-0 shadow-xl animate-slide-up relative overflow-hidden">
          <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full -translate-y-16 translate-x-16" />
          <div className="absolute bottom-0 left-0 w-24 h-24 bg-white/10 rounded-full translate-y-12 -translate-x-12" />

          <Badge className="absolute -top-0 left-1/2 transform -translate-x-1/2 translate-y-3 bg-gradient-to-r from-amber-400 to-orange-400 text-white border-0 text-sm px-4 py-1">
            <Star className="w-4 h-4 mr-1" />
            OFFERTA LIMITATA
          </Badge>

          <CardContent className="p-5 pt-10 relative z-10">
            <div className="text-center mb-4">
              <h3 className="text-xl font-bold mb-2">Dolce Reset Premium</h3>

              <div className="mb-1">
                <span className="text-sm line-through opacity-70">€9,99/mese</span>
              </div>
              <p className="text-3xl font-bold">
                €3,90<span className="text-base font-normal">/mese</span>
              </p>
              <p className="text-sm opacity-90 mt-1">
                Pagato annualmente a €47
              </p>

              <Badge className="mt-2 bg-green-500 text-white border-0">
                <Zap className="w-3 h-3 mr-1" />
                Risparmi il 60%
              </Badge>
            </div>

            {/* Features */}
            <div className="grid grid-cols-2 gap-2 mb-5">
              {premiumFeatures.map((feature) => (
                <div key={feature} className="flex items-center space-x-2">
                  <div className="w-4 h-4 bg-white/20 rounded-full flex items-center justify-center flex-shrink-0">
                    <Check className="w-2.5 h-2.5 text-white" />
                  </div>
                  <span className="text-sm text-white">{feature}</span>
                </div>
              ))}
            </div>

            {/* CTA Button */}
            <Button
              onClick={handleSubscribe}
              disabled={isLoading}
              className="w-full h-14 text-lg bg-white text-pink-600 hover:bg-gray-50 font-bold rounded-2xl shadow-lg transition-all duration-300 hover:scale-105 disabled:opacity-70 disabled:hover:scale-100"
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

            <p className="text-center text-white/80 text-xs mt-3">
              Prova gratuita di 3 giorni. Cancella quando vuoi.
            </p>
          </CardContent>
        </Card>

        {/* Trust indicators */}
        <Card className="bg-white/80 border-pink-100 animate-slide-up" style={{ animationDelay: "0.2s" }}>
          <CardContent className="p-3">
            <div className="flex items-center justify-center space-x-4 text-xs text-gray-600">
              <div className="flex items-center space-x-1">
                <Check className="w-3 h-3 text-green-500" />
                <span>Cancella quando vuoi</span>
              </div>
              <div className="flex items-center space-x-1">
                <Check className="w-3 h-3 text-green-500" />
                <span>Pagamento sicuro</span>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Skip option */}
        {onSkip && (
          <div className="text-center mt-4">
            <button
              onClick={onSkip}
              className="text-gray-500 text-sm underline hover:text-gray-700"
            >
              Continua con la versione gratuita
            </button>
          </div>
        )}

        {/* Guarantee */}
        <div className="text-center mt-4 animate-slide-up" style={{ animationDelay: "0.4s" }}>
          <p className="text-xs text-gray-500 leading-relaxed px-4">
            Garanzia soddisfatti o rimborsati entro 30 giorni.
          </p>
        </div>
      </div>
    </div>
  )
}
