"use client"

import { useState } from "react"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Badge } from "@/components/ui/badge"
import { Crown, Mail, CreditCard, Shield, CheckCircle } from "lucide-react"

interface PricingDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
}

export function PricingDialog({ open, onOpenChange }: PricingDialogProps) {
  const [email, setEmail] = useState("")
  const [isLoading, setIsLoading] = useState(false)

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

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="w-[95vw] max-w-md mx-auto max-h-[90vh] overflow-y-auto p-0 gap-0">
        <div className="bg-gradient-to-br from-pink-500 to-rose-500 text-white p-6 rounded-t-lg">
          <DialogHeader className="text-center space-y-2">
            <div className="w-16 h-16 bg-white/20 rounded-full flex items-center justify-center mx-auto mb-2">
              <Crown className="w-8 h-8 text-white" />
            </div>
            <DialogTitle className="text-2xl font-bold">Start Your Transformation</DialogTitle>
            <p className="text-pink-100 text-sm">Join thousands of women already transforming their lives</p>
          </DialogHeader>
        </div>

        <div className="p-6 space-y-6">
          {/* Pricing Card */}
          <div className="bg-gradient-to-r from-pink-50 to-rose-50 rounded-2xl p-4 border-2 border-pink-200 relative">
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

              {/* Features */}
              <div className="space-y-2 text-left">
                <div className="flex items-center space-x-2">
                  <CheckCircle className="w-4 h-4 text-green-500" />
                  <span className="text-sm text-gray-700">Personalized workout plans</span>
                </div>
                <div className="flex items-center space-x-2">
                  <CheckCircle className="w-4 h-4 text-green-500" />
                  <span className="text-sm text-gray-700">AI-powered meal planning</span>
                </div>
                <div className="flex items-center space-x-2">
                  <CheckCircle className="w-4 h-4 text-green-500" />
                  <span className="text-sm text-gray-700">Progress tracking & analytics</span>
                </div>
                <div className="flex items-center space-x-2">
                  <CheckCircle className="w-4 h-4 text-green-500" />
                  <span className="text-sm text-gray-700">24/7 AI health consultant</span>
                </div>
              </div>
            </div>
          </div>

          {/* Email Input */}
          <div className="space-y-2">
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
                onChange={(e) => setEmail(e.target.value)}
                className="pl-10 h-12 border-pink-200 focus:border-pink-400 focus:ring-pink-400"
              />
            </div>
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
          <div className="flex items-center justify-center space-x-4 text-xs text-gray-500">
            <div className="flex items-center space-x-1">
              <Shield className="w-3 h-3" />
              <span>Secure Payment</span>
            </div>
            <div className="w-1 h-1 bg-gray-300 rounded-full" />
            <span>Cancel Anytime</span>
            <div className="w-1 h-1 bg-gray-300 rounded-full" />
            <span>No Hidden Fees</span>
          </div>

          {/* Terms */}
          <p className="text-xs text-gray-500 text-center leading-relaxed">
            Start your 3-day free trial today. After the trial, you'll be charged €49/year. You can cancel anytime
            during the trial period with no charges.
          </p>
        </div>
      </DialogContent>
    </Dialog>
  )
}
