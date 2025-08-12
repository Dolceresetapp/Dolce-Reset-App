"use client"

import { useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { ArrowLeft, Users, ExternalLink } from "lucide-react"

export default function CommunityPage() {
  const router = useRouter()

  useEffect(() => {
    // Redirect to Telegram channel after a brief moment
    const timer = setTimeout(() => {
      // Replace with your actual Telegram channel URL
      window.open("https://t.me/seniorfitcommunity", "_blank")
      router.back()
    }, 2000)

    return () => clearTimeout(timer)
  }, [router])

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-pink-100 rounded-b-3xl">
        <div className="flex items-center justify-between p-4">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => router.back()}
            className="h-12 w-12 rounded-2xl hover:bg-pink-100"
          >
            <ArrowLeft className="h-6 w-6 text-gray-600" />
          </Button>
          <div className="text-center">
            <h1 className="senior-text-lg font-bold text-gray-800">Community</h1>
            <p className="senior-text-sm text-gray-600">Redirecting to Telegram...</p>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Content */}
      <div className="flex items-center justify-center min-h-[80vh] p-6">
        <Card className="bg-gradient-to-r from-purple-500 to-pink-500 text-white border-0 shadow-xl animate-fade-in rounded-3xl">
          <CardContent className="p-8 text-center">
            <Users className="w-16 h-16 mx-auto mb-4" />
            <h2 className="senior-text-xl font-bold mb-4">Joining Our Community</h2>
            <p className="senior-text-base opacity-90 mb-6 leading-relaxed">
              You're being redirected to our exclusive Telegram community where you can connect with other amazing women
              on their wellness journey.
            </p>
            <div className="flex items-center justify-center space-x-2">
              <div className="w-3 h-3 bg-white/60 rounded-full animate-bounce"></div>
              <div className="w-3 h-3 bg-white/60 rounded-full animate-bounce" style={{ animationDelay: "0.1s" }}></div>
              <div className="w-3 h-3 bg-white/60 rounded-full animate-bounce" style={{ animationDelay: "0.2s" }}></div>
            </div>
            <Button
              onClick={() => {
                window.open("https://t.me/seniorfitcommunity", "_blank")
                router.back()
              }}
              variant="outline"
              className="mt-6 bg-white/20 border-white/30 text-white hover:bg-white/30 rounded-2xl"
            >
              <ExternalLink className="w-4 h-4 mr-2" />
              Open Telegram Now
            </Button>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
