"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Mail, Lock, Eye, EyeOff, Loader2, UserPlus, Check, Sparkles } from "lucide-react"

interface SignupScreenProps {
  answers: Record<string, any>
  onComplete: (email: string) => void
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

export function SignupScreen({ answers, onComplete, onSkip }: SignupScreenProps) {
  const [email, setEmail] = useState("")
  const [password, setPassword] = useState("")
  const [confirmPassword, setConfirmPassword] = useState("")
  const [name, setName] = useState("")
  const [showPassword, setShowPassword] = useState(false)
  const [showConfirmPassword, setShowConfirmPassword] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState("")
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

  const validateForm = () => {
    if (!name.trim()) {
      setError("Inserisci il tuo nome")
      return false
    }
    if (!email || !email.includes("@")) {
      setError("Inserisci un indirizzo email valido")
      return false
    }
    if (password.length < 6) {
      setError("La password deve contenere almeno 6 caratteri")
      return false
    }
    if (password !== confirmPassword) {
      setError("Le password non corrispondono")
      return false
    }
    return true
  }

  const handleSignup = async () => {
    setError("")

    if (!validateForm()) {
      return
    }

    setIsLoading(true)

    try {
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'https://api.dolcereset.com'}/api/register`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: JSON.stringify({
          name: name.trim(),
          email: email.trim().toLowerCase(),
          password: password,
          password_confirmation: confirmPassword,
        }),
      })

      const data = await response.json()

      if (!response.ok) {
        // Handle specific error messages
        if (data.message?.includes("email") || data.errors?.email) {
          setError("Questa email è già registrata. Prova ad accedere.")
        } else if (data.message) {
          setError(data.message)
        } else {
          setError("Errore durante la registrazione. Riprova.")
        }
        setIsLoading(false)
        return
      }

      // Store email for Superwall
      if (typeof window !== "undefined") {
        localStorage.setItem("superwall_email", email.trim().toLowerCase())
        localStorage.setItem("user_registered", "true")
      }

      // Account created successfully, proceed to payment
      onComplete(email.trim().toLowerCase())

    } catch (err) {
      console.error("Signup error:", err)
      setError("Errore di connessione. Verifica la tua connessione internet.")
      setIsLoading(false)
    }
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen">
      <div className="p-6 pt-12">
        {/* Header */}
        <div className="text-center mb-8 animate-fade-in">
          <div className="w-20 h-20 bg-gradient-to-br from-pink-400 to-rose-500 rounded-full flex items-center justify-center mb-4 mx-auto shadow-2xl">
            <UserPlus className="w-10 h-10 text-white" />
          </div>
          <h1 className="senior-text-2xl font-bold text-gray-800 mb-3">
            Crea il Tuo Account
          </h1>
          <p className="senior-text-base text-gray-600 leading-relaxed">
            Un ultimo passo per sbloccare il tuo piano personalizzato
          </p>
        </div>

        {/* Benefits reminder */}
        <div className="flex flex-wrap justify-center gap-2 mb-6">
          {["Piano Personalizzato", "AI Trainer", "Supporto 24/7"].map((benefit) => (
            <div key={benefit} className="flex items-center bg-white/80 px-3 py-1.5 rounded-full text-sm text-gray-700">
              <Check className="w-3 h-3 text-green-500 mr-1" />
              {benefit}
            </div>
          ))}
        </div>

        {/* Signup Form */}
        <Card className="mb-6 bg-white border-pink-100 shadow-xl animate-slide-up">
          <CardContent className="p-6 space-y-4">
            {/* Error message */}
            {error && (
              <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl text-sm">
                {error}
              </div>
            )}

            {/* Name Input */}
            <div>
              <Label htmlFor="name" className="text-sm font-medium text-gray-700 mb-2 block">
                Il tuo nome
              </Label>
              <div className="relative">
                <UserPlus className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  id="name"
                  type="text"
                  placeholder="Come ti chiami?"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  className="pl-10 h-12 border-gray-200 focus:border-pink-400 focus:ring-pink-400 rounded-xl"
                />
              </div>
            </div>

            {/* Email Input */}
            <div className="relative">
              <Label htmlFor="email" className="text-sm font-medium text-gray-700 mb-2 block">
                Indirizzo email
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
                  className="pl-10 h-12 border-gray-200 focus:border-pink-400 focus:ring-pink-400 rounded-xl"
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

            {/* Password Input */}
            <div>
              <Label htmlFor="password" className="text-sm font-medium text-gray-700 mb-2 block">
                Password
              </Label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  id="password"
                  type={showPassword ? "text" : "password"}
                  placeholder="Crea una password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="pl-10 pr-10 h-12 border-gray-200 focus:border-pink-400 focus:ring-pink-400 rounded-xl"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
              <p className="text-xs text-gray-500 mt-1">Minimo 6 caratteri</p>
            </div>

            {/* Confirm Password Input */}
            <div>
              <Label htmlFor="confirmPassword" className="text-sm font-medium text-gray-700 mb-2 block">
                Conferma password
              </Label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  id="confirmPassword"
                  type={showConfirmPassword ? "text" : "password"}
                  placeholder="Ripeti la password"
                  value={confirmPassword}
                  onChange={(e) => setConfirmPassword(e.target.value)}
                  className="pl-10 pr-10 h-12 border-gray-200 focus:border-pink-400 focus:ring-pink-400 rounded-xl"
                />
                <button
                  type="button"
                  onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showConfirmPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                </button>
              </div>
            </div>

            {/* Submit Button */}
            <Button
              onClick={handleSignup}
              disabled={isLoading}
              className="w-full h-14 senior-text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-2xl shadow-lg transition-all duration-300 hover:scale-[1.02] disabled:opacity-70"
            >
              {isLoading ? (
                <div className="flex items-center">
                  <Loader2 className="w-5 h-5 mr-2 animate-spin" />
                  Creazione account...
                </div>
              ) : (
                <div className="flex items-center">
                  <Sparkles className="w-5 h-5 mr-2" />
                  Continua al Pagamento
                </div>
              )}
            </Button>

            <p className="text-center text-gray-500 text-xs leading-relaxed">
              Creando un account accetti i nostri{" "}
              <a href="/terms" className="text-pink-600 underline">Termini di Servizio</a>
              {" "}e la{" "}
              <a href="/policy" className="text-pink-600 underline">Privacy Policy</a>
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
              Continua con la versione gratuita
            </button>
          </div>
        )}
      </div>
    </div>
  )
}
