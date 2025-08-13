export interface EmotionalQuestion {
  id: string
  title: string
  subtitle?: string
  type: "single-choice" | "multiple-choice" | "body-parts" | "input" | "slider"
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
    title: "What do you feel most urgently needs to improve in your body right now?",
    subtitle: "Select all that apply - be honest with yourself 💕",
    type: "multiple-choice",
    options: [
      {
        id: "weight_loss",
        label: "Weight Loss",
        image: "/improvedbody/2.png",
        description: "Lose those extra pounds",
      },
      {
        id: "get_fit",
        label: "Get Fit",
        image: "/improvedbody/13.png",
        description: "Build strength and endurance",
      },
      {
        id: "better_sleep",
        label: "Better Sleep / Energy",
        image: "/improvedbody/4.png",
        description: "Feel more rested and energetic",
      },
      {
        id: "aches_stiffness",
        label: "Improve Aches / Stiffness",
        image: "/improvedbody/5.png",
        description: "Reduce pain and improve mobility",
      },
      {
        id: "get_healthier",
        label: "Get Healthier",
        image: "/improvedbody/7.png",
        description: "Overall health improvement",
      },
      // {
      //   id: "everything",
      //   label: "Everything",
      //   image: "/improvedbody/7.png",
      //   description: "Complete transformation",
      // },
    ],
  },
  {
    id: "body_part_focus",
    title: "Which body part would you like to see a change in as early as 30 days?",
    subtitle: "Choose the area that bothers you most",
    type: "single-choice",
    options: [
      {
        id: "stomach",
        label: "Stomach",
        image: "/bodyparts/8.png",
        description: "Flatten and tone your belly",
      },
      {
        id: "buttocks",
        label: "Buttocks",
        image: "/bodyparts/9.png",
        description: "Lift and shape your glutes",
      },
      {
        id: "legs",
        label: "Legs",
        image: "/bodyparts/11.png",
        description: "Tone and strengthen your legs",
      },
      {
        id: "arms",
        label: "Arms",
        image: "/improvedbody/7.png",
        description: "Sculpt beautiful, strong arms",
      },
      {
        id: "back_posture",
        label: "Back/Posture",
        image: "/bodyparts/10.png",
        description: "Improve posture and back strength",
      },
      {
        id: "full_body",
        label: "Full Body",
        image: "/improvedbody/13.png",
        description: "Complete body transformation",
      },
    ],
  },
  {
    id: "current_body_type",
    title: "What image describes your physical build and belly?",
    subtitle: "Be honest - this helps us create your perfect plan",
    type: "single-choice",
    options: [
      {
        id: "slim",
        label: "Slim",
        image: "/sizes/18.png",
        description: "Naturally thin build",
      },
      {
        id: "mid_sized",
        label: "Mid-sized",
        image: "/sizes/15.png",
        description: "Average build with some curves",
      },
      {
        id: "plus_sized",
        label: "Plus-sized",
        image: "/sizes/14.png",
        description: "Curvy with extra weight",
      },
      {
        id: "overweight",
        label: "Overweight",
        image: "/sizes/16.png",
        description: "Significantly above ideal weight",
      },
    ],
  },
  {
    id: "dream_body",
    title: 'What is your "dream body"?',
    subtitle: "Visualize your goal - you can achieve it! 🌟",
    type: "single-choice",
    options: [
      {
        id: "fit",
        label: "Fit",
        image: "/improvedbody/2.png",
        description: "Toned and healthy",
      },
      {
        id: "athletic",
        label: "Athletic",
        image: "/improvedbody/13.png",
        description: "Strong and muscular",
      },
      {
        id: "shapely",
        label: "Shapely",
        image: "/bodyparts/12.png",
        description: "Curvy and confident",
      },
    ],
  },
  {
    id: "trying_duration",
    title: "How long have you been trying to improve without lasting results?",
    subtitle: "Select one answer 👎",
    type: "single-choice",
    options: [
      {
        id: "never",
        label: "Never",
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
    id: "past_attempts",
    title: "Have you already tried solutions to solve these problems?",
    subtitle: "Select all you've tried 👎",
    type: "multiple-choice",
    options: [
      {
        id: "diets",
        label: "Diets",
        emoji: "🥗",
        description: "Restrictive eating plans",
      },
      {
        id: "weight_loss_pills",
        label: "Weight-loss pills",
        emoji: "💊",
        description: "Supplements and pills",
      },
      {
        id: "tough_gym",
        label: "Tough gym workouts",
        emoji: "🏋️‍♀️",
        description: "Intense gym sessions",
      },
      {
        id: "generic_programs",
        label: "Generic programs",
        emoji: "📄",
        description: "One-size-fits-all plans",
      },
      {
        id: "online_programs",
        label: "Online programs not followed",
        emoji: "💻",
        description: "Started but didn't finish",
      },
      {
        id: "nothing",
        label: "Nothing ever",
        emoji: "❌",
        description: "This is my first real attempt",
      },
    ],
  },
  {
    id: "age",
    title: "What's your age?",
    subtitle: "This helps us customize your perfect plan",
    type: "input",
    inputType: "number",
    placeholder: "Enter your age",
    min: 18,
    max: 100,
    options: [],
  },
  {
    id: "height",
    title: "What's your height?",
    subtitle: "We'll use this to calculate your progress",
    type: "input",
    inputType: "number",
    placeholder: "Enter your height in cm",
    min: 120,
    max: 220,
    options: [],
  },
  {
    id: "celebration_plan",
    title: "How will you celebrate when you reach your goals?",
    subtitle: "Visualize your success! 🎉",
    type: "single-choice",
    options: [
      {
        id: "special_evening",
        label: "A special evening with loved ones",
        emoji: "🎉",
        description: "Celebrate with family and friends",
      },
      {
        id: "weekend_getaway",
        label: "A weekend getaway just for me",
        emoji: "🏖️",
        description: "Beach or mountain retreat",
      },
      {
        id: "new_dress",
        label: "A new dress to feel even more beautiful",
        emoji: "👗",
        description: "Show off your new confidence",
      },
      {
        id: "photo_session",
        label: "A photo session to remember my transformation",
        emoji: "📸",
        description: "Capture your amazing results",
      },
      {
        id: "concert_dancing",
        label: "A concert or dancing night",
        emoji: "🎶",
        description: "Release all your new energy",
      },
      {
        id: "spa_day",
        label: "A spa day to pamper myself",
        emoji: "💆‍♀️",
        description: "You deserve to be spoiled",
      },
      {
        id: "inspire_friends",
        label: "Share my success to inspire friends",
        emoji: "❤️",
        description: "Help other women transform too",
      },
    ],
  },
  {
    id: "future_fear",
    title: "If you don't change anything, how will you feel in 6 months?",
    subtitle: "Be honest about your fears...",
    type: "single-choice",
    options: [
      {
        id: "insecure_same_health",
        label: "Insecure and with the same health issues",
        emoji: "😔",
        description: "Nothing will improve",
      },
      {
        id: "less_satisfied",
        label: "Less satisfied with myself",
        emoji: "😞",
        description: "Confidence will keep dropping",
      },
      {
        id: "little_change",
        label: "Very little change, still struggling",
        emoji: "😟",
        description: "Minimal progress, same problems",
      },
    ],
  },
  {
    id: "body_satisfaction",
    title: "Over the past 6 months, how satisfied have you been with your body?",
    subtitle: "Your honest answer helps us understand you better",
    type: "single-choice",
    options: [
      {
        id: "very_satisfied",
        label: "Very satisfied",
        emoji: "😊",
        description: "I love how I look and feel",
      },
      {
        id: "somewhat_satisfied",
        label: "Somewhat satisfied",
        emoji: "🙂",
        description: "It's okay, but could be better",
      },
      {
        id: "little_satisfied",
        label: "A little satisfied",
        emoji: "😐",
        description: "Not happy with many things",
      },
      {
        id: "not_satisfied",
        label: "Not satisfied at all",
        emoji: "😞",
        description: "I really need to change",
      },
    ],
  },
]
