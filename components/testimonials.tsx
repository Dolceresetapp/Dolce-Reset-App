"use client"

import { useEffect, useState } from "react"
import Image from "next/image"

const images = ["/results/r1.png", "/results/r2.png", "/results/r3.png", "/results/r4.png"]

export default function AutoSlider() {
  const [currentIndex, setCurrentIndex] = useState(0)

  useEffect(() => {
    const interval = setInterval(() => {
      setCurrentIndex((prev) => (prev + 1) % images.length)
    }, 3000) // change every 3s
    return () => clearInterval(interval)
  }, [])

  return (
    <div className="w-full flex justify-center items-center p-6">
      <div className="relative w-full h-[400px]">
        <Image
          src={images[currentIndex]}
          alt="Slider Image"
          width={500}
          height={500}
          className="rounded-2xl object-contain transition-all duration-700"
        />
      </div>
    </div>
  )
}
