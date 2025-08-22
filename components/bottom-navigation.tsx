"use client"

import { useRouter, usePathname } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Home, Dumbbell, Stethoscope, Users, CookingPot } from "lucide-react"

export function BottomNavigation() {
  const router = useRouter()
  const pathname = usePathname()

  const navItems = [
    
    {
      id: "exercises",
      label: "Exercises",
      icon: Dumbbell,
      path: "/features",
    },
    {
      id: "doctor",
      label: "Doctor",
      icon: Stethoscope,
      path: "/ai-doctor",
    },
    {
      id: "chef",
      label: "Ai Chef",
      icon: CookingPot,
      path: "/ai-chef",
    },
    {
      id: "community",
      label: "Community",
      icon: Users,
      path: "/community",
    },
  ]

  const isActive = (path: string) => {
    if (path === "/dashboard") {
      return pathname === "/" || pathname === "/dashboard"
    }
    return pathname.startsWith(path)
  }

  return (
    <div className="fixed bottom-0 left-0 right-0 z-40">
      <div className="max-w-md mx-auto bg-gradient-to-r from-purple-500 to-pink-500 rounded-t-3xl shadow-2xl">
        <div className="flex items-center justify-around py-4 px-4">
          {navItems.map((item) => (
            <Button
              key={item.id}
              variant="ghost"
              size="sm"
              onClick={() => router.push(item.path)}
              className={`flex flex-col items-center space-y-1 h-auto py-3 px-4 rounded-2xl transition-all duration-200 hover:bg-white/20 ${
                isActive(item.path) ? "bg-white/30 text-white shadow-lg scale-110" : "text-white/80 hover:text-white"
              }`}
            >
              <item.icon className="w-6 h-6" />
              <span className="text-xs font-medium">{item.label}</span>
            </Button>
          ))}
        </div>
      </div>
    </div>
  )
}
