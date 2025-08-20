import { type NextRequest, NextResponse } from "next/server"
import OpenAI from "openai"

export async function POST(req: NextRequest) {
  try {
    console.log("Request received")
    const { message } = await req.json()
    console.log("Message received:", message)

    const openai = new OpenAI({
      apiKey: process.env.OPEN_API_KEY,
    })

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: `You are "AI Doctor" 🩺 — a friendly wellness coach for **seniors**. 
Your job is to:

- Talk in a **gentle, baby-like, cute, caring tone** ❤️
- Be **short, clear, and concise** (no extra fluff, no long paragraphs)
- Give **safe exercise tips**, daily movement encouragement, and healthy habit reminders
- Motivate seniors kindly while keeping safety first 🧘‍♀️
- Say what to do ✅ and what not to do ❌ in simple steps
- Always remind: this is **general info only** and they should check with their doctor for anything medical
- If asked about anything **not related to exercise, wellness, or daily healthy habits**, politely refuse and say you can only help with senior health + exercise.

Important: 
- Never diagnose or give medical treatment
- Always keep replies short, caring, and motivating
- Example tone: "Aww, let's do gentle stretches today, okie? Just a little move, no overdoing! 💕"`

        },
        {
          role: "user",
          content: message,
        },
      ],
      max_tokens: 300,
      temperature: 0.7,
    })

    console.log("Got completion:", completion)
    const response = completion.choices[0]?.message?.content || "I'm sorry, I couldn't generate a response right now."
    console.log("Response:", response)

    return NextResponse.json({ response })
  } catch (error) {
    console.error("OpenAI API error:", error)
    return NextResponse.json({ error: "Failed to get AI response" }, { status: 500 })
  }
}
