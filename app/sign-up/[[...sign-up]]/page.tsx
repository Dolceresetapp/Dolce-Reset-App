import { SignIn, SignUp } from "@clerk/nextjs"
import Link from "next/link"

export default function SignInPage() {
  return (
    <div className="app-container gradient-bg">
      {/* add back button */}
      <br/>
      <Link href="/" className="m-4 text-white h-24 rounded-2xl">Indietro</Link>
      <div className="signin-wrapper">
        <div className="signin-card">
          <div className="signin-header">
            <h1 className="text-5xl font-bold">Dolce Reset</h1>
            <p className="">Registrati per iniziare il tuo percorso di fitness</p>
          </div>
          <SignUp
            appearance={{
              elements: {
                formButtonPrimary: "signin-btn",
                card: "signin-form-card",
                headerTitle: "signin-form-header-title",
                headerSubtitle: "signin-form-header-subtitle",
                formFieldInput: "signin-input",
                formFieldLabel: "signin-label",
                footerActionLink: "signin-footer-link",
                footer: "signin-footer-hidden",
                header: "signin-header-hidden"
              },
            }}
            redirectUrl="/features"
          />
          <br/>
          <center><span className="senior-text-sm">Hai già un account? <Link href="/sign-in" className="text-white/70">Accedi</Link></span></center>
        </div>
      </div>
    </div>
  )
}
