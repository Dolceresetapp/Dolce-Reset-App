import { clerkMiddleware, createRouteMatcher } from "@clerk/nextjs/server"
import { NextResponse } from "next/server"

const isPublicRoute = createRouteMatcher([
  "/",
  "/sign-in(.*)",
  "/sign-up(.*)",
  "/api/webhooks(.*)",
  "/onboarding(.*)", // onboarding is technically public
])

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
])

export default clerkMiddleware(async (auth, req) => {
  const { userId } = await auth()
  const url = req.nextUrl.clone()

  // Allow public routes for everyone
  if (isPublicRoute(req)) {
    // 🚨 Block /onboarding if user is logged in
    if (userId && url.pathname.startsWith("/onboarding")) {
      url.pathname = "/dashboard" // or send them to /dashboard if that’s better
      return NextResponse.redirect(url)
    }
    return NextResponse.next()
  }

  // Block all protected routes if not authenticated
  // if (!userId && isProtectedRoute(req)) {
  //   url.pathname = "/sign-in"
  //   return NextResponse.redirect(url)
  // }

  // For authenticated users accessing protected routes
  // if (userId && isProtectedRoute(req)) {
  //   const onboardingCompleted = req.cookies.get("onboarding-completed")?.value

  //   if (onboardingCompleted !== "true") {
  //     // Instead of redirecting to /onboarding, redirect to homepage "/"
  //     url.pathname = "/dashboard"
  //     return NextResponse.redirect(url)
  //   }
  // }

  return NextResponse.next()
})

export const config = {
  matcher: [
    "/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)",
    "/(api|trpc)(.*)",
  ],
}
