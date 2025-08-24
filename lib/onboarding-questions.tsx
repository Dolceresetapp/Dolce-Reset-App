export interface EmotionalQuestion {
  id: string
  title: string
  subtitle?: string
  type: "single-choice" | "multiple-choice" | "input" | "custom-screen"
  options: Array<{
    id: string
    label: string
    emoji?: string
    image?: string
    description?: string
  }>
  image?: string
  inputType?: "text" | "number"
  placeholder?: string
  min?: number
  max?: number
  customScreenType?: string
}

export const emotionalQuestions: EmotionalQuestion[] = [
  {
    id: "urgent_improvement",
    title: "Cosa senti che necessita di miglioramento immediato nel tuo corpo?",
    subtitle: "Scegli un'opzione 💕",
    type: "single-choice",
    options: [
      {
        id: "weight_loss",
        label: "Perdita di peso",
        image: "/improvedbody/2.png",
      },
      {
        id: "get_fit",
        label: "RIMETTERSI IN FORMA",
        image: "/improvedbody/13.png",
      },
      {
        id: "better_sleep",
        label: "Migliorare sonno / energia",
        image: "/improvedbody/4.png",
      },
      {
        id: "improve_aches",
        label: "Ridurre dolori / rigidità",
        image: "/improvedbody/5.png",
      },
    ],
  },
  {
    id: "body_part_focus",
    title: "Quale parte del corpo vorresti migliorare già nei prossimi 30 giorni?",
    subtitle: "Scegli l'area di focus",
    type: "single-choice",
    options: [
      {
        id: "belly_face",
        label: "Addome e viso",
        image: "/bodyparts/8.png",
      },
      {
        id: "legs",
        label: "Gambe",
        image: "/bodyparts/11.png",
      },
      {
        id: "back_posture",
        label: "Schiena / Postura",
        image: "/bodyparts/9.png",
      },
      {
        id: "full_body",
        label: "Corpo intero",
        image: "/improvedbody/13.png",
      },
    ],
  },
  {
    id: "custom_output",
    title: "Anteprima del tuo piano personalizzato",
    type: "custom-screen",
    customScreenType: "custom-output",
    options: [],
  },
  {
    id: "current_body_type",
    title: "Quale descrive meglio il tuo corpo?",
    subtitle: "Sii onesta per darti risultati migliori",
    type: "single-choice",
    options: [
      {
        id: "slim",
        label: "Snello",
        image: "/sizes/18.png",
      },
      {
        id: "average",
        label: "Nella media",
        image: "/sizes/15.png",
      },
      {
        id: "plus_sized",
        label: "Taglia forte",
        image: "/sizes/14.png",
      },
    ],
  },
  {
    id: "dream_body",
    title: "Qual è il tuo corpo ideale?",
    subtitle: "Il tuo tipo di corpo ideale",
    type: "single-choice",
    options: [
      {
        id: "toned",
        label: "Sano e in forma",
        image: "/improvedbody/2.png",
      },
      {
        id: "curvy",
        label: "Curvy e sicuro di sé",
        image: "/improvedbody/13.png",
      },
      {
        id: "strong",
        label: "Forte e sano",
        image: "/bodyparts/12.png",
      },
    ],
  },
  {
    id: "gift_screen",
    title: "Aspetta fino alla fine, c'è un regalo per te",
    type: "custom-screen",
    customScreenType: "gift-box",
    options: [],
  },
  {
    id: "height",
    title: "Qual è la tua altezza?",
    subtitle: "Serve per calcolare il tuo indice massa corporea",
    type: "input",
    inputType: "number",
    placeholder: "es. 165",
    min: 120,
    max: 220,
    options: [],
  },
  {
    id: "current_weight",
    title: "Qual è il tuo peso attuale?",
    subtitle: "Inserisci in chilogrammi (kg)",
    type: "input",
    inputType: "number",
    placeholder: "es. 65",
    min: 30,
    max: 200,
    options: [],
  },
  {
    id: "current_bmi_analysis",
    title: "Analisi del tuo indice massa corporea attuale",
    type: "custom-screen",
    customScreenType: "current-bmi",
    options: [],
  },
  {
    id: "target_weight",
    title: "Qual è il tuo peso target?",
    subtitle: "Inserisci il peso obiettivo in chilogrammi (kg)",
    type: "input",
    inputType: "number",
    placeholder: "es. 60",
    min: 30,
    max: 200,
    options: [],
  },
  {
    id: "target_bmi_analysis",
    title: "Analisi del indice massa corporea obiettivo",
    type: "custom-screen",
    customScreenType: "target-bmi",
    options: [],
  },
  {
    id: "age",
    title: "Quanti anni hai?",
    subtitle: "Serve per personalizzare il tuo piano",
    type: "input",
    inputType: "number",
    placeholder: "es. 35",
    min: 16,
    max: 79,
    options: [],
  },
  {
    id: "bmi_result",
    title: "Hai un ottimo potenziale per raggiungere ogni traguardo",
    type: "custom-screen",
    customScreenType: "bmi-analysis",
    options: [],
  },
  {
    id: "trying_duration",
    title: "Hai già provato soluzioni per risolvere questi problemi?",
    subtitle: "Seleziona una risposta 👎",
    type: "single-choice",
    options: [
      {
        id: "never",
        label: "Mai provato",
        emoji: "❌",
        description: "È il mio primo tentativo",
      },
      {
        id: "few_months",
        label: "Pochi mesi",
        emoji: "⏳",
        description: "Ho iniziato da poco",
      },
      {
        id: "years",
        label: "Anni",
        emoji: "🕰️",
        description: "Problema presente da anni",
      },
    ],
  },
  {
    id: "celebration_plan",
    title: "COME FESTEGGIERAI QUANDO RAGGIUNGERAI I TUOI OBIETTIVI?",
    subtitle: "Visualizza la tua vittoria! 🎉",
    type: "single-choice",
    options: [
      {
        id: "party",
        label: "Fare una grande festa",
        emoji: "👑",
      },
      {
        id: "trip",
        label: "Fare un viaggio divertente",
        emoji: "⚡",
      },
      {
        id: "dinner",
        label: "Uscire per una cena speciale",
        emoji: "🌟",
      },
      {
        id: "relax",
        label: "Rilassarsi e coccolarmi",
        emoji: "😊",
      },
    ],
  },
  {
    id: "doctor_recommendation",
    title: "Consigliato dal medico",
    type: "custom-screen",
    customScreenType: "doctor-screen",
    options: [],
  },
  {
    id: "body_satisfaction",
    title: "Negli ultimi 6 mesi, quanto sei stato soddisfatto del tuo corpo?",
    subtitle: "Sii onesto con i tuoi sentimenti",
    type: "single-choice",
    options: [
      {
        id: "very",
        label: "Molto soddisfatto",
        emoji: "😍",
      },
      {
        id: "somewhat",
        label: "Abbastanza soddisfatto",
        emoji: "🙂",
      },
      {
        id: "little",
        label: "Poco soddisfatto",
        emoji: "😐",
      },
      {
        id: "not_at_all",
        label: "Per nulla soddisfatto",
        emoji: "😔",
      },
    ],
  },
]

