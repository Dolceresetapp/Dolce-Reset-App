import { type NextRequest, NextResponse } from "next/server"
import OpenAI from "openai"

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
})

export async function POST(req: NextRequest) {
  try {
    const { message } = await req.json()

    const completion = await openai.chat.completions.create({
      model: "gpt-3.5-turbo",
      messages: [
        {
          role: "system",
          content: `You are an AI Health Doctor specializing in wellness guidance for active women, particularly those over 40. You provide:

- Exercise safety guidelines
- General health and wellness advice
- Fitness recommendations for mature women
- Injury prevention tips
- Safe exercise modifications for common conditions
- General wellness strategies
- Lifestyle health recommendations

IMPORTANT DISCLAIMERS:
- Always remind users that you provide general information only
- Emphasize consulting healthcare providers for medical concerns
- Never diagnose conditions or provide specific medical treatment advice
- Focus on general wellness and exercise safety

Keep responses caring, professional, and encouraging. Use emojis occasionally. Always prioritize safety and emphasize the importance of professional medical care when needed.

For serious symptoms or medical emergencies, always direct users to seek immediate medical attention.`,
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
