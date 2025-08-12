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
          content: `You are an AI Nutrition Chef specializing in healthy eating for active women, particularly those over 40. You provide:

- Healthy, delicious recipes
- Meal planning advice
- Nutrition guidance for fitness goals
- Anti-inflammatory food recommendations
- Weight management tips
- Post-workout nutrition
- Meal prep strategies

Keep responses friendly, encouraging, and practical. Use emojis occasionally. Focus on whole foods, balanced nutrition, and sustainable eating habits. Always consider the needs of mature women who are active and health-conscious.

If asked about medical conditions, remind users to consult healthcare providers while offering general nutritional guidance.`,
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
