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
    title: "What do you feel most urgently needs to improve in your body right now?",
    subtitle: "Choose one option 💕",
    type: "single-choice",
    options: [
      {
        id: "weight_loss",
        label: "Weight Loss",
        image: "/improvedbody/2.png",
      },
      {
        id: "get_fit",
        label: "GET FIT",
        image: "/improvedbody/13.png",
      },
      {
        id: "better_sleep",
        label: "BETTER SLEEP / ENERGY",
        image: "/improvedbody/4.png",
      },
      {
        id: "improve_aches",
        label: "IMPROVE Aches / Stiffness",
        image: "/improvedbody/5.png",
      },
    ],
  },
  {
    id: "body_part_focus",
    title: "Which body part would you like to see a change in as early as 30 days?",
    subtitle: "Choose your focus area",
    type: "single-choice",
    options: [
      {
        id: "belly_face",
        label: "Belly and Face",
        image: "/bodyparts/8.png",
      },
      {
        id: "legs",
        label: "Legs and Legs",
        image: "/bodyparts/11.png",
      },
      {
        id: "back_posture",
        label: "Back/Posture",
        image: "/bodyparts/9.png",
      },
      {
        id: "full_body",
        label: "Full Body",
        image: "/improvedbody/13.png",
      },
    ],
  },
  {
    id: "custom_output",
    title: "Your Custom Plan Preview",
    type: "custom-screen",
    customScreenType: "custom-output",
    options: [],
  },
  {
    id: "current_body_type",
    title: "Which describes your best body?",
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
    id: "dream_body",
    title: "What is your dream body?",
    subtitle: "Your ideal body type",
    type: "single-choice",
    options: [
      {
        id: "toned",
        label: "Healthy and Fit",
        image: "/improvedbody/2.png",
      },
      {
        id: "curvy",
        label: "Curvy & Confident",
        image: "/improvedbody/13.png",
      },
      {
        id: "strong",
        label: "Strong & Healthy",
        image: "/bodyparts/12.png",
      },
    ],
  },
  {
    id: "gift_screen",
    title: "Wait until end there is some gift for you",
    type: "custom-screen",
    customScreenType: "gift-box",
    options: [],
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
    options: [],
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
    options: [],
  },
  {
    id: "bmi_result",
    title: "Hai Un Ottimo Potenziale Per Spaccare Ogni Traguardo",
    type: "custom-screen",
    customScreenType: "bmi-analysis",
    options: [],
  },
  {
    id: "trying_duration",
    title: "Have you already tried solutions to solve these problems?",
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
    title: "HOW WILL YOU CELEBRATE WHEN YOU REACH YOUR GOALS?",
    subtitle: "Visualize your victory! 🎉",
    type: "single-choice",
    options: [
      {
        id: "confident",
        label: "More Confident",
        emoji: "👑",
      },
      {
        id: "energetic",
        label: "Full of Energy",
        emoji: "⚡",
      },
      {
        id: "proud",
        label: "Proud of Myself",
        emoji: "🌟",
      },
      {
        id: "happy",
        label: "Truly Happy",
        emoji: "😊",
      },
    ],
  },
  {
    id: "doctor_recommendation",
    title: "Doctor Recommended",
    type: "custom-screen",
    customScreenType: "doctor-screen",
    options: [],
  },
  {
    id: "comparison_screen",
    title: "Why Choose Our Method",
    type: "custom-screen",
    customScreenType: "comparison",
    options: [],
  },
  {
    id: "body_satisfaction",
    title: "Over the past 6 months, how satisfied have you been with your body?",
    subtitle: "Be honest about your feelings",
    type: "single-choice",
    options: [
      {
        id: "very",
        label: "Very satisfied",
        emoji: "😍",
      },
      {
        id: "somewhat",
        label: "Somewhat satisfied",
        emoji: "🙂",
      },
      {
        id: "little",
        label: "A little satisfied",
        emoji: "😐",
      },
      {
        id: "not_at_all",
        label: "Not at all satisfied",
        emoji: "😔",
      },
    ],
  },
]
