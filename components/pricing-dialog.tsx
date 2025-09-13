"use client"

import { useState } from "react"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Badge } from "@/components/ui/badge"
import { Crown, Mail, CreditCard, Shield, CheckCircle } from "lucide-react"
import Image from "next/image"
import { useRouter } from "next/navigation"

interface PricingDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
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

export function PricingDialog({ open, onOpenChange }: PricingDialogProps) {
  const [email, setEmail] = useState("")
  const [isLoading, setIsLoading] = useState(false)
  const [showSuggestions, setShowSuggestions] = useState(false)
  const router = useRouter()

  // Only show dropdown if user typed '@' and suggestions exist
  const suggestions =
    email.includes("@") && showSuggestions
      ? emailDomains.filter((domain) =>
        domain.startsWith(email.substring(email.indexOf("@")))
      )
      : []

  const handleSubscribe = async () => {
    if (!email || !email.includes("@")) {
      alert("Please enter a valid email address")
      return
    }

    setIsLoading(true)
    router.push("/payment")
    onOpenChange(false)
    return

    try {
      const response = await fetch("/api/create-subscription-checkout", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email,
          priceId: process.env.NEXT_PUBLIC_STRIPE_PRICE_ID,
        }),
      })

      const data = await response.json()

      if (data.url) {
        window.location.href = data.url
      } else {
        throw new Error("Failed to create checkout session")
      }
    } catch (error) {
      console.error("Error:", error)
      alert("Something went wrong. Please try again.")
    } finally {
      setIsLoading(false)
    }
  }

  const handleSuggestionClick = (domain: string) => {
    const beforeAt = email.substring(0, email.indexOf("@"))
    setEmail(beforeAt + domain)
    setShowSuggestions(false) // 👈 close dropdown after selection
  }

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="w-[95vw] max-w-md mx-auto max-h-[90vh] overflow-y-auto p-0 gap-0">


        <div className="p-6 space-y-6">


          {/* <Image src="/custom/steps.png" width={500} height={500} alt="" className="w-full" /> */}

          {/* Yearly Pricing Card */}
          {/* <div className="relative mt-6n py-2 bg-gradient-to-r from-pink-50 to-rose-50 rounded-2xl p-5 border-2 border-pink-200 text-center">
            <Badge className="absolute -top-3 left-0 left-5 bg-black text-white px-3 py-0 rounded-full">
              3 GIORNI GRATIS
            </Badge>

            <div className="flex flex-col items-center">
              <div className="flex items-end space-x-2">
                <span className="text-3xl font-bold text-gray-800">€3,90</span>
                <span className="text-gray-600 text-lg">/mese</span>
              </div>
              <p className="text-sm text-gray-600 mt-1">
                Pagato annuo a €47
              </p>
              <Badge className=" mt-2 bg-yellow-500 text-black">Ultimi 2 posti disponibili per questo mese</Badge>
            </div>
          </div> */}

          {/* Email Input */}
          <div className="space-y-2 relative">
            <Label htmlFor="email" className="text-sm font-medium text-gray-700">
              Inserisci il Tuo Indirizzo Email Per Continuare e Ricevere il Regalo
            </Label>
            <div className="relative">
              <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <Input
                id="email"
                type="email"
                placeholder="Inserisci l'indirizzo email"
                value={email}
                onChange={(e) => {
                  setEmail(e.target.value)
                  setShowSuggestions(true) // 👈 open dropdown while typing
                }}
                className="pl-10 h-12 border-pink-200 focus:border-pink-400 focus:ring-pink-400"
              />
            </div>

            {/* Suggestions dropdown */}
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

          {/* Subscribe Button */}
          <Button
            onClick={handleSubscribe}
            disabled={isLoading || !email}
            className="w-full h-14 text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-semibold rounded-xl shadow-lg transition-all duration-300 hover:scale-105 disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isLoading ? (
              <div className="flex items-center space-x-2">
                <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                <span>Processing...</span>
              </div>
            ) : (
              <div className="flex items-center space-x-2">
                {/* <CreditCard className="w-5 h-5" /> */}
                <div className="flex flex-col">
                  <span>Avvia la tua prova gratuita</span>
                  <span className="text-xs">Clicca per continuare</span>
                </div>
              </div>
            )}
          </Button>

          {/* Trust Indicators */}
          {/* <div className="flex items-center justify-center space-x-4 text-xs text-gray-500">
            <div className="flex items-center space-x-1">
              <Shield className="w-3 h-3" />
              <span>Secure Payment</span>
            </div>
            <div className="w-1 h-1 bg-gray-300 rounded-full" />
            <span>Cancel Anytime</span>
            <div className="w-1 h-1 bg-gray-300 rounded-full" />
            <span>No Hidden Fees</span>
          </div> */}

          {/* <p className="text-xs text-gray-500 text-center leading-relaxed">
            Avvia la tua prova gratuita di 3 giorni oggi. Dopo la prova, sarai fatturato €49/anno. Puoi annullare in qualsiasi momento
            durante la fase di prova con no costi.
          </p> */}
        </div>
      </DialogContent>
    </Dialog>
  )
}
