"use client"

import { useEffect, useState } from "react"
import { Button } from "@/components/ui/button"

export default function DiscountBanner() {
  const [timeLeft, setTimeLeft] = useState(600) // 10 minutes = 600 seconds

  useEffect(() => {
    if (timeLeft <= 0) return
    const timer = setInterval(() => {
      setTimeLeft((prev) => prev - 1)
    }, 1000)
    return () => clearInterval(timer)
  }, [timeLeft])

  const formatTime = (seconds: number) => {
    const mins = Math.floor(seconds / 60)
    const secs = seconds % 60
    return `${mins}:${secs.toString().padStart(2, "0")}`
  }

  return (
    <div className="w-full bg-purple-500 text-white flex items-center justify-between px-4 py-2 rounded-lg">
      <div className="flex flex-col">
        <span className="text-xs">Your 50% discount ends soon:</span>
        <span className="text-2xl font-bold">{formatTime(timeLeft)}</span>
      </div>
      <Button className="bg-white text-purple-600 font-semibold rounded-full px-4 py-2 hover:bg-purple-100">
        Save 50%
      </Button>
    </div>
  )
}
