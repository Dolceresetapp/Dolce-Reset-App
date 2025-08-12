"use client"

import { useRouter, usePathname } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Home, Grid3X3, User } from "lucide-react"

export function BottomNavigation() {
  const router = useRouter()
  const pathname = usePathname()

  const navItems = [
    {
      id: "home",
      label: "Home",
      icon: Home,
      path: "/dashboard",
      color: "text-pink-500",
    },
    {
      id: "features",
      label: "Features",
      icon: Grid3X3,
      path: "/features",
      color: "text-purple-500",
    },
    {
      id: "profile",
      label: "Profile",
      icon: User,
      path: "/profile",
      color: "text-blue-500",
    },
  ]

  const isActive = (path: string) => {
    if (path === "/dashboard") {
      return pathname === "/" || pathname === "/dashboard"
    }
    return pathname.startsWith(path)
  }

  return (
    <div className="fixed bottom-0 left-0 right-0 z-50">
      <div className="max-w-md mx-auto bg-white/95 backdrop-blur-sm border-t border-pink-100 shadow-lg rounded-t-3xl">
        <div className="flex items-center justify-around py-4 px-6">
          {navItems.map((item) => (
            <Button
              key={item.id}
              variant="ghost"
              size="sm"
              onClick={() => router.push(item.path)}
              className={`flex flex-col items-center space-y-2 h-auto py-3 px-4 rounded-2xl transition-all duration-200 ${
                isActive(item.path)
                  ? "bg-pink-100 text-pink-600 scale-105"
                  : "text-gray-500 hover:text-gray-700 hover:bg-gray-50"
              }`}
            >
              <item.icon className={`w-6 h-6 ${isActive(item.path) ? item.color : "text-current"}`} />
              <span className="text-xs font-medium">{item.label}</span>
            </Button>
          ))}
        </div>
      </div>
    </div>
  )
}
