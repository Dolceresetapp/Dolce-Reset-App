"use client"

import { useState, useEffect } from "react"
import { motion, AnimatePresence } from "framer-motion"
import { Star } from "lucide-react"
import Image from "next/image"

const testimonials = [
  {
    stars: 5,
    text: "Ero convinta fosse la solita app che promette e non mantiene… invece mi sono dovuta ricredere. Allenamenti brevi, piano alimentare semplice e un supporto che ti risponde davvero. Dopo 2 settimane già vedevo la pancia sgonfiarsi.",
    author: "Chiara Lombardi, Verona (34 anni)",
    image: "/testimonials/t1.png",
  },
  {
    stars: 5,
    text: "Non sono mai riuscita a seguire diete o programmi complicati. Qui invece è tutto pratico: esercizi rapidi, ricette veloci e la chat di supporto che mi incoraggia. È la prima volta che non mollo dopo la prima settimana.",
    author: "Elena Ferraro, Bari (59 anni)",
    image: "/testimonials/t2.png",
  },
  {
    stars: 5,
    text: "All’inizio avevo paura fosse tempo perso come le altre volte… e invece finalmente qualcosa che funziona davvero! Non devo pensare a nulla: mi dicono cosa mangiare e quali mini esercizi fare. Sto già perdendo i primi chili.",
    author: "Roberta Colombo, Genova (41 anni)",
    image: "/testimonials/t3.png",
  },
  {
    stars: 5,
    text: "Non ho tempo né voglia di spaccarmi in palestra. Con questa app faccio movimento in pochi minuti, seguo i pasti facili suggeriti, e quando ho un dubbio scrivo al supporto. Mi sento seguita, non sola.",
    author: "Daniela Romano, Palermo (36 anni)",
    image: "/testimonials/t4.png",
  },
  {
    stars: 5,
    text: "Ero scettica, perché a 57 anni pensavo fosse tardi per rimettermi in forma. Invece con i consigli sull’alimentazione e i piccoli allenamenti guidati mi sento più energica ogni giorno. Non serve forza di volontà infinita, è tutto già pronto.",
    author: "Patrizia Greco, Padova (52 anni)",
    image: "/testimonials/t5.png",
  },
  {
    stars: 5,
    text: "La mia paura era di non riuscire a seguirlo per pigrizia… invece bastano pochi minuti al giorno. Tra ricette facili e mini workout, è diventata la mia nuova routine senza stress.",
    author: "Francesca Moretti, Torino (44 anni)",
    image: "/testimonials/t6.png",
  },
]

export default function TestimonialSlider() {
  const [index, setIndex] = useState(0)

  // Auto slide every 4s
  useEffect(() => {
    const interval = setInterval(() => {
      setIndex((prev) => (prev + 1) % testimonials.length)
    }, 4000)
    return () => clearInterval(interval)
  }, [])

  const nextSlide = () => setIndex((prev) => (prev + 1) % testimonials.length)
  const prevSlide = () => setIndex((prev) => (prev - 1 + testimonials.length) % testimonials.length)

  return (
    <div className="w-full max-w-3xl mx-auto px-4 py-8 overflow-hidden">
      <div className="bg-white rounded-2xl shadow-lg p-6">
        <AnimatePresence mode="wait">
          <motion.div
            key={index}
            drag="x"
            dragConstraints={{ left: 0, right: 0 }}
            onDragEnd={(e, { offset, velocity }) => {
              if (offset.x < -100 || velocity.x < -500) {
                nextSlide()
              } else if (offset.x > 100 || velocity.x > 500) {
                prevSlide()
              }
            }}
            initial={{ opacity: 0, x: 100 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -100 }}
            transition={{ duration: 0.4 }}
            className="cursor-grab active:cursor-grabbing"
          >
            {/* Stars */}
            <div className="flex gap-1 mb-2 text-yellow-400">
              {[...Array(testimonials[index].stars)].map((_, i) => (
                <Star key={i} size={18} fill="currentColor" />
              ))}
            </div>

            {/* Testimonial text */}
            <p className="text-gray-700 italic mb-4">“{testimonials[index].text}”</p>

            {/* Author + Image */}
            <div className="flex items-center gap-3">
              <Image
                src={testimonials[index].image}
                alt={testimonials[index].author}
                width={50}
                height={50}
                className="rounded-full object-cover"
              />
              <p className="text-gray-900 font-semibold">{testimonials[index].author}</p>
            </div>
          </motion.div>
        </AnimatePresence>
      </div>
    </div>
  )
}
