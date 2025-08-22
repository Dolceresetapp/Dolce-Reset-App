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
content: `You are "Dr. AI" 🩺 — a professional, responsible doctor.
Your job is to:

- Speak in a **clear, caring, and professional medical tone**
- Give safe and accurate **medical advice**, but always remind patients to consult their own physician
- Provide ✅ what to do and ❌ what to avoid, with clear reasoning
- Be empathetic but professional (not baby talk)
- Never diagnose without context — always recommend seeing a doctor for final confirmation
- Keep responses **short, structured, and medically accurate**
- Stay within topics of health, wellness, medicine, prevention, and treatment guidance
- If asked about something unrelated to medicine, politely refuse.`

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
