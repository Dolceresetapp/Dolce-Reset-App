"use client"

import { useState, useEffect } from "react"
import { useUser, useClerk } from "@clerk/nextjs"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import {
  X,
  LogIn,
  Stethoscope,
  ChefHat,
  Users,
  Crown,
  User,
  LogOut,
  Sparkles,
  Heart,
  Download,
  Smartphone,
  Settings,
} from "lucide-react"
import { InstallPrompt } from "./install-prompt"

interface MobileMenuProps {
  open: boolean
  onClose: () => void
}

export function MobileMenu({ open, onClose }: MobileMenuProps) {
  const { user, isSignedIn } = useUser()
  const { signOut, openUserProfile } = useClerk()
  const [showInstallPrompt, setShowInstallPrompt] = useState(false)
  const [deferredPrompt, setDeferredPrompt] = useState<any>(null)
  const [isInstallable, setIsInstallable] = useState(false)
  const [isPremium] = useState(false) // This should come from your user data

  useEffect(() => {
    const handler = (e: any) => {
      e.preventDefault()
      setDeferredPrompt(e)
      setIsInstallable(true)
    }

    window.addEventListener("beforeinstallprompt", handler)

    return () => window.removeEventListener("beforeinstallprompt", handler)
  }, [])

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

  const handleInstallApp = async () => {
    if (deferredPrompt) {
      deferredPrompt.prompt()
      const { outcome } = await deferredPrompt.userChoice
      if (outcome === "accepted") {
        setDeferredPrompt(null)
        setIsInstallable(false)
      }
    } else {
      setShowInstallPrompt(true)
    }
  }

  const handleManageSubscription = async () => {
    try {
      const response = await fetch("/api/create-portal", {
        method: "POST",
      })

      if (response.ok) {
        const { url } = await response.json()
        window.open(url, "_blank")
      } else {
        throw new Error("Failed to create portal session")
      }
    } catch (error) {
      alert("Failed to open subscription management")
    }
  }

  const handleProfileClick = () => {
    openUserProfile()
    onClose()
  }

  const handleSignOut = async () => {
    await signOut()
    onClose()
  }

  return (
    <>
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
            <div className="flex items-center justify-between p-6 bg-white/80 backdrop-blur-sm border-b border-pink-100 rounded-b-3xl">
              <div>
                <h2 className="senior-text-xl font-bold text-gray-800 flex items-center">
                  <Heart className="w-6 h-6 text-pink-500 mr-2" />
                  Menu
                </h2>
                {isSignedIn && (
                  <p className="senior-text-sm text-gray-600">Benvenuta, {user?.firstName || "Beautiful"}!</p>
                )}
              </div>
              <Button
                variant="ghost"
                size="icon"
                onClick={onClose}
                className="h-12 w-12 rounded-2xl hover:bg-pink-100 transition-all duration-200"
              >
                <X className="h-6 w-6 text-gray-600" />
              </Button>
            </div>

            {/* Content */}
            <div className="flex-1 overflow-y-auto p-6">
              {/* Authentication Section */}
              {!isSignedIn ? (
                <div className="mb-8">
                  <Button
                    className="w-full h-16 senior-text-lg bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-bold rounded-3xl shadow-lg transition-all duration-300 hover:scale-105"
                    onClick={() => {
                      window.location.href = "/sign-in"
                      onClose()
                    }}
                  >
                    <LogIn className="w-6 h-6 mr-3" />
                    Accedi / Crea Account
                  </Button>
                </div>
              ) : (
                <div className="mb-8">
                  <Button
                    className="w-full h-16 senior-text-lg bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 text-white font-bold rounded-3xl shadow-lg transition-all duration-300 hover:scale-105"
                    onClick={handleProfileClick}
                  >
                    <Settings className="w-6 h-6 mr-3" />
                    Impostazioni
                  </Button>
                </div>
              )}

              {/* Install App Section */}
              <div className="mb-8">
                <div className="card-hover border-0 shadow-md bg-gradient-to-r from-indigo-50 to-purple-50 backdrop-blur-sm rounded-3xl">
                  <div className="p-4">
                    <Button
                      variant="ghost"
                      className="w-full h-auto p-0 justify-start hover:bg-transparent"
                      onClick={handleInstallApp}
                    >
                      <div className="flex items-center space-x-4 w-full">
                        <div className="w-12 h-12 bg-gradient-to-br from-indigo-500 to-purple-500 rounded-2xl flex items-center justify-center shadow-lg">
                          <Download className="w-6 h-6 text-white" />
                        </div>
                        <div className="text-left flex-1">
                          <h4 className="senior-text-sm font-bold text-gray-800">Installa App</h4>
                          <p className="senior-text-xs text-gray-600">Aggiungi allo schermo d'ingresso</p>
                        </div>
                        <Smartphone className="w-5 h-5 text-indigo-500" />
                      </div>
                    </Button>
                  </div>
                </div>
              </div>

              <div className="mb-8">
                <div className="card-hover border-0 shadow-md bg-gradient-to-r from-indigo-50 to-purple-50 backdrop-blur-sm rounded-3xl">
                  <div className="p-4">
                    <Button
                      variant="ghost"
                      className="w-full h-auto p-0 justify-start hover:bg-transparent"
                      onClick={handleManageSubscription}
                    >
                      <div className="flex items-center space-x-4 w-full">
                        <div className="w-12 h-12 bg-gradient-to-br from-indigo-500 to-purple-500 rounded-2xl flex items-center justify-center shadow-lg">
                          <Crown className="w-6 h-6 text-white" />
                        </div>
                        <div className="text-left flex-1">
                          <h4 className="senior-text-sm font-bold text-gray-800">Abbonamento</h4>
                          <p className="senior-text-xs text-gray-600">Gestisci il tuo abbonamento</p>
                        </div>
                        <Crown className="w-5 h-5 text-indigo-500" />
                      </div>
                    </Button>
                  </div>
                </div>
              </div>

              {/* Premium Features */}
              <div className="mb-8">
                <div className="flex items-center mb-4">
                  <Sparkles className="w-5 h-5 text-pink-500 mr-2" />
                  <h3 className="senior-text-lg font-bold text-gray-800">Funzionalità Premium</h3>
                </div>

                <div className="grid grid-cols-1 gap-4">
                  {premiumFeatures.map((feature, index) => (
                    <div
                      key={feature.label}
                      className="card-hover border-0 shadow-md bg-white/80 backdrop-blur-sm animate-slide-up rounded-3xl"
                      style={{ animationDelay: `${index * 0.1}s` }}
                    >
                      <div className="p-4">
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
                              className={`w-12 h-12 bg-gradient-to-br ${feature.color} rounded-2xl flex items-center justify-center shadow-lg`}
                            >
                              <feature.icon className="w-6 h-6 text-white" />
                            </div>
                            <div className="text-left flex-1">
                              <h4 className="senior-text-xs font-bold text-gray-800">{feature.label}</h4>
                              <p className="senior-text-xs text-gray-600">{feature.description}</p>
                            </div>
                          </div>
                        </Button>
                      </div>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Footer */}
            {isSignedIn && (
              <div className="p-6 bg-white/80 backdrop-blur-sm border-t border-pink-100 rounded-t-3xl">
                <Button
                  onClick={handleSignOut}
                  variant="outline"
                  className="w-full h-14 senior-text-xs border-red-200 text-red-600 hover:bg-red-50 bg-transparent rounded-2xl"
                >
                  <LogOut className="w-5 h-5 mr-3" />
                  Esci
                </Button>
              </div>
            )}
          </div>
        </div>
      </div>

      {/* Install Prompt Modal */}
      <InstallPrompt open={showInstallPrompt} onClose={() => setShowInstallPrompt(false)} />
    </>
  )
}
