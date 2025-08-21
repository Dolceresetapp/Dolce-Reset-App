// app/sales/page.tsx
"use client";

import { useState } from "react";
import Image from "next/image";
import LogoMarquee from "./brands";

export default function SalesPage() {
  // FAQ state
  const [openIndex, setOpenIndex] = useState<number | null>(null);

  const faqs = [
    {
      q: "Is this method suitable if I'm over 45 years old or older?",
      a: "Yes, this method is specially designed for people over 45, adapting to your body’s natural changes.",
    },
    {
      q: "Should I follow a diet or exercise every day?",
      a: "No strict diets or daily intense exercise required — this program is flexible and sustainable.",
    },
    {
      q: "What if I'm not tech-savvy?",
      a: "Don’t worry! Everything is simple, step-by-step, and easy to follow on mobile.",
    },
    {
      q: "What exactly do I get when I sign up?",
      a: "You’ll get full access to the Sweet program, guides, and exclusive content designed for you.",
    },
    {
      q: "Do you need exercise equipment?",
      a: "Nope! The program works without any equipment — you can start right at home.",
    },
    {
      q: "Is it also suitable if I have hormonal problems or am undergoing therapy?",
      a: "Yes, it’s made to complement your body’s needs and can adapt to your situation.",
    },
    {
      q: "Can I cancel at any time?",
      a: "Absolutely. Cancel anytime with no hidden fees.",
    },
  ];

  // Helper: render images dynamically (handles png & webp)
  const renderImage = (num: number) => {
    const formats = ["png", "webp"];
    return formats.map((ext) => (
      <Image
        key={`${num}-${ext}`}
        src={`/sales/${num}.${ext}`}
        alt={`sales-${num}`}
        width={500}
        height={500}
        className="w-full rounded-xl my-4"
        onError={(e) => {
          // Hide broken images
          (e.target as HTMLImageElement).style.display = "none";
        }}
      />
    ));
  };

  // Reusable CTA
  const CTA = () => (
    <div className="my-6">
      <button className="w-full bg-blue-600 text-white text-2xl font-extralight py-4 shadow-md">
        Click to get started - 3.99/month
        <p className="text-center text-sm mt-2 font-extralight">
        Total annual cost: $47
      </p>
      </button>
     
    </div>
  );

  return (
    <div className="max-w-md mx-auto px-4 py-0">
      {/* --- Top Images --- */}
      {renderImage(1)}
      {renderImage(2)}
      <LogoMarquee />

      {/* CTA */}
      {/* <CTA /> */}
      <h2 className="text-2xl font-bold text-center mt-8 mb-4">ECCO COSA DICE CHI HA PROVATO DOLCE RESET</h2>

        {/* YouTube Videos */}
        <div className="space-y-4">
        <div style={{padding:"177.78% 0 0 0;position:relative;"}}><iframe src="https://player.vimeo.com/video/1111321366?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" frameborder="0" allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media; web-share" referrerpolicy="strict-origin-when-cross-origin" style={{position:"absolute;top:0;left:0;width:100%;height:100%;"}} title="Testimonials 1"></iframe></div>
        <div style={{padding:"177.78% 0 0 0;position:relative;"}}><iframe src="https://player.vimeo.com/video/1111333407?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479" frameborder="0" allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media; web-share" referrerpolicy="strict-origin-when-cross-origin" style={{position:"absolute;top:0;left:0;width:100%;height:100%;"}} title="Testimonials 1"></iframe></div>
        
      </div>

       {renderImage(13)}
      {/* Images */}
      {renderImage(3)}
      {renderImage(4)}
      {renderImage(5)}

      {/* CTA */}
      {/* <CTA /> */}

      {[6, 7, 8, 9, 10, 11, 12, 13].map((n) => renderImage(n))}
      {/* <CTA /> */}

      {/* Purple Section */}
      <div className="bg-[#D6BCFA] px-4 py-4 my-0">
        <div className="max-w-xl mx-auto">
          {[15, 16, 17, 18].map((n) => renderImage(n))}
          {/* <CTA /> */}
        </div>
      </div>

      {/* FAQ Section */}
      <div className="bg-black px-4 py-10">
        <p className="text-center text-sm tracking-wider text-gray-400">
          STILL NOT SURE? HERE YOU GO
        </p>
        <h2 className="text-2xl text-white font-extrabold text-center mb-4">
          HAVE QUESTIONS?
        </h2>
        <p className="text-center text-gray-400 mb-6 text-sm">
          Click on the questions to see the answers to your questions.
          But act quickly before the offer expires!
        </p>

        <div className="space-y-3">
          {faqs.map((faq, i) => (
            <div
              key={i}
              className="bg-[#1f1f2e] rounded-lg overflow-hidden"
            >
              <button
                className="w-full flex justify-between items-center px-4 py-3 text-left text-white font-medium"
                onClick={() => setOpenIndex(openIndex === i ? null : i)}
              >
                <span>🔶 {faq.q}</span>
                <span>{openIndex === i ? "−" : "+"}</span>
              </button>
              {openIndex === i && (
                <div className="px-4 pb-3 text-gray-300 text-sm">
                  {faq.a}
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
