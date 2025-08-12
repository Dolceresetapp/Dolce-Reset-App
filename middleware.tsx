import { clerkMiddleware, createRouteMatcher } from "@clerk/nextjs/server"
import { NextResponse } from "next/server"

const isPublicRoute = createRouteMatcher(["/", "/sign-in(.*)", "/sign-up(.*)", "/api/webhooks(.*)"])

const isOnboardingRoute = createRouteMatcher(["/onboarding"])
const isProtectedRoute = createRouteMatcher([
  "/dashboard(.*)",
  "/profile(.*)",
  "/features(.*)",
  "/ai-doctor(.*)",
  "/ai-chef(.*)",
  "/community(.*)",
  "/premium(.*)",
  "/exercise(.*)",
  "/pricing(.*)",
  "/checkout(.*)",
])

export default clerkMiddleware(async (auth, req) => {
  const { userId } = await auth()
  const url = req.nextUrl.clone()

  // Allow public routes
  if (isPublicRoute(req)) {
    return NextResponse.next()
  }

  // Redirect to sign-in if not authenticated and trying to access ANY protected route
  if (!userId && (isProtectedRoute(req) || isOnboardingRoute(req))) {
    url.pathname = "/sign-in"
    return NextResponse.redirect(url)
  }

  // Handle onboarding route restrictions (only for authenticated users)
  if (isOnboardingRoute(req) && userId) {
    // Check if user has already completed onboarding
    const onboardingCompleted = req.cookies.get("onboarding-completed")?.value
    if (onboardingCompleted === "true") {
      // Already completed onboarding, redirect to dashboard
      url.pathname = "/dashboard"
      return NextResponse.redirect(url)
    }
  }

  // If user is authenticated but trying to access root, redirect based on onboarding status
  if (userId && url.pathname === "/") {
    const onboardingCompleted = req.cookies.get("onboarding-completed")?.value
    if (onboardingCompleted === "true") {
      url.pathname = "/dashboard"
      return NextResponse.redirect(url)
    } else {
      url.pathname = "/onboarding"
      return NextResponse.redirect(url)
    }
  }

  return NextResponse.next()
})

export const config = {
  matcher: [
    // Skip Next.js internals and all static files, unless found in search params
    "/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)",
    // Always run for API routes
    "/(api|trpc)(.*)",
  ],
}
