"use client"

import { useState, useEffect } from "react"
import { useSearchParams } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Check, Lock, Eye, EyeOff, Loader2, PartyPopper, Sparkles } from "lucide-react"

export default function PaymentSuccessPage() {
  const searchParams = useSearchParams()
  const [email, setEmail] = useState("")
  const [name, setName] = useState("")
  const [password, setPassword] = useState("")
  const [confirmPassword, setConfirmPassword] = useState("")
  const [showPassword, setShowPassword] = useState(false)
  const [showConfirmPassword, setShowConfirmPassword] = useState(false)
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState("")
  const [success, setSuccess] = useState(false)

  useEffect(() => {
    // Get email from URL params or localStorage
    const emailFromParams = searchParams.get("email")
    const emailFromStorage = typeof window !== "undefined"
      ? localStorage.getItem("superwall_email")
      : null

    if (emailFromParams) {
      setEmail(emailFromParams)
    } else if (emailFromStorage) {
      setEmail(emailFromStorage)
    }

    // Pre-fill name from email
    if (emailFromParams || emailFromStorage) {
      const emailToUse = emailFromParams || emailFromStorage || ""
      setName(emailToUse.split("@")[0])
    }
  }, [searchParams])

  const validateForm = () => {
    if (!name.trim()) {
      setError("Inserisci il tuo nome")
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

  const handleSubmit = async () => {
    setError("")

    if (!validateForm()) {
      return
    }

    setIsLoading(true)

    try {
      // Create account with the provided password
      const response = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'https://admin.dolcereset.com'}/api/register`, {
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
          from_payment: true, // Flag to indicate this is post-payment signup
        }),
      })

      const data = await response.json()

      if (!response.ok) {
        // If user already exists (created by webhook), try to update password
        if (data.message?.includes("email") || data.errors?.email) {
          // Try to set password for existing user
          const updateResponse = await fetch(`${process.env.NEXT_PUBLIC_API_URL || 'https://admin.dolcereset.com'}/api/set-password`, {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: JSON.stringify({
              email: email.trim().toLowerCase(),
              name: name.trim(),
              password: password,
              password_confirmation: confirmPassword,
            }),
          })

          if (updateResponse.ok) {
            setSuccess(true)
            // Clear stored email
            if (typeof window !== "undefined") {
              localStorage.removeItem("superwall_email")
            }
            return
          }
        }

        setError(data.message || "Errore durante la creazione dell'account")
        setIsLoading(false)
        return
      }

      setSuccess(true)
      // Clear stored email
      if (typeof window !== "undefined") {
        localStorage.removeItem("superwall_email")
      }

    } catch (err) {
      console.error("Account creation error:", err)
      setError("Errore di connessione. Riprova.")
      setIsLoading(false)
    }
  }

  if (success) {
    return (
      <div className="app-container bg-gradient-to-br from-green-50 to-emerald-50 min-h-screen">
        <div className="p-6 pt-16">
          <div className="text-center animate-fade-in">
            <div className="w-24 h-24 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full flex items-center justify-center mb-6 mx-auto shadow-2xl">
              <Check className="w-12 h-12 text-white" />
            </div>
            <h1 className="text-3xl font-bold text-gray-800 mb-4">
              Account Creato!
            </h1>
            <p className="text-lg text-gray-600 mb-8">
              Ora puoi accedere all'app con le tue credenziali
            </p>

            <Card className="bg-white border-green-100 shadow-xl mb-6">
              <CardContent className="p-6">
                <div className="space-y-3 text-left">
                  <div className="flex justify-between">
                    <span className="text-gray-500">Email:</span>
                    <span className="font-medium">{email}</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-500">Password:</span>
                    <span className="font-medium">La password che hai scelto</span>
                  </div>
                </div>
              </CardContent>
            </Card>

            <div className="space-y-3">
              <Button
                onClick={() => window.location.href = "https://apps.apple.com/app/dolce-reset"}
                className="w-full h-14 text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-2xl"
              >
                <Sparkles className="w-5 h-5 mr-2" />
                Scarica l'App
              </Button>
              <p className="text-sm text-gray-500">
                Apri l'app e accedi con le tue credenziali
              </p>
            </div>
          </div>
        </div>
      </div>
    )
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen">
      <div className="p-6 pt-10">
        {/* Header */}
        <div className="text-center mb-8 animate-fade-in">
          <div className="w-20 h-20 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full flex items-center justify-center mb-4 mx-auto shadow-2xl">
            <PartyPopper className="w-10 h-10 text-white" />
          </div>
          <h1 className="text-2xl font-bold text-gray-800 mb-2">
            Pagamento Completato!
          </h1>
          <p className="text-base text-gray-600">
            Crea il tuo account per accedere all'app
          </p>
        </div>

        {/* Form Card */}
        <Card className="mb-6 border-pink-100 shadow-xl animate-slide-up">
          <CardContent className="p-6 space-y-4">
            {/* Error message */}
            {error && (
              <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl text-sm">
                {error}
              </div>
            )}

            {/* Email (read-only) */}
            <div>
              <Label className="text-sm font-medium text-gray-700 mb-2 block">
                Email
              </Label>
              <Input
                type="email"
                value={email}
                disabled
                className="h-12 bg-gray-50 border-gray-200 rounded-xl"
              />
            </div>

            {/* Name Input */}
            <div>
              <Label htmlFor="name" className="text-sm font-medium text-gray-700 mb-2 block">
                Il tuo nome
              </Label>
              <Input
                id="name"
                type="text"
                placeholder="Come ti chiami?"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="h-12 border-gray-200 focus:border-pink-400 focus:ring-pink-400 rounded-xl"
              />
            </div>

            {/* Password Input */}
            <div>
              <Label htmlFor="password" className="text-sm font-medium text-gray-700 mb-2 block">
                Crea una password
              </Label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <Input
                  id="password"
                  type={showPassword ? "text" : "password"}
                  placeholder="Minimo 6 caratteri"
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
              onClick={handleSubmit}
              disabled={isLoading || !password || !confirmPassword}
              className="w-full h-14 text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-2xl shadow-lg transition-all duration-300 hover:scale-[1.02] disabled:opacity-70"
            >
              {isLoading ? (
                <div className="flex items-center">
                  <Loader2 className="w-5 h-5 mr-2 animate-spin" />
                  Creazione account...
                </div>
              ) : (
                <div className="flex items-center">
                  <Sparkles className="w-5 h-5 mr-2" />
                  Crea Account
                </div>
              )}
            </Button>
          </CardContent>
        </Card>

        {/* Info */}
        <p className="text-center text-gray-500 text-xs px-4">
          Questi dati ti serviranno per accedere all'app Dolce Reset
        </p>
      </div>
    </div>
  )
}
