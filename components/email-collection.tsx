"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Mail, Sparkles, Check, Gift } from "lucide-react"

interface EmailCollectionProps {
  onSubmit: (email: string) => void
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

export function EmailCollection({ onSubmit, onSkip }: EmailCollectionProps) {
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

  const handleSubmit = () => {
    if (isValidEmail) {
      // Store email for later use
      if (typeof window !== "undefined") {
        localStorage.setItem("superwall_email", email.trim().toLowerCase())
      }
      onSubmit(email.trim().toLowerCase())
    }
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen">
      <div className="p-6 pt-12">
        {/* Header */}
        <div className="text-center mb-8 animate-fade-in">
          <div className="w-20 h-20 bg-gradient-to-br from-pink-400 to-rose-500 rounded-full flex items-center justify-center mb-4 mx-auto shadow-2xl">
            <Gift className="w-10 h-10 text-white" />
          </div>
          <h1 className="text-2xl font-bold text-gray-800 mb-3">
            Il Tuo Piano è Pronto!
          </h1>
          <p className="text-base text-gray-600 leading-relaxed">
            Inserisci la tua email per ricevere il tuo piano personalizzato
          </p>
        </div>

        {/* Benefits */}
        <div className="mb-6 space-y-3">
          {[
            "Piano di allenamento personalizzato",
            "Ricette e consigli alimentari",
            "Accesso alla community",
          ].map((benefit) => (
            <div key={benefit} className="flex items-center space-x-3 bg-white/60 rounded-xl p-3">
              <div className="w-6 h-6 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                <Check className="w-4 h-4 text-green-600" />
              </div>
              <span className="text-gray-700">{benefit}</span>
            </div>
          ))}
        </div>

        {/* Email Input Card */}
        <Card className="mb-6 border-pink-100 shadow-xl animate-slide-up">
          <CardContent className="p-6">
            <div className="relative">
              <Label htmlFor="email" className="text-gray-700 text-sm font-medium mb-2 block">
                Il tuo indirizzo email
              </Label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <Input
                  id="email"
                  type="email"
                  placeholder="esempio@email.com"
                  value={email}
                  onChange={(e) => {
                    setEmail(e.target.value)
                    setShowSuggestions(true)
                  }}
                  onBlur={() => setTimeout(() => setShowSuggestions(false), 200)}
                  className="pl-11 h-14 text-lg border-gray-200 focus:border-pink-400 focus:ring-pink-400 rounded-xl"
                />
              </div>

              {/* Email suggestions dropdown */}
              {suggestions.length > 0 && (
                <div className="absolute z-10 mt-1 w-full bg-white border border-gray-200 rounded-lg shadow-md">
                  {suggestions.map((domain) => (
                    <div
                      key={domain}
                      className="px-4 py-3 text-gray-700 cursor-pointer hover:bg-pink-50"
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
              onClick={handleSubmit}
              disabled={!isValidEmail}
              className="w-full h-14 text-lg mt-4 bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-2xl shadow-lg transition-all duration-300 hover:scale-105 disabled:opacity-50 disabled:hover:scale-100"
            >
              <Sparkles className="w-5 h-5 mr-2" />
              Ottieni il Mio Piano
            </Button>

            <p className="text-center text-gray-500 text-xs mt-3">
              Niente spam, solo il tuo piano personalizzato
            </p>
          </CardContent>
        </Card>

        {/* Skip option */}
        {onSkip && (
          <div className="text-center">
            <button
              onClick={onSkip}
              className="text-gray-500 text-sm underline hover:text-gray-700"
            >
              Continua senza email
            </button>
          </div>
        )}
      </div>
    </div>
  )
}
