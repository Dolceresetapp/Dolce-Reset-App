import type React from "react"
import type { Metadata } from "next"
import { Inter } from "next/font/google"
import "./globals.css"
import { ClerkProvider } from "@clerk/nextjs"
import Script from "next/script"
import Clarity from '@microsoft/clarity';

const inter = Inter({ subsets: ["latin"] })

const projectId = "syc8m8tzt1"

Clarity.init(projectId);

export const metadata: Metadata = {
  title: "Dolice Reset - Fitness for Life",
  description: "Gentle fitness exercises designed specifically for senior women",
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
    >
      <html lang="en">
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
        </body>
      </html>
    </ClerkProvider>
  )
}
