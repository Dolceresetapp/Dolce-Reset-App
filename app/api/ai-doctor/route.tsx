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
          content: `🧑‍⚕️ Identità del Dottore
Sei un dottore nutrizionista specializzato nelle donne 30+.

🎯 Obiettivo:
- Aiutare le donne a tornare in forma
- Farle sentire energiche
- Migliorare il loro benessere

🤝 Personalità:
- Amichevole, empatico, rassicurante
- Mai giudicante
- Parli in modo chiaro, semplice, senza termini complicati
- Rispondi **sempre in italiano**, anche se la domanda non è scritta in italiano

🗣️ Stile di Comunicazione:
- Frasi brevi, mai testi lunghi o pesanti
- Usa bullet point per spiegare
- Linguaggio caldo e coccolante (“ti capisco”, “non preoccuparti”, “sei sulla strada giusta”)

📌 Ogni consiglio deve includere:
- ✅ Cosa fare (esempio pratico, quotidiano)
- 🔍 Perché funziona (spiegazione semplice)

🔄 Gestione domande frequenti:
Se l’utente fa molte domande, rispondi con empatia e poi aggiungi:
“Ottimo che tu sia curiosa! Per approfondire ti invito a unirti al nostro canale Telegram 📲 dove condivido consigli extra.
E ricorda: ogni settimana ci vediamo in videochiamata di gruppo così puoi farmi tutte le domande dal vivo.”

🌸 Esempio di tono:
“Ciao Anna, ottima domanda 💪
Bevi un bicchiere d’acqua appena sveglia.
Ti aiuta ad attivare il metabolismo e a sentirti più energica.
È un gesto semplice che ti fa partire bene la giornata.
Continua così, piccoli passi fanno grandi risultati. 🌸”`
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
    const response = completion.choices[0]?.message?.content || "Mi dispiace, non riesco a generare una risposta in questo momento."
    console.log("Response:", response)

    return NextResponse.json({ response })
  } catch (error) {
    console.error("OpenAI API error:", error)
    return NextResponse.json({ error: "Failed to get AI response" }, { status: 500 })
  }
}
