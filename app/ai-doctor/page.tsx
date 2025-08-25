"use client"

import { useState, useRef, useEffect } from "react"
import { useRouter } from "next/navigation"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { ArrowLeft, Send, User, Bot } from "lucide-react"
import { BottomNavigation } from "@/components/bottom-navigation"
import Image from "next/image"
import Header from "@/components/header"

const preBuiltQuestions = [
  "Come posso perdere peso velocemente?",
  "Ho dormito male, cosa posso fare?",
  "Posso migliorare la digestione?",
  "Alimenti consigliati per più energia",
  "Come posso ridurre i dolori articolari?",
  "Consigli per la menopausa",
]


interface Message {
  id: string
  text: string
  isUser: boolean
  timestamp: Date
}

export default function AIDoctorPage() {
  const router = useRouter()
  const messagesEndRef = useRef<HTMLDivElement>(null)
  const [messages, setMessages] = useState<Message[]>([])
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
      const response = await fetch("/api/ai-doctor", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ message: text.trim() }),
      })

      const data = await response.json()

      const aiResponse: Message = {
        id: (Date.now() + 1).toString(),
        text: data.response || "Mi dispiace, non sono riuscito a processare la tua richiesta. Riprova.",
        isUser: false,
        timestamp: new Date(),
      }

      setMessages((prev) => [...prev, aiResponse])
    } catch (error) {
      console.error("Error calling AI Doctor:", error)
      const errorResponse: Message = {
        id: (Date.now() + 1).toString(),
        text: "Sto avendo difficoltà a connettermi. Riprova in un momento! 🩺",
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

  return (
    <div className="app-container bg-gradient-to-br from-purple-50 via-pink-50 to-rose-50 min-h-screen pb-20">
    <Header/>

      {/* Doctor Image Card */}
      <div className="p-0">
        <div className="">
          <div className="p-4 text-center">
            <div className="w-full h-[200px] mx-auto mb-4 rounded-2xl overflow-hidden">
              <Image
                src="/custom/doc.png"
                alt="AI Doctor"
                width={96}
                height={96}
                className="w-full h-full object-cover"
              />
            </div>
            <h2 className="text-2xl text-pink-500 font-bold mb-2">Parla con la Doctor</h2>
          </div>
        </div>
      </div>

      {/* Chat Messages */}
      <div className="grid grid-col-2 p-4 pb-32">
      
      {messages.length === 0 && (
        <div className="grid grid-cols-2 gap-4 text-center">
          {preBuiltQuestions.map((question, index) => (
            <div
              key={index}
              onClick={() => handleQuestionClick(question)}
              className="w-full h-auto p-2 bg-[#ae47ff] text-center font-medium text-xs text-white rounded-2xl shadow-lg transition-all duration-300 hover:scale-105 justify-start"
              style={{ animationDelay: `${index * 0.1}s` }}
            >
              {question}
            </div>
          ))}
        </div>
      )}



        {messages.map((message) => (
          <div key={message.id} className={`flex ${message.isUser ? "justify-end" : "justify-start"} animate-fade-in`}>
            <div
              className={`flex items-start space-x-3 max-w-[85%] ${message.isUser ? "flex-row-reverse space-x-reverse" : ""}`}
            >
              <div
                className={`w-10 h-10 rounded-full flex items-center justify-center flex-shrink-0 overflow-hidden ${
                  message.isUser
                    ? "bg-gradient-to-br from-pink-400 to-rose-400"
                    : "bg-gradient-to-br from-purple-400 to-pink-400"
                }`}
              >
                {message.isUser ? (
                  <User className="w-5 h-5 text-white" />
                ) : (
                  <Image
                    src="/custom/doc.png"
                    alt="AI Doctor"
                    width={40}
                    height={40}
                    className="w-full h-full object-cover"
                  />
                )}
              </div>


              <div
                className={`border-0 shadow-lg rounded-3xl ${
                  message.isUser
                    ? "bg-gradient-to-br from-pink-500 to-rose-500 text-white"
                    : "bg-white/90 text-gray-800 border border-purple-100"
                }`}
              >
                <div className="p-4">
                  <p className="text-sm leading-relaxed whitespace-pre-wrap">{message.text}</p>
                  <p className={`text-xs mt-2 ${message.isUser ? "text-white/70" : "text-gray-500"}`}>
                    {message.timestamp.toLocaleTimeString([], { hour: "2-digit", minute: "2-digit" })}
                  </p>
                </div>
              </div>
            </div>
          </div>
        ))}

        {isLoading && (
          <div className="flex justify-start animate-fade-in">
            <div className="flex items-start space-x-3 max-w-[85%]">
              <div className="w-10 h-10 rounded-full bg-gradient-to-br from-purple-400 to-pink-400 flex items-center justify-center">
                <Bot className="w-5 h-5 text-white" />
              </div>
              <div className="bg-white/90 border border-purple-100 shadow-lg rounded-3xl">
                <div className="p-4">
                  <div className="flex items-center space-x-2">
                    <div className="w-2 h-2 bg-purple-500 rounded-full animate-bounce"></div>
                    <div
                      className="w-2 h-2 bg-purple-500 rounded-full animate-bounce"
                      style={{ animationDelay: "0.1s" }}
                    ></div>
                    <div
                      className="w-2 h-2 bg-purple-500 rounded-full animate-bounce"
                      style={{ animationDelay: "0.2s" }}
                    ></div>
                    <span className="text-sm text-gray-600 ml-2"></span>
                  </div>
                </div>
              </div>
            </div>
          </div>
        )}

        <div ref={messagesEndRef} />
      </div>

      {/* Input Area */}
      <div className="fixed bottom-22 left-0 right-0 p-4 bg-white/95 backdrop-blur-sm border-t border-purple-100 shadow-lg">
        <div className="max-w-md mx-auto">
          <div className="flex space-x-3 bg-white rounded-3xl p-2 shadow-lg border border-purple-200">
            <Input
              value={inputText}
              onChange={(e) => setInputText(e.target.value)}
              placeholder="Chiedi su salute, sicurezza, esercizi..."
              className="flex-1 border-0 bg-transparent text-base placeholder:text-gray-500 focus-visible:ring-0"
              onKeyPress={(e) => e.key === "Enter" && handleSendMessage(inputText)}
              disabled={isLoading}
            />
            <Button
              onClick={() => handleSendMessage(inputText)}
              disabled={!inputText.trim() || isLoading}
              className="h-10 w-10 rounded-2xl bg-gradient-to-r from-purple-500 to-pink-500 hover:from-purple-600 hover:to-pink-600 shadow-md"
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
