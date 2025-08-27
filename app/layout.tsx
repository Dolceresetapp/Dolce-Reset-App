import type React from "react"
import type { Metadata } from "next"
import { Inter } from "next/font/google"
import "./globals.css"
import { ClerkProvider } from "@clerk/nextjs"
import Script from "next/script"
import { itIT } from '@clerk/localizations'

const inter = Inter({ subsets: ["latin"] })

export const metadata: Metadata = {
  title: "Dolce Reset - Fitness per la vita",
  description: "Esercizi di fitness per donne adulte",
  manifest: "/manifest.json",
  themeColor: "#ec4899",
  viewport: "width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no",
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <ClerkProvider
      publishableKey={process.env.NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY}
      afterSignInUrl="/features"
      afterSignUpUrl="/features"
      localization={itIT}
    >
      <html lang="fr">
        <head>
          {/* Google Tag Manager */}
          <Script id="gtm-script" strategy="afterInteractive">
            {`
              (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
              new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
              j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
              'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
              })(window,document,'script','dataLayer','GTM-T98ZDPS7');
            `}
          </Script>
        </head>
        <body
          className={`${inter.className} bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen`}
        >
          {/* Google Tag Manager (noscript) */}
          <noscript>
            <iframe
              src="https://www.googletagmanager.com/ns.html?id=GTM-T98ZDPS7"
              height="0"
              width="0"
              style={{ display: "none", visibility: "hidden" }}
            />
          </noscript>

          {children}
          <Script id="clarity-script" strategy="afterInteractive">
          {`
            (function(c,l,a,r,i,t,y){
                c[a]=c[a]||function(){(c[a].q=c[a].q||[]).push(arguments)};
                t=l.createElement(r);t.async=1;t.src="https://www.clarity.ms/tag/"+i;
                y=l.getElementsByTagName(r)[0];y.parentNode.insertBefore(t,y);
            })(window, document, "clarity", "script", "syc8m8tzt1");
          `}
        </Script>
        </body>
      </html>
    </ClerkProvider>
  )
}
