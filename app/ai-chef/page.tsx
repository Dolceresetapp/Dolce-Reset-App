"use client"

import { useState, useRef, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { ArrowLeft, Send, ChefHat, Sparkles, User, Bot } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"
import { useCheckPremium } from "@/components/hooks/check-package"

const preBuiltQuestions = [
  "What's a healthy breakfast for weight loss?",
  "Best post-workout meals for women over 50?",
  "How to meal prep for the week?",
  "Healthy snacks for energy boost?",
  "Anti-inflammatory foods for joint health?",
  "Protein-rich vegetarian meals?",
]

interface Message {
  id: string
  text: string
  isUser: boolean
  timestamp: Date
}

export default function AIChefPage() {
  const router = useRouter()
  const { isPremium } = useCheckPremium() // ✅ premium hook
  const messagesEndRef = useRef<HTMLDivElement>(null)

  const [messages, setMessages] = useState<Message[]>([
    {
      id: "1",
      text: "Hello beautiful! 👋 I'm your AI Nutrition Chef, here to help you create delicious, healthy meals that support your fitness journey.",
      isUser: false,
      timestamp: new Date(),
    },
  ])
  const [inputText, setInputText] = useState("")
  const [isLoading, setIsLoading] = useState(false)

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: "smooth" })
  }

  useEffect(() => {
    scrollToBottom()
  }, [messages])

  const handleSendMessage = async (text: string) => {
    if (!text.trim() || isLoading) return

    const userMessage: Message = {
      id: Date.now().toString(),
      text: text.trim(),
      isUser: true,
      timestamp: new Date(),
    }

    setMessages((prev) => [...prev, userMessage])
    setInputText("")
    setIsLoading(true)

    try {
      const response = await fetch("/api/ai-chef", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ message: text.trim() }),
      })

      const data = await response.json()

      const aiResponse: Message = {
        id: (Date.now() + 1).toString(),
        text: data.response || "I'm sorry, I couldn't process your request right now. Please try again.",
        isUser: false,
        timestamp: new Date(),
      }

      setMessages((prev) => [...prev, aiResponse])
    } catch (error) {
      console.error("Error calling AI Chef:", error)
      const errorResponse: Message = {
        id: (Date.now() + 1).toString(),
        text: "I'm having trouble connecting right now. Please try again in a moment! 🍳",
        isUser: false,
        timestamp: new Date(),
      }
      setMessages((prev) => [...prev, errorResponse])
    } finally {
      setIsLoading(false)
    }
  }

  const handleQuestionClick = (question: string) => {
    handleSendMessage(question)
  }

  // ✅ Premium check
  if (!isPremium) {
    return (
      <div className="flex flex-col items-center justify-center min-h-screen text-center p-6 bg-gradient-to-br from-green-50 to-emerald-50">
        <ChefHat className="w-12 h-12 text-green-500 mb-4" />
        <h2 className="text-xl font-bold text-gray-800 mb-2">Premium Required</h2>
        <p className="text-gray-600 mb-6">
          Access to AI Chef is for premium members only. Upgrade to unlock personalized nutrition coaching 🍎✨
        </p>
        <Button
          onClick={() => router.push("/pricing")}
          className="bg-gradient-to-r from-green-500 to-emerald-500 text-white rounded-xl shadow-md px-6 py-3"
        >
          Upgrade to Premium
        </Button>
      </div>
    )
  }

  return (
    <div className="app-container bg-gradient-to-br from-green-50 via-emerald-50 to-teal-50 min-h-screen pb-20">
      {/* Header */}
      <div className="sticky top-0 z-40 bg-white/95 backdrop-blur-sm border-b border-green-100 rounded-b-3xl shadow-sm">
        <div className="flex items-center justify-between p-4">
          <Button
            variant="ghost"
            size="icon"
            onClick={() => router.back()}
            className="h-12 w-12 rounded-2xl hover:bg-green-100"
          >
            <ArrowLeft className="h-6 w-6 text-gray-600" />
          </Button>
          <div className="text-center">
            <h1 className="senior-text-lg font-bold text-gray-800 flex items-center justify-center">
              <ChefHat className="w-5 h-5 mr-2 text-green-500" />
              AI Chef
            </h1>
            <p className="senior-text-sm text-gray-600">Your nutrition expert</p>
          </div>
          <div className="w-12" />
        </div>
      </div>

      {/* Chat Messages */}
      <div className="flex-1 p-4 pb-32 space-y-6">
        {messages.map((message) => (
          <div key={message.id} className={`flex ${message.isUser ? "justify-end" : "justify-start"} animate-fade-in`}>
            <div
              className={`flex items-start space-x-3 max-w-[85%] ${message.isUser ? "flex-row-reverse space-x-reverse" : ""}`}
            >
              {/* Avatar */}
              <div
                className={`w-10 h-10 rounded-full flex items-center justify-center flex-shrink-0 ${
                  message.isUser
                    ? "bg-gradient-to-br from-pink-400 to-rose-400"
                    : "bg-gradient-to-br from-green-400 to-emerald-400"
                }`}
              >
                {message.isUser ? <User className="w-5 h-5 text-white" /> : <Bot className="w-5 h-5 text-white" />}
              </div>

              {/* Message Bubble */}
              <Card
                className={`border-0 shadow-lg rounded-3xl ${
                  message.isUser
                    ? "bg-gradient-to-br from-pink-500 to-rose-500 text-white"
                    : "bg-white/90 text-gray-800 border border-green-100"
                }`}
              >
                <CardContent className="p-4">
                  <p className="senior-text-base leading-relaxed whitespace-pre-wrap">{message.text}</p>
                  <p className={`senior-text-sm mt-2 ${message.isUser ? "text-white/70" : "text-gray-500"}`}>
                    {message.timestamp.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })}
                  </p>
                </CardContent>
              </Card>
            </div>
          </div>
        ))}

        {isLoading && (
          <div className="flex justify-start animate-fade-in">
            <div className="flex items-start space-x-3 max-w-[85%]">
              <div className="w-10 h-10 rounded-full bg-gradient-to-br from-green-400 to-emerald-400 flex items-center justify-center">
                <Bot className="w-5 h-5 text-white" />
              </div>
              <Card className="bg-white/90 border border-green-100 shadow-lg rounded-3xl">
                <CardContent className="p-4">
                  <div className="flex items-center space-x-2">
                    <div className="w-2 h-2 bg-green-500 rounded-full animate-bounce"></div>
                    <div
                      className="w-2 h-2 bg-green-500 rounded-full animate-bounce"
                      style={{ animationDelay: "0.1s" }}
                    ></div>
                    <div
                      className="w-2 h-2 bg-green-500 rounded-full animate-bounce"
                      style={{ animationDelay: "0.2s" }}
                    ></div>
                    <span className="senior-text-sm text-gray-600 ml-2">Chef is cooking up an answer...</span>
                  </div>
                </CardContent>
              </Card>
            </div>
          </div>
        )}

        {/* Pre-built Questions */}
        {messages.length === 1 && (
          <div className="space-y-3 animate-slide-up">
            <div className="text-center mb-6">
              <h3 className="senior-text-lg font-semibold text-gray-700 mb-2">
                <Sparkles className="w-5 h-5 inline mr-2 text-green-500" />
                Popular Nutrition Questions
              </h3>
              <p className="senior-text-base text-gray-600">Tap any question to get started!</p>
            </div>

            <div className="grid gap-3">
              {preBuiltQuestions.map((question, index) => (
                <Card
                  key={index}
                  className="card-hover cursor-pointer bg-white/80 border-green-200 hover:border-green-300 hover:bg-green-50 shadow-md rounded-2xl animate-slide-up"
                  style={{ animationDelay: `${index * 0.1}s` }}
                  onClick={() => handleQuestionClick(question)}
                >
                  <CardContent className="p-4">
                    <p className="senior-text-base text-gray-700 font-medium">{question}</p>
                  </CardContent>
                </Card>
              ))}
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* Input Area */}
      <div className="fixed bottom-20 left-0 right-0 p-4 bg-white/95 backdrop-blur-sm border-t border-green-100 shadow-lg">
        <div className="max-w-md mx-auto">
          <div className="flex space-x-3 bg-white rounded-3xl p-2 shadow-lg border border-green-200">
            <Input
              value={inputText}
              onChange={(e) => setInputText(e.target.value)}
              placeholder="Ask about nutrition, recipes, meal plans..."
              className="flex-1 border-0 bg-transparent senior-text-base placeholder:text-gray-500 focus-visible:ring-0"
              onKeyPress={(e) => e.key === "Enter" && handleSendMessage(inputText)}
              disabled={isLoading}
            />
            <Button
              onClick={() => handleSendMessage(inputText)}
              disabled={!inputText.trim() || isLoading}
              className="h-10 w-10 rounded-2xl bg-gradient-to-r from-green-500 to-emerald-500 hover:from-green-600 hover:to-emerald-600 shadow-md"
            >
              <Send className="w-4 h-4" />
            </Button>
          </div>
        </div>
      </div>

      <BottomNavigation />
    </div>
  )
}
