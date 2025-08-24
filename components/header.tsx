"use client"
import React, { useState } from 'react'
import { Button } from './ui/button'
import { Menu } from 'lucide-react'
import { MobileMenu } from './mobile-menu'

const header = () => {
    const [menuOpen, setMenuOpen] = useState(false)
    
  return (
    <>
    <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-pink-100">
    <div className="flex items-center justify-between p-4">
      <div>
        <h1 className="text-md font-bold text-gray-800">Dolce Reset</h1>
        <p className="text-xs text-gray-600">Pronto per il tuo percorso di benessere?</p>
      </div>
      <Button
        variant="ghost"
        size="icon"
        onClick={() => setMenuOpen(true)}
        className="h-12 w-12 rounded-2xl bg-pink-200 hover:bg-pink-100"
      >
        <Menu className="h-6 w-6 text-pink-600" />
      </Button>
    </div>
    
  </div>
  <MobileMenu open={menuOpen} onClose={() => setMenuOpen(false)} />
    </>
  )
}

export default header