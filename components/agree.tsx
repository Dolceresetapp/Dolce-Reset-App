"use client"

import Link from "next/link"

export default function ConsentNotice() {
  return (
    <p className="text-xs text-center text-gray-500 mt-4">
      By continuing, you agree to our{" "}
      <Link href="/terms" className="underline hover:text-primary">
        Terms
      </Link>
      ,{" "}
      <Link href="/privacy" className="underline hover:text-primary">
        Privacy Policy
      </Link>{" "}
      and{" "}
      <Link href="/gdpr" className="underline hover:text-primary">
        GDPR Compliance
      </Link>
      .
    </p>
  )
}
