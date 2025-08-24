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

  return (
    <div className="fixed inset-0 z-60 animate-fade-in">
      {/* Backdrop */}
      <div className="absolute inset-0 bg-black/70 backdrop-blur-sm" onClick={onClose} />

      {/* Modal */}
      <div className="absolute inset-0 flex items-center justify-center p-4">
        <Card className="w-full max-w-sm bg-white border-0 shadow-2xl animate-slide-up max-h-[90vh] flex flex-col">
          
          {/* Header */}
          <div className="p-6 flex-shrink-0 flex items-center justify-between">
            <div className="flex items-center">
              <div className="w-12 h-12 bg-gradient-to-br from-pink-500 to-rose-500 rounded-xl flex items-center justify-center mr-3">
                <Smartphone className="w-6 h-6 text-white" />
              </div>
              <div>
                <h3 className="senior-text-md font-bold text-gray-800">Install Dolce Reset</h3>
                <p className="senior-text-xs text-gray-600">Aggiungi allo schermo d'ingresso</p>
              </div>
            </div>
            <Button variant="ghost" size="icon" onClick={onClose} className="h-8 w-8">
              <X className="h-4 w-4" />
            </Button>
          </div>

          {/* Scrollable Content */}
          <CardContent className="px-6 flex-1 overflow-y-auto space-y-6">
            {/* Android Instructions */}
            <div>
              <h4 className="senior-text-base font-semibold text-gray-800 mb-2">Android 📱</h4>
              <div className="flex items-start space-x-3 mb-3">
                <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                  <span className="text-blue-600 font-bold senior-text-sm">1</span>
                </div>
                <div>
                  <p className="senior-text-base font-semibold text-gray-800">Apri il menu del browser</p>
                  <p className="senior-text-sm text-gray-600 mt-1">Premi il tasto tre punti (⋮) nel tuo browser</p>
                </div>
              </div>
              <div className="flex items-start space-x-3">
                <div className="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                  <span className="text-green-600 font-bold senior-text-sm">2</span>
                </div>
                <div>
                  <p className="senior-text-base font-semibold text-gray-800">Aggiungi allo schermo d'ingresso</p>
                  <div className="flex items-center mt-2">
                    <Download className="w-5 h-5 text-green-500 mr-2" />
                    <span className="senior-text-sm text-gray-600">Cerca "Install" o "Aggiungi allo schermo d'ingresso"</span>
                  </div>
                </div>
              </div>
            </div>

            {/* iOS Instructions */}
            <div>
              <h4 className="senior-text-base font-semibold text-gray-800 mb-2">iPhone / iPad 🍏</h4>
              <div className="flex items-start space-x-3 mb-3">
                <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                  <span className="text-blue-600 font-bold senior-text-sm">1</span>
                </div>
                <div>
                  <p className="senior-text-base font-semibold text-gray-800">Premi il tasto Share</p>
                  <div className="flex items-center mt-2">
                    <Share className="w-5 h-5 text-blue-500 mr-2" />
                    <span className="senior-text-sm text-gray-600">Allo schermo d'ingresso</span>
                  </div>
                </div>
              </div>
              <div className="flex items-start space-x-3">
                <div className="w-8 h-8 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0 mt-1">
                  <span className="text-green-600 font-bold senior-text-sm">2</span>
                </div>
                <div>
                  <p className="senior-text-base font-semibold text-gray-800">Aggiungi allo schermo d'ingresso</p>
                  <div className="flex items-center mt-2">
                    <Plus className="w-5 h-5 text-green-500 mr-2" />
                    <span className="senior-text-sm text-gray-600">Scrolla verso il basso e premi questa opzione</span>
                  </div>
                </div>
              </div>
            </div>

            {/* Benefits */}
            <div className="bg-gradient-to-r from-pink-50 to-rose-50 rounded-xl p-4">
              <h4 className="senior-text-base font-semibold text-gray-800 mb-2">Perché installare?</h4>
              <ul className="space-y-1">
                <li className="senior-text-sm text-gray-600">• Accesso rapido dallo schermo d'ingresso</li>
                <li className="senior-text-sm text-gray-600">• Funziona offline</li>
                <li className="senior-text-sm text-gray-600">• Caricamento più veloce</li>
                <li className="senior-text-sm text-gray-600">• Esperienza app-like</li>
              </ul>
            </div>
          </CardContent>

          {/* Footer Button */}
          <div className="px-6 pb-6 flex-shrink-0">
            <Button
              onClick={onClose}
              className="w-full h-12 senior-text-base bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600"
            >
              Ok
            </Button>
          </div>
        </Card>
      </div>
    </div>
  )
}
