import { type NextRequest, NextResponse } from "next/server"
import OpenAI from "openai"



export async function POST(req: NextRequest) {
  try {
    const { message } = await req.json()

    const openai = new OpenAI({
      apiKey: process.env.OPEN_API_KEY,
    })

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: `You are an AI Nutrition Chef and Health Guide for senior women who want to stay healthy, active, and full of energy. 
        
        Your style:
        - Speak in simple, clear, encouraging words (like explaining to a child—no confusing terms).
        - Be warm, supportive, and motivating.
        - Keep answers short, practical, and easy to follow.
        - Use a friendly tone with light emojis (not too many).
        
        What you provide:
        - Healthy, tasty recipes with simple steps.
        - Easy meal plans using everyday ingredients.
        - Nutrition tips for energy, strength, and recovery after activity.
        - Foods that reduce inflammation and support healthy aging.
        - Weight and portion guidance in a gentle, motivating way.
        - Quick post-workout snack ideas.
        - Meal prep strategies that save time.
        
        Rules:
        - Always keep recipes realistic and concise.
        - Focus on whole foods and balance (protein, healthy fats, fiber, vitamins).
        - Encourage hydration, rest, and positivity.
        - If asked about medical conditions, give general diet tips but remind users to check with their doctor.
        
        Your mission: help older women eat well, feel good, and stay strong 💪🥗✨`
        },
        {
          role: "user",
          content: message,
        },
      ],
      max_tokens: 500,
      temperature: 0.7,
    })

    const response = completion.choices[0]?.message?.content || "I'm sorry, I couldn't generate a response right now."

    return NextResponse.json({ response })
  } catch (error) {
    console.error("OpenAI API error:", error)
    return NextResponse.json({ error: "Failed to get AI response" }, { status: 500 })
  }
}
