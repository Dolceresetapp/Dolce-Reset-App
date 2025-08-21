"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"
import { useUser, useClerk } from "@clerk/nextjs"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { ArrowLeft, User, Crown, Settings, Heart, TrendingUp, Calendar, LogOut, Edit, Star } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"

export default function ProfilePage() {
  const router = useRouter()
  const { user } = useUser()
  const { signOut, openUserProfile } = useClerk()
  const [isPremium] = useState(false) // This should come from your user data
  const [stats] = useState({
    workoutsCompleted: 12,
    streakDays: 5,
    totalMinutes: 180,
    favoriteExercises: 8,
  })

  const handleSignOut = async () => {
    await signOut()
    router.push("/")
  }

  return (
    <div className="app-container bg-gradient-to-br from-rose-50 to-pink-50 min-h-screen pb-20">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-pink-100">
        <div className="flex items-center justify-between p-4">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => router.back()}
            className="h-12 w-12 rounded-2xl hover:bg-pink-100"
          >
            <ArrowLeft className="h-6 w-6 text-gray-600" />
          </Button>
          <div className="text-center">
            <h1 className="senior-text-lg font-bold text-gray-800">Profile</h1>
            <p className="senior-text-sm text-gray-600">Your wellness journey</p>
          </div>
          <Button
            variant="ghost"
            size="icon"
            onClick={openUserProfile}
            className="h-12 w-12 rounded-2xl hover:bg-pink-100"
          >
            <Settings className="h-6 w-6 text-gray-600" />
          </Button>
        </div>
      </div>

      {/* Content */}
      <div className="p-6">
        {/* Profile Header */}
        <div className="mb-6 bg-gradient-to-r from-pink-500 to-rose-500 rounded-3xl text-white border-0 shadow-xl animate-fade-in">
          <CardContent className="p-6">
            <div className="flex items-center space-x-4">
              <div className="w-20 h-20 bg-white/20 rounded-3xl flex items-center justify-center">
                {user?.imageUrl ? (
                  <img
                    src={user.imageUrl || "/placeholder.svg"}
                    alt="Profile"
                    className="w-full h-full rounded-3xl object-cover"
                  />
                ) : (
                  <User className="w-10 h-10 text-white" />
                )}
              </div>
              <div className="flex-1">
                <h2 className="senior-text-xl font-bold mb-1">
                  {user?.firstName || "Beautiful"} {user?.lastName || ""}
                </h2>
                <p className="senior-text-base opacity-90 mb-2">{user?.emailAddresses[0]?.emailAddress}</p>
                <div className="flex items-center space-x-2">
                  {isPremium ? (
                    <Badge className="bg-white/20 text-white border-white/30 senior-text-sm rounded-2xl">
                      <Crown className="w-4 h-4 mr-1" />
                      Premium Member
                    </Badge>
                  ) : (
                    <Badge className="bg-white/20 text-white border-white/30 senior-text-sm rounded-2xl">
                      <Heart className="w-4 h-4 mr-1" />
                      Free Member
                    </Badge>
                  )}
                </div>
              </div>
            </div>
          </CardContent>
        </div>

        {/* Profile Actions */}
        <div className="space-y-4 animate-slide-up" style={{ animationDelay: "0.5s" }}>
          <Card className="bg-white/80 border-pink-200 rounded-3xl">
            <CardContent className="p-4">
              <Button
                variant="ghost"
                className="w-full justify-start h-auto p-4 hover:bg-pink-50 rounded-2xl"
                onClick={openUserProfile}
              >
                <Edit className="w-5 h-5 mr-4 text-pink-500" />
                <div className="text-left">
                  <p className="senior-text-base font-semibold text-gray-800">Edit Profile</p>
                  <p className="senior-text-sm text-gray-600">Update your personal information</p>
                </div>
              </Button>
            </CardContent>
          </Card>

          <Card className="bg-white/80 border-pink-200 rounded-3xl">
            <CardContent className="p-4">
              <Button
                variant="ghost"
                className="w-full justify-start h-auto p-4 hover:bg-red-50 rounded-2xl"
                onClick={handleSignOut}
              >
                <LogOut className="w-5 h-5 mr-4 text-red-500" />
                <div className="text-left">
                  <p className="senior-text-base font-semibold text-gray-800">Sign Out</p>
                  <p className="senior-text-sm text-gray-600">Sign out of your account</p>
                </div>
              </Button>
            </CardContent>
          </Card>
        </div>
      </div>

      <BottomNavigation />
    </div>
  )
}
