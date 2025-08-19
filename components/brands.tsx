"use client"

import Image from "next/image"

export default function LogoMarquee() {
  // Explicitly list your logos (can be .png or .webp)
  const logos = [
    "/logos/l1.png",
    "/logos/l2.webp",
    "/logos/l3.webp",
    "/logos/l4.webp",
    "/logos/l6.webp",
  ]

  return (
    <div className="w-full overflow-hidden bg-white py-6">
      <div className="flex animate-marquee space-x-12">
        {[...logos, ...logos].map((src, idx) => (
          <Image
            key={idx}
            src={src}
            alt={`Logo ${idx + 1}`}
            width={80}
            height={80}
            className="h-16 w-auto object-contain"
          />
        ))}
      </div>
      <style jsx>{`
        @keyframes marquee {
          0% {
            transform: translateX(0%);
          }
          100% {
            transform: translateX(-50%);
          }
        }
        .animate-marquee {
          display: flex;
          width: max-content;
          animation: marquee 20s linear infinite;
        }
      `}</style>
    </div>
  )
}
