"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Check, Crown, Sparkles, Star, Zap, Loader2, Mail } from "lucide-react"

interface SuperwallPaywallProps {
  answers: Record<string, any>
  onSkip?: () => void
}

const emailDomains = [
  "@gmail.com",
  "@icloud.com",
  "@tiscali.it",
  "@libero.it",
  "@virgilio.it",
  "@outlook.com",
  "@yahoo.com",
]

export function SuperwallPaywall({ answers, onSkip }: SuperwallPaywallProps) {
  const [isLoading, setIsLoading] = useState(false)
  const [email, setEmail] = useState("")
  const [showSuggestions, setShowSuggestions] = useState(false)

  const suggestions =
    email.includes("@") && showSuggestions
      ? emailDomains.filter((domain) =>
        domain.startsWith(email.substring(email.indexOf("@")))
      )
      : []

  const handleSuggestionClick = (domain: string) => {
    const beforeAt = email.substring(0, email.indexOf("@"))
    setEmail(beforeAt + domain)
    setShowSuggestions(false)
  }

  const isValidEmail = email.includes("@") && email.includes(".")

  const premiumFeatures = [
    "50+ Esercizi Premium",
    "AI Personal Trainer",
    "Piani Alimentari Personalizzati",
    "Supporto 1-on-1",
    "Analisi Avanzate",
    "Contenuti Esclusivi",
  ]

  const handleSubscribe = () => {
    if (!isValidEmail) return

    setIsLoading(true)

    // Store email in localStorage for post-payment account creation
    if (typeof window !== "undefined") {
      localStorage.setItem("superwall_email", email.trim().toLowerCase())
    }

    // Superwall Web Checkout URL from environment
    const superwallDomain = process.env.NEXT_PUBLIC_SUPERWALL_APP_URL || "https://httpdolceresetapponlinesign-in.superwall.app"
    const placementId = process.env.NEXT_PUBLIC_SUPERWALL_PLACEMENT_ID || "onboarding_paywall"

    // Construct the Superwall checkout URL
    const checkoutUrl = new URL(`${superwallDomain}/${placementId}`)

    // Pass email as $user_email for Superwall to identify the user
    // Account will be created after payment via webhook
    checkoutUrl.searchParams.set("$user_email", email.trim().toLowerCase())

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
            Il Tuo Piano è Pronto!
          </h1>
          <p className="text-base text-gray-600">
            Sblocca il tuo potenziale completo
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
            <div className="grid grid-cols-2 gap-2 mb-4">
              {premiumFeatures.map((feature) => (
                <div key={feature} className="flex items-center space-x-2">
                  <div className="w-4 h-4 bg-white/20 rounded-full flex items-center justify-center flex-shrink-0">
                    <Check className="w-2.5 h-2.5 text-white" />
                  </div>
                  <span className="text-sm text-white">{feature}</span>
                </div>
              ))}
            </div>

            {/* Email Input */}
            <div className="mb-4 relative">
              <Label htmlFor="email" className="text-white/90 text-sm mb-2 block">
                Inserisci la tua email per continuare
              </Label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  id="email"
                  type="email"
                  placeholder="La tua email"
                  value={email}
                  onChange={(e) => {
                    setEmail(e.target.value)
                    setShowSuggestions(true)
                  }}
                  onBlur={() => setTimeout(() => setShowSuggestions(false), 200)}
                  className="pl-10 h-12 bg-white text-gray-800 border-0 rounded-xl"
                />
              </div>

              {/* Email suggestions dropdown */}
              {suggestions.length > 0 && (
                <div className="absolute z-10 mt-1 w-full bg-white border border-gray-200 rounded-lg shadow-md">
                  {suggestions.map((domain) => (
                    <div
                      key={domain}
                      className="px-3 py-2 text-sm text-gray-700 cursor-pointer hover:bg-pink-50"
                      onClick={() => handleSuggestionClick(domain)}
                    >
                      {email.substring(0, email.indexOf("@"))}
                      {domain}
                    </div>
                  ))}
                </div>
              )}
            </div>

            {/* CTA Button */}
            <Button
              onClick={handleSubscribe}
              disabled={isLoading || !isValidEmail}
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
