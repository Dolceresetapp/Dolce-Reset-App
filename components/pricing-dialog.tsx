"use client"

import { useState } from "react"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Badge } from "@/components/ui/badge"
import { Crown, Mail, CreditCard, Shield, CheckCircle } from "lucide-react"
import Image from "next/image"

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
        {/* <div className="bg-gradient-to-br from-pink-500 to-rose-500 text-white p-6 rounded-t-lg">
          <DialogHeader className="text-center space-y-2">
            <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-2">
              <Crown className="w-8 h-8 text-white" />
            </div>
            <DialogTitle className="text-2xl font-bold">Start Your Transformation</DialogTitle>
            <p className="text-pink-100 text-sm">Join thousands of women already transforming their lives</p>
          </DialogHeader>
        </div> */}

        <div className="p-6 space-y-6">
          {/* Pricing Card */}
          {/* <div className="bg-gradient-to-r from-pink-50 to-rose-50 rounded-2xl p-4 border-2 border-pink-200 relative">
            <Badge className="absolute -top-3 left-1/2 -translate-x-1/2 bg-green-500 text-white px-3 py-1">
              3 Days FREE Trial
            </Badge>

            <div className="text-center pt-2">
              <div className="flex items-center justify-center space-x-2 mb-2">
                <span className="text-3xl font-bold text-gray-800">€4.08</span>
                <span className="text-gray-600">/month</span>
              </div>
              <p className="text-sm text-gray-600 mb-3">
                Billed yearly at €49 • <span className="text-green-600 font-semibold">Save 83%</span>
              </p>

              <div className="space-y-2 text-left">
                {[
                  "Personalized workout plans",
                  "AI-powered meal planning",
                  "Progress tracking & analytics",
                  "24/7 AI health consultant",
                ].map((feature, i) => (
                  <div key={i} className="flex items-center space-x-2">
                    <CheckCircle className="w-4 h-4 text-green-500" />
                    <span className="text-sm text-gray-700">{feature}</span>
                  </div>
                ))}
              </div>
            </div>
          </div> */}

<Image src="/custom/steps.png" width={500} height={500} alt="" className="w-full" />

{/* Yearly Pricing Card */}
<div className="relative mt-6 bg-gradient-to-r from-pink-50 to-rose-50 rounded-2xl p-5 border-2 border-pink-200 text-center">
  <Badge className="absolute -top-3 left-0 left-5 bg-black text-white px-3 py-1 rounded-full">
    3 DAYS FREE
  </Badge>

  <div className="flex flex-col items-center">
    <div className="flex items-end space-x-2">
      <span className="text-3xl font-bold text-gray-800">€2.91</span>
      <span className="text-gray-600 text-lg">/mo</span>
    </div>
    <p className="text-sm text-gray-600 mt-1">
      Billed yearly at €34.99
    </p>
  </div>
</div>

          {/* Email Input */}
          <div className="space-y-2 relative">
            <Label htmlFor="email" className="text-sm font-medium text-gray-700">
              Email Address
            </Label>
            <div className="relative">
              <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <Input
                id="email"
                type="email"
                placeholder="Enter your email address"
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
                <CreditCard className="w-5 h-5" />
                <span>Start Free Trial</span>
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

          <p className="text-xs text-gray-500 text-center leading-relaxed">
            Start your 3-day free trial today. After the trial, you'll be charged €49/year. You can cancel anytime
            during the trial period with no charges.
          </p>
        </div>
      </DialogContent>
    </Dialog>
  )
}
