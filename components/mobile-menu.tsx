"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import {
  X,
  LogIn,
  Stethoscope,
  ChefHat,
  Users,
  Crown,
  Home,
  User,
  Settings,
  HelpCircle,
  LogOut,
  Sparkles,
  Heart,
} from "lucide-react"

interface MobileMenuProps {
  open: boolean
  onClose: () => void
}

export function MobileMenu({ open, onClose }: MobileMenuProps) {
  if (!open) return null

  const premiumFeatures = [
    {
      icon: Stethoscope,
      label: "AI Doctor",
      description: "Personal health guidance",
      href: "/ai-doctor",
      color: "from-blue-500 to-cyan-500",
    },
    {
      icon: ChefHat,
      label: "AI Chef",
      description: "Healthy meal planning",
      href: "/ai-chef",
      color: "from-green-500 to-emerald-500",
    },
    {
      icon: Users,
      label: "Join Community",
      description: "Connect with other women",
      href: "/community",
      color: "from-purple-500 to-pink-500",
    },
    {
      icon: Crown,
      label: "Premium Exercises",
      description: "Exclusive workout content",
      href: "/premium",
      color: "from-amber-500 to-orange-500",
    },
  ]

  const regularMenuItems = [
    { icon: Home, label: "Home", href: "/dashboard" },
    { icon: User, label: "My Profile", href: "/profile" },
    { icon: Settings, label: "Settings", href: "/settings" },
    { icon: HelpCircle, label: "Help & Support", href: "/help" },
  ]

  return (
    <div className="fixed inset-0 z-50">
      {/* Backdrop with blur */}
      <div
        className="absolute inset-0 bg-black/60 backdrop-blur-md transition-all duration-500 ease-out"
        onClick={onClose}
      />

      {/* Menu Panel - Full Screen */}
      <div className="absolute inset-0 bg-gradient-to-br from-rose-50 via-pink-50 to-orange-50 transform transition-all duration-500 ease-out animate-slide-in-right">
        <div className="flex flex-col h-full">
          {/* Header */}
          <div className="flex items-center justify-between p-6 bg-white/80 backdrop-blur-sm border-b border-pink-100">
            <div>
              <h2 className="senior-text-xl font-bold text-gray-800 flex items-center">
                Menu
              </h2>
              {/* <p className="senior-text-sm text-gray-600">Everything you need for your wellness journey</p> */}
            </div>
            <Button
              variant="ghost"
              size="icon"
              onClick={onClose}
              className="h-12 w-12 rounded-full hover:bg-pink-100 transition-all duration-200"
            >
              <X className="h-6 w-6 text-gray-600" />
            </Button>
          </div>

          {/* Content */}
          <div className="flex-1 overflow-y-auto p-6">
            {/* Login Section */}
            <div className="mb-8">
              <Button
                className="w-full h-16 senior-text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-2xl shadow-lg transition-all duration-300 hover:scale-105"
                onClick={() => {
                  window.location.href = "/sign-in"
                  onClose()
                }}
              >
                <LogIn className="w-6 h-6 mr-3" />
                Sign In / Create Account
              </Button>
            </div>

            {/* Premium Features */}
            <div className="mb-8">
              <div className="flex items-center mb-4">
                <Sparkles className="w-5 h-5 text-pink-500 mr-2" />
                <h3 className="senior-text-lg font-bold text-gray-800">Premium Features</h3>
              </div>

              <div className="grid grid-cols-1 gap-4">
                {premiumFeatures.map((feature, index) => (
                  <Card
                    key={feature.label}
                    className="card-hover border-0 shadow-md bg-white/80 backdrop-blur-sm animate-slide-up"
                    style={{ animationDelay: `${index * 0.1}s` }}
                  >
                    <CardContent className="p-4">
                      <Button
                        variant="ghost"
                        className="w-full h-auto p-0 justify-start hover:bg-transparent"
                        onClick={() => {
                          window.location.href = feature.href
                          onClose()
                        }}
                      >
                        <div className="flex items-center space-x-4 w-full">
                          <div
                            className={`w-12 h-12 bg-gradient-to-br ${feature.color} rounded-xl flex items-center justify-center shadow-lg`}
                          >
                            <feature.icon className="w-6 h-6 text-white" />
                          </div>
                          <div className="text-left flex-1">
                            <h4 className="senior-text-base font-bold text-gray-800">{feature.label}</h4>
                            <p className="senior-text-sm text-gray-600">{feature.description}</p>
                          </div>
                          {/* {feature.label === "Premium Exercises" && (
                            <Badge className="bg-gradient-to-r from-amber-400 to-orange-400 text-white border-0 senior-text-sm">
                              NEW
                            </Badge>
                          )} */}
                        </div>
                      </Button>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>

            {/* Regular Menu Items */}
            <div className="mb-8">
              <h3 className="senior-text-lg font-bold text-gray-800 mb-4">Quick Access</h3>
              <div className="space-y-2">
                {regularMenuItems.map((item, index) => (
                  <Button
                    key={item.label}
                    variant="ghost"
                    className="w-full justify-start h-14 senior-text-base hover:bg-pink-50 hover:text-pink-700 transition-all duration-200 rounded-xl"
                    onClick={() => {
                      window.location.href = item.href
                      onClose()
                    }}
                  >
                    <item.icon className="w-5 h-5 mr-4" />
                    {item.label}
                  </Button>
                ))}
              </div>
            </div>
          </div>

          {/* Footer */}
          <div className="p-6 bg-white/80 backdrop-blur-sm border-t border-pink-100">
            <Button
              variant="outline"
              className="w-full h-14 senior-text-base border-red-200 text-red-600 hover:bg-red-50 bg-transparent rounded-xl"
            >
              <LogOut className="w-5 h-5 mr-3" />
              Sign Out
            </Button>
          </div>
        </div>
      </div>
    </div>
  )
}
