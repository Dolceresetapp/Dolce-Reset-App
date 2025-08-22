"use client"

import { BottomNavigation } from "@/components/bottom-navigation"
import { Button } from "@/components/ui/button"
import { Send } from "lucide-react"
import Link from "next/link"
import Header from "@/components/header"

export default function TelegramCommunityCard() {
  return (
   <>
   <Header/>
    <div className="h-min-screen flex flex-col justify-center p-4">
      <div className="w-full max-w-sm bg-white p-6 text-center">
        <div className="flex flex-col items-center gap-10">
          {/* Icon */}
          <div className="w-28 h-28 flex items-center justify-center rounded-full bg-pink-100">
            <Send className="w-14 h-14 text-pink-600" />
          </div>

          {/* Heading */}
          <h2 className="text-3xl font-bold text-pink-600">
          Unisciti alla community di Telegram
          </h2>

          {/* Features */}
          <ul className="text-sm text-gray-700 space-y-6 text-left">
            <li className="flex items-center gap-2 text-xl font-semibold text-[#b85eff]">
              <span className="text-pink-500 text-2xl">★</span> Condividi il tuo progresso
            </li>
            <li className="flex items-center gap-2 text-xl font-semibold text-[#b85eff]">
              <span className="text-pink-500 text-2xl">★</span> Prendi ispirazione e motivazione
            </li>
            <li className="flex items-center gap-2 text-xl font-semibold text-[#b85eff]">
              <span className="text-pink-500 text-2xl">★</span> Chiamata video con i medici
            </li>
            <li className="flex items-center gap-2 text-xl font-semibold text-[#b85eff]">
              <span className="text-pink-500 text-2xl">★</span> Trucchi giornalieri per il tuo corpo
            </li>
          </ul>

          {/* Button */}
          <Link href="https://t.me/+iDksb3Ef-8lhNmU0" className="w-full" target="_blank">
          <Button className="w-full bg-gradient-to-r from-pink-500 to-purple-500 hover:from-pink-600 hover:to-purple-600 text-white font-bold h-auto rounded-full">
          ISCRIVITI ORA <br /> CLICCA QUI
          </Button>
          </Link>
        </div>
      </div>
      <BottomNavigation />
    </div>
   </>
  )
}
