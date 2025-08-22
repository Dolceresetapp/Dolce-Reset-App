"use client"

import { useState } from "react"
import { Button } from "@/components/ui/button"
import SalesPage from "@/components/sales"
import { PricingDialog } from "@/components/pricing-dialog"

export default function CheckoutPage() {
  const [showPricingDialog, setShowPricingDialog] = useState(false)

  const handleStartTrial = () => {
    setShowPricingDialog(true)
  }

  return (
    <>
      <div className="app-container bg-gradient-to-br from-rose-50 via-pink-50 to-red-50 min-h-screen pb-20">
        <div className="p-4 pt-6">
          <SalesPage />
        </div>

        {/* Fixed Bottom CTA Button */}
        <div className="fixed bottom-0 left-0 right-0 bg-white/95 backdrop-blur-sm border-t border-pink-100 p-4 shadow-lg">
          <Button
            onClick={handleStartTrial}
            className="w-full h-18 text-xl bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-light rounded-2xl shadow-xl transition-all duration-300 hover:scale-105"
          >
           <div className="flex flex-col items-center">
            <span>Inizia la tua prova gratuita di 3 giorni</span>
            <span className="">Premi qui per iniziare</span>
          </div>

          </Button>
        </div>
      </div>

      {/* Pricing Dialog */}
      <PricingDialog open={showPricingDialog} onOpenChange={setShowPricingDialog} />
    </>
  )
}
