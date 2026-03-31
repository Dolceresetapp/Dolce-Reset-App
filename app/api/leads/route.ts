import { NextResponse } from "next/server"

const AC_API_TOKEN = process.env.ACTIVECAMPAIGN_API_TOKEN || ""
const AC_BASE_URL = process.env.ACTIVECAMPAIGN_BASE_URL || "https://dolceresetapp.api-us1.com"
const AC_LEADS_LIST_ID = 6 // "Leads" list in ActiveCampaign

export async function POST(request: Request) {
  try {
    const { email } = await request.json()

    if (!email || !email.includes("@")) {
      return NextResponse.json({ status: "error", message: "Invalid email" }, { status: 422 })
    }

    const normalizedEmail = email.trim().toLowerCase()

    // 1. Create or update contact in ActiveCampaign
    const syncRes = await fetch(`${AC_BASE_URL}/api/3/contact/sync`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Api-Token": AC_API_TOKEN,
      },
      body: JSON.stringify({
        contact: { email: normalizedEmail },
      }),
    })

    if (!syncRes.ok) {
      console.error("ActiveCampaign sync failed:", await syncRes.text())
      return NextResponse.json({ status: "error", message: "Failed to sync contact" }, { status: 500 })
    }

    const syncData = await syncRes.json()
    const contactId = syncData?.contact?.id

    if (!contactId) {
      return NextResponse.json({ status: "error", message: "No contact ID returned" }, { status: 500 })
    }

    // 2. Subscribe contact to Leads list (status 1 = subscribed)
    const listRes = await fetch(`${AC_BASE_URL}/api/3/contactLists`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Api-Token": AC_API_TOKEN,
      },
      body: JSON.stringify({
        contactList: {
          list: AC_LEADS_LIST_ID,
          contact: parseInt(contactId),
          status: 1,
        },
      }),
    })

    if (!listRes.ok) {
      console.error("ActiveCampaign list add failed:", await listRes.text())
    }

    // 3. Also store in backend (best effort, table may not exist)
    try {
      await fetch(`${process.env.NEXT_PUBLIC_API_URL || "https://admin.dolcereset.com"}/api/leads/store`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: JSON.stringify({
          email: normalizedEmail,
          source: "web_quiz",
        }),
      })
    } catch {
      // Don't fail if backend is down
    }

    return NextResponse.json({ status: "success", message: "Lead synced to ActiveCampaign" })
  } catch (error) {
    console.error("Lead API error:", error)
    return NextResponse.json({ status: "error", message: "Internal error" }, { status: 500 })
  }
}
