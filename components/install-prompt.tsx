"use client"

import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { X, Smartphone, Share, Plus, Download } from "lucide-react"

interface InstallPromptProps {
  open: boolean
  onClose: () => void
}

export function InstallPrompt({ open, onClose }: InstallPromptProps) {
  if (!open) return null

  const isIOS = /iPad|iPhone|iPod/.test(navigator.userAgent)
  const isAndroid = /Android/.test(navigator.userAgent)

  return (
    <div className="fixed inset-0 z-60 animate-fade-in">
      {/* Backdrop */}
      <div className="absolute inset-0 bg-black/70 backdrop-blur-sm" onClick={onClose} />

      {/* Modal */}
      <div className="absolute inset-0 flex items-center justify-center p-4">
        <Card className="w-full max-w-sm bg-white border-0 shadow-2xl animate-slide-up">
          <CardContent className="p-6">
            {/* Header */}
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center">
                <div className="w-12 h-12 bg-gradient-to-br from-pink-500 to-rose-500 rounded-xl flex items-center justify-center mr-3">
                  <Smartphone className="w-6 h-6 text-white" />
                </div>
                <div>
                  <h3 className="senior-text-lg font-bold text-gray-800">Install SeniorFit</h3>
                  <p className="senior-text-sm text-gray-600">Add to home screen</p>
                </div>
              </div>
              <Button variant="ghost" size="icon" onClick={onClose} className="h-8 w-8">
                <X className="h-4 w-4" />
              </Button>
            </div>

            {/* Instructions */}
            <div className="space-y-4 mb-6">
              {isIOS && (
                <>
                  <div className="flex items-start space-x-3">
                    <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                      <span className="text-blue-600 font-bold senior-text-sm">1</span>
                    </div>
                    <div>
                      <p className="senior-text-base font-semibold text-gray-800">Tap the Share button</p>
                      <div className="flex items-center mt-2">
                        <Share className="w-5 h-5 text-blue-500 mr-2" />
                        <span className="senior-text-sm text-gray-600">At the bottom of your screen</span>
                      </div>
                    </div>
                  </div>

                  <div className="flex items-start space-x-3">
                    <div className="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                      <span className="text-green-600 font-bold senior-text-sm">2</span>
                    </div>
                    <div>
                      <p className="senior-text-base font-semibold text-gray-800">Add to Home Screen</p>
                      <div className="flex items-center mt-2">
                        <Plus className="w-5 h-5 text-green-500 mr-2" />
                        <span className="senior-text-sm text-gray-600">Scroll down and tap this option</span>
                      </div>
                    </div>
                  </div>
                </>
              )}

              {isAndroid && (
                <>
                  <div className="flex items-start space-x-3">
                    <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                      <span className="text-blue-600 font-bold senior-text-sm">1</span>
                    </div>
                    <div>
                      <p className="senior-text-base font-semibold text-gray-800">Open browser menu</p>
                      <p className="senior-text-sm text-gray-600 mt-1">Tap the three dots (⋮) in your browser</p>
                    </div>
                  </div>

                  <div className="flex items-start space-x-3">
                    <div className="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                      <span className="text-green-600 font-bold senior-text-sm">2</span>
                    </div>
                    <div>
                      <p className="senior-text-base font-semibold text-gray-800">Add to Home Screen</p>
                      <div className="flex items-center mt-2">
                        <Download className="w-5 h-5 text-green-500 mr-2" />
                        <span className="senior-text-sm text-gray-600">Look for "Install" or "Add to Home Screen"</span>
                      </div>
                    </div>
                  </div>
                </>
              )}

              {!isIOS && !isAndroid && (
                <div className="text-center">
                  <p className="senior-text-base text-gray-600">
                    Your browser may support installing this app. Look for an install button in your browser's menu.
                  </p>
                </div>
              )}
            </div>

            {/* Benefits */}
            <div className="bg-gradient-to-r from-pink-50 to-rose-50 rounded-xl p-4 mb-6">
              <h4 className="senior-text-base font-semibold text-gray-800 mb-2">Why install?</h4>
              <ul className="space-y-1">
                <li className="senior-text-sm text-gray-600">• Quick access from home screen</li>
                <li className="senior-text-sm text-gray-600">• Works offline</li>
                <li className="senior-text-sm text-gray-600">• Faster loading</li>
                <li className="senior-text-sm text-gray-600">• App-like experience</li>
              </ul>
            </div>

            <Button
              onClick={onClose}
              className="w-full h-12 senior-text-base bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600"
            >
              Got it!
            </Button>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
