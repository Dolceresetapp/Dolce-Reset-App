"use client"

import { useEffect, useState } from "react"
import { useSearchParams } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { ArrowRight } from "lucide-react"
import Link from "next/link"

export default function PaymentSuccessPage() {
  const searchParams = useSearchParams()
  const sessionId = searchParams.get("session_id")
  const [isLoading, setIsLoading] = useState(true)

  useEffect(() => {
    // Simulate loading
    const timer = setTimeout(() => {
      setIsLoading(false)
    }, 2000)

    return () => clearTimeout(timer)
  }, [])

  if (isLoading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-rose-50 via-pink-50 to-red-50 flex items-center justify-center p-4">
        <Card className="w-full max-w-md">
          <CardContent className="p-8 text-center">
            <div className="w-16 h-16 border-4 border-pink-200 border-t-pink-500 rounded-full animate-spin mx-auto mb-4" />
            <h2 className="text-xl font-bold text-gray-800 mb-2">Activating Plan...</h2>
            <p className="text-gray-600">Please wait while we confirm your subscription.</p>
          </CardContent>
        </Card>
      </div>
    )
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-rose-50 via-pink-50 to-red-50 flex items-center justify-center p-4">
      <Card className="w-full max-w-md">
        <CardContent className="p-8 ">

          {/* Success Message */}
          <h1 className="text-2xl font-bold text-gray-800 mb-4">
            <span className="mr-2">✅</span> Benvenuta nel tuo nuovo inizio!
          </h1>

          <p className="text-gray-700 mb-6">
            Nessun addebito ora: stai iniziando la tua prova gratuita. <br />
            Puoi cancellare in qualsiasi momento dall’app, anche prima dei 3 giorni. <br />
            Intanto goditi l’accesso completo:
          </p>

          {/* Points */}
          <ul className="list-disc text-left text-gray-700 space-y-2 pl-6 mb-6">
            <li>👉 Crea il tuo account</li>
            <li>👉 Inizia subito i tuoi esercizi, a mangiare sano e ad avere supporto</li>
            <li>👉 Fai il primo passo verso il tuo cambiamento!</li>
          </ul>

          <p className="text-gray-700 mb-6">
            💌 Ti invieremo promemoria via email prima della scadenza della prova gratuita. <br />
            ✨ Sii orgogliosa: hai fatto un passo importante, è arrivato il momento di prendersi cura di te stessa! BASTA dire “dalla settimana prossima inizio”. Bravissima!
          </p>

          {/* CTA Button */}
          <Link href="/sign-up">
            <Button className="w-full h-12 text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-semibold rounded-xl shadow-lg transition-all duration-300 hover:scale-105">
              Crea il tuo account
              <ArrowRight className="w-5 h-5 ml-2" />
            </Button>
          </Link>

          {/* Support */}
          <p className="text-xs text-gray-500 mt-4">
            Hai bisogno di aiuto? Contatta il nostro supporto in qualsiasi momento.
          </p>
        </CardContent>
      </Card>
    </div>
  )
}
