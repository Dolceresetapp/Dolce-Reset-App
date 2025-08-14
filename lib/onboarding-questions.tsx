export interface EmotionalQuestion {
  id: string
  title: string
  subtitle?: string
  type: "single-choice" | "input"
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
}

export const emotionalQuestions: EmotionalQuestion[] = [
  {
    id: "urgent_improvement",
    title: "What needs to improve most urgently?",
    subtitle: "Select your main priority 💕",
    type: "single-choice",
    options: [
      {
        id: "weight_loss",
        label: "Weight Loss",
        image: "/improvedbody/2.png",
      },
      {
        id: "get_fit",
        label: "Get Fit & Strong",
        image: "/improvedbody/13.png",
      },
      {
        id: "reduce_pain",
        label: "Reduce Pain",
        image: "/improvedbody/5.png",
      },
      {
        id: "feel_younger",
        label: "Feel Younger",
        image: "/improvedbody/7.png",
      },
    ],
  },
  {
    id: "body_part_focus",
    title: "Which area to change in 30 days?",
    subtitle: "Choose your focus area",
    type: "single-choice",
    options: [
      {
        id: "stomach",
        label: "Stomach",
        image: "/bodyparts/8.png",
      },
      {
        id: "full_body",
        label: "Full Body",
        image: "/improvedbody/13.png",
      },
      {
        id: "legs_buttocks",
        label: "Legs & Buttocks",
        image: "/bodyparts/11.png",
      },
    ],
  },
  {
    id: "current_body_type",
    title: "Your current body type?",
    subtitle: "Be honest for best results",
    type: "single-choice",
    options: [
      {
        id: "slim",
        label: "Slim",
        image: "/sizes/18.png",
      },
      {
        id: "average",
        label: "Average",
        image: "/sizes/15.png",
      },
      {
        id: "plus_sized",
        label: "Plus-sized",
        image: "/sizes/14.png",
      },
    ],
  },
  {
    id: "age",
    title: "What's your age?",
    subtitle: "Enter your current age",
    type: "input",
    inputType: "number",
    placeholder: "e.g. 45",
    min: 18,
    max: 100,
    options: [], // Required but empty for input type
  },
  {
    id: "current_weight",
    title: "What's your current weight?",
    subtitle: "Enter in kilograms (kg)",
    type: "input",
    inputType: "number",
    placeholder: "e.g. 65",
    min: 30,
    max: 200,
    options: [], // Required but empty for input type
  },
  {
    id: "height",
    title: "What's your height?",
    subtitle: "Enter in centimeters (cm)",
    type: "input",
    inputType: "number",
    placeholder: "e.g. 165",
    min: 120,
    max: 220,
    options: [], // Required but empty for input type
  },
  {
    id: "target_weight",
    title: "What's your target weight?",
    subtitle: "Your goal weight in kilograms (kg)",
    type: "input",
    inputType: "number",
    placeholder: "e.g. 58",
    min: 30,
    max: 200,
    options: [], // Required but empty for input type
  },
  {
    id: "trying_duration",
    title: "How long trying without results?",
    subtitle: "Select one answer 👎",
    type: "single-choice",
    options: [
      {
        id: "never",
        label: "Never tried",
        emoji: "❌",
        description: "This is my first attempt",
      },
      {
        id: "few_months",
        label: "A few months",
        emoji: "⏳",
        description: "Recently started trying",
      },
      {
        id: "years",
        label: "Years",
        emoji: "🕰️",
        description: "Been struggling for years",
      },
    ],
  },
  {
    id: "celebration_plan",
    title: "How will you celebrate success?",
    subtitle: "Visualize your victory! 🎉",
    type: "single-choice",
    options: [
      {
        id: "new_dress",
        label: "Buy new dress",
        emoji: "👗",
      },
      {
        id: "photo_session",
        label: "Photo session",
        emoji: "📸",
      },
      {
        id: "spa_day",
        label: "Spa day",
        emoji: "💆‍♀️",
      },
    ],
  },
]
