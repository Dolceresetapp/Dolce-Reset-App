// app/sales/page.tsx
"use client";

import { useState } from "react";
import Image from "next/image";
import LogoMarquee from "./brands";
import { Button } from "./ui/button";
import { PricingDialog } from "./pricing-dialog";
import AutoSlider from "./testimonials";

export default function SalesPage() {
  // FAQ state
  const [openIndex, setOpenIndex] = useState<number | null>(null);
  const [showPricingDialog, setShowPricingDialog] = useState(false)
  const faqs = [
    {
      q: "✨ Non Servono Pillole Né Integratori",
      a: "Le Promesse Vanno Bene Finché Non Ti Accorgi Che I Chili Restano Sempre Lì. Con Il Nostro Metodo Basato Su Movimento, Ricette Semplici E Supporto, Dimagrire Diventa Finalmente Reale e Scientificamente Garantito.",
    },
    {
      q: "✨ Troppo Giovane O Troppo Grande Per Questa App?",
      a: "A 30 Anni Vuoi Tornare A Piacerti Nello Specchio. A 55 Vuoi Sentirti Più Leggera E Sicura. Questa App È Pensata Proprio Per Donne Come Te, Senza Età.",
    },
    {
      q: "✨ Perché Non Funzionano Le Altre Soluzioni?",
      a: "Perché Sono Trucchi Temporanei. Integratori, Digiuni O Mode Ti Fanno Perdere Solo Acqua, Non Grasso. Il Nostro Metodo È Scientifico: Movimento Dolce, Cibo Vero, E Consigli Personalizzati.",
    },
    {
      q: "✨ E Se Non Riesco A Restare Costante?",
      a: "Non Sei Sola: Ti Guidiamo Giorno Per Giorno Con Allenamenti Facili, Ricette Automatiche E Una Community Che Ti Motiva. Così Restare Costante Diventa Naturale.",
    },
    {
      q: "✨ Ma Io Non Ho Tempo",
      a: "Ti Bastano 15 Minuti Al Giorno, Da Casa, Senza Attrezzi. E Inizi A Vedere I Vestiti Che Ti Stanno Meglio Già Dopo Poche Settimane.",
    },
    {
      q: "❓ Io Ho Già Provato Mille Soluzioni... Funziona Davvero?",
      a: "✅ Perché Non Ti Lascia Da Sola: Hai Allenamenti Guidati, Ricette Personalizzate E Una Community Che Ti Sostiene.",
    },
    {
      q: "❓ Ho Poco Tempo Al Giorno, Ce La Faccio?",
      a: "✅ Bastano 15 Minuti Al Giorno Da Casa, Senza Attrezzi Né Palestra.",
    },
    {
      q: "❓ E Se Non Riesco A Restare Costante?",
      a: "✅ La Community Ti Motiva, I Dottori Ti Seguono, E L’App Ti Ricorda Ogni Giorno Cosa Fare.",
    },
    {
      q: "❓ Serve Già Essere Allenata?",
      a: "✅ No, È Per Principianti: Parti Da Zero E Ti Guida Passo Dopo Passo.",
    },
    {
      q: "❓ Io Non So Cucinare Ricette Fit… Come Faccio?",
      a: "✅ L’AI Ti Prepara Ricette Facili, Veloci E Con Ingredienti Che Trovi Al Supermercato.",
    },
    {
      q: "❓ Perdo Peso Solo Con La Dieta, Perché Allenarmi?",
      a: "✅ Perché Senza Movimento Torna Tutto. Qui Combini Allenamenti Brevi E Cibo Sano, Così I Risultati Restano.",
    },
  ];

  const handleStartTrial = () => {
    setShowPricingDialog(true)
  }


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
        Click to get started - 3,90/month
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
      {/* {renderImage(2)} */}
      <LogoMarquee />

      {/* CTA */}
      {/* <CTA /> */}
      {/* <h2 className="text-2xl font-bold text-center mt-8 mb-4">ECCO COSA DICE CHI HA PROVATO DOLCE RESET</h2> */}

      {/* Vimeo Videos */}
      <div style={{ width: "100%", height: "500px" }}>
        <iframe
          src="https://player.vimeo.com/video/1116883226?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479"
          style={{
            width: "100%",
            height: "100%",
            border: "none",
          }}
          allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media; web-share"
        />
      </div>
      {/* <br />
      <div style={{ width: "100%", height: "500px" }}>
        <iframe
          src="https://player.vimeo.com/video/1111321366?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479"
          style={{
            width: "100%",
            height: "100%",
            border: "none",
          }}
          allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media; web-share"
        />
      </div> */}

      <br />
      <Button
        onClick={handleStartTrial}
        className="w-full h-18 my-5 text-xl bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-light rounded-2xl shadow-xl transition-all duration-300 hover:scale-105"
      >
        <div className="flex flex-col items-center">
          <span className="text-base">Ottieni il mio piano personalizzato</span>
          <span className="text-xs">Premi qui per iniziare</span>
        </div>

      </Button>
      <br />



      {renderImage(2)}
      {/* Images */}
      {renderImage(4)}

      {/* <Button
        onClick={handleStartTrial}
        className="w-full h-18 text-xl bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-light rounded-2xl shadow-xl transition-all duration-300 hover:scale-105"
      >
        <div className="flex flex-col items-center">
          <span className="text-base">Ottieni il mio piano personalizzato</span>
          <span className="text-xs">Premi qui per iniziare</span>
        </div>

      </Button>
      <br /> */}

      <AutoSlider />
      {/* {renderImage(4)}
      {renderImage(5)} */}

      {/* CTA */}
      {/* <CTA /> */}
      <Button
        onClick={handleStartTrial}
        className="w-full h-18 text-xl bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-light rounded-2xl shadow-xl transition-all duration-300 hover:scale-105"
      >
        <div className="flex flex-col items-center">
          <span className="text-base">Ottieni il mio piano personalizzato</span>
          <span className="text-xs">Premi qui per iniziare</span>
        </div>

      </Button>
      <br />

      {[6, 7, 8, 9, 10, 11].map((n) => renderImage(n))}

      <Button
        onClick={handleStartTrial}
        className="w-full h-18 text-xl bg-gradient-to-r from-pink-500 to-rose-500 hover:from-pink-600 hover:to-rose-600 text-white font-light rounded-2xl shadow-xl transition-all duration-300 hover:scale-105"
      >
        <div className="flex flex-col items-center">
          <span className="text-base">Ottieni il mio piano personalizzato</span>
          <span className="text-xs">Premi qui per iniziare</span>
        </div>

      </Button>
      <br />
      <br />
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
          ANCORA INCERTO? ECCO QUI
        </p>
        <h2 className="text-2xl text-white font-extrabold text-center mb-4">
          HAI DOMANDE?
        </h2>
        <p className="text-center text-gray-400 mb-6 text-sm">
          Clicca sulle domande per vedere le risposte. Ma agisci in fretta prima che l'offerta scada!
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
      {/* Pricing Dialog */}
      <PricingDialog open={showPricingDialog} onOpenChange={setShowPricingDialog} />
    </div>
  );
}
