"use client"

import type React from "react"

import { useState } from "react"
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { CheckCircle, Crown, Mail, CreditCard, Shield, Clock } from "lucide-react"
import { toast } from "sonner"

interface PricingDialogProps {
  open: boolean
  onOpenChange: (open: boolean) => void
  onComplete: () => void
}

export function PricingDialog({ open, onOpenChange, onComplete }: PricingDialogProps) {
  const [email, setEmail] = useState("")
  const [isLoading, setIsLoading] = useState(false)
  const [step, setStep] = useState<"pricing" | "email" | "processing">("pricing")

  const handleStartTrial = () => {
    setStep("email")
  }

  const handleEmailSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!email || !email.includes("@")) {
      toast.error("Please enter a valid email address")
      return
    }

    setIsLoading(true)
    setStep("processing")

    try {
      // Create Stripe checkout session
      const response = await fetch("/api/create-subscription-checkout", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          email,
          priceId: process.env.NEXT_PUBLIC_STRIPE_PRICE_ID, // Your Stripe price ID
        }),
      })

      const { url, error } = await response.json()

      if (error) {
        toast.error("Something went wrong. Please try again.")
        setIsLoading(false)
        setStep("email")
        return
      }

      // Store email in localStorage for later account creation
      localStorage.setItem("subscription_email", email)

      // Redirect to Stripe Checkout
      window.location.href = url
    } catch (error) {
      console.error("Error creating checkout session:", error)
      toast.error("Something went wrong. Please try again.")
      setIsLoading(false)
      setStep("email")
    }
  }

  const resetDialog = () => {
    setStep("pricing")
    setEmail("")
    setIsLoading(false)
  }

  const handleClose = (open: boolean) => {
    if (!open) {
      resetDialog()
    }
    onOpenChange(open)
  }

  return (
    <Dialog open={open} onOpenChange={handleClose}>
      <DialogContent className="sm:max-w-md mx-4 rounded-3xl">
        {step === "pricing" && (
          <>
            <DialogHeader className="text-center pb-4">
              <DialogTitle className="text-2xl font-bold text-gray-800 mb-2">🎉 Start Your Transformation</DialogTitle>
              <p className="text-sm text-gray-600">Get your personalized fitness plan with a 3-day free trial</p>
            </DialogHeader>

            {/* Pricing Card */}
            <Card className="border-2 border-pink-200 bg-gradient-to-br from-pink-50 to-rose-50">
              <CardContent className="p-6">
                <div className="text-center mb-4">
                  <Badge className="bg-green-100 text-green-700 mb-3">
                    <Clock className="w-3 h-3 mr-1" />3 Days FREE Trial
                  </Badge>
                  <div className="flex items-center justify-center space-x-2 mb-2">
                    <span className="text-3xl font-bold text-gray-800">€49</span>
                    <span className="text-lg text-gray-600">/year</span>
                  </div>
                  <p className="text-sm text-gray-600 mb-1">Only €4.08/month</p>
                  <p className="text-xs text-gray-500">After 3-day free trial</p>
                </div>

                {/* Features */}
                <div className="space-y-3 mb-6">
                  <div className="flex items-center space-x-3">
                    <CheckCircle className="w-4 h-4 text-green-500 flex-shrink-0" />
                    <span className="text-sm text-gray-700">Personalized workout plans</span>
                  </div>
                  <div className="flex items-center space-x-3">
                    <CheckCircle className="w-4 h-4 text-green-500 flex-shrink-0" />
                    <span className="text-sm text-gray-700">Daily nutrition guidance</span>
                  </div>
                  <div className="flex items-center space-x-3">
                    <CheckCircle className="w-4 h-4 text-green-500 flex-shrink-0" />
                    <span className="text-sm text-gray-700">Progress tracking tools</span>
                  </div>
                  <div className="flex items-center space-x-3">
                    <CheckCircle className="w-4 h-4 text-green-500 flex-shrink-0" />
                    <span className="text-sm text-gray-700">24/7 AI support</span>
                  </div>
                  <div className="flex items-center space-x-3">
                    <CheckCircle className="w-4 h-4 text-green-500 flex-shrink-0" />
                    <span className="text-sm text-gray-700">Cancel anytime</span>
                  </div>
                </div>

                {/* Trial Info */}
                <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 mb-4">
                  <div className="flex items-start space-x-3">
                    <Shield className="w-5 h-5 text-blue-500 flex-shrink-0 mt-0.5" />
                    <div>
                      <p className="text-sm font-medium text-blue-800 mb-1">Free Trial Details</p>
                      <p className="text-xs text-blue-600 leading-relaxed">
                        Start your 3-day free trial today. If you don't cancel before the trial ends, you'll be charged
                        €49 for a full year of access. Cancel anytime during the trial with no charges.
                      </p>
                    </div>
                  </div>
                </div>

                <Button
                  onClick={handleStartTrial}
                  className="w-full h-12 bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-xl shadow-lg transition-all duration-300 hover:scale-105"
                >
                  <Crown className="w-5 h-5 mr-2" />
                  Start Free Trial
                </Button>
              </CardContent>
            </Card>
          </>
        )}

        {step === "email" && (
          <>
            <DialogHeader className="text-center pb-4">
              <DialogTitle className="text-xl font-bold text-gray-800 mb-2">Enter Your Email</DialogTitle>
              <p className="text-sm text-gray-600">We'll send your plan details and trial information here</p>
            </DialogHeader>

            <form onSubmit={handleEmailSubmit} className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="email" className="text-sm font-medium text-gray-700">
                  Email Address
                </Label>
                <div className="relative">
                  <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                  <Input
                    id="email"
                    type="email"
                    placeholder="your@email.com"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    className="pl-10 h-12 rounded-xl border-pink-200 focus:border-pink-400 focus:ring-pink-400"
                    required
                  />
                </div>
              </div>

              <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4">
                <div className="flex items-start space-x-3">
                  <CreditCard className="w-5 h-5 text-yellow-600 flex-shrink-0 mt-0.5" />
                  <div>
                    <p className="text-sm font-medium text-yellow-800 mb-1">Next Step</p>
                    <p className="text-xs text-yellow-700 leading-relaxed">
                      After entering your email, you'll be redirected to secure Stripe checkout to start your 3-day free
                      trial. No charges during the trial period.
                    </p>
                  </div>
                </div>
              </div>

              <div className="flex space-x-3">
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => setStep("pricing")}
                  className="flex-1 h-12 rounded-xl border-gray-300"
                >
                  Back
                </Button>
                <Button
                  type="submit"
                  disabled={isLoading}
                  className="flex-1 h-12 bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-xl shadow-lg transition-all duration-300 hover:scale-105"
                >
                  {isLoading ? "Processing..." : "Continue to Payment"}
                </Button>
              </div>
            </form>
          </>
        )}

        {step === "processing" && (
          <div className="text-center py-8">
            <div className="w-16 h-16 bg-gradient-to-br from-pink-400 to-rose-400 rounded-full flex items-center justify-center mb-4 mx-auto animate-pulse">
              <CreditCard className="w-8 h-8 text-white" />
            </div>
            <h3 className="text-lg font-bold text-gray-800 mb-2">Redirecting to Payment...</h3>
            <p className="text-sm text-gray-600">Please wait while we prepare your secure checkout</p>
          </div>
        )}
      </DialogContent>
    </Dialog>
  )
}
