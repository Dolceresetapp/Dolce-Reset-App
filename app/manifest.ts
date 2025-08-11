import type { MetadataRoute } from "next"

export default function manifest(): MetadataRoute.Manifest {
  return {
    name: "SeniorFit - Fitness for Life",
    short_name: "SeniorFit",
    description: "Gentle fitness exercises designed specifically for senior women",
    start_url: "/",
    display: "standalone",
    background_color: "#fef7f0",
    theme_color: "#ec4899",
    orientation: "portrait",
    icons: [
      {
        src: "/icon-192x192.png",
        sizes: "192x192",
        type: "image/png",
      },
      {
        src: "/icon-512x512.png",
        sizes: "512x512",
        type: "image/png",
      },
    ],
    categories: ["health", "fitness", "lifestyle"],
    screenshots: [
      {
        src: "/main.png",
        sizes: "390x844",
        type: "image/png",
        form_factor: "narrow",
      },
    ],
  }
}
