"use client";

import { Card, CardContent } from "@/components/ui/card";
import { ScrollArea } from "@/components/ui/scroll-area";

export default function PrivacyPolicy() {
  return (
    <div className="flex justify-center p-6">
      <Card className="w-full max-w-4xl rounded-2xl shadow-lg">
        <CardContent className="p-6">
          <ScrollArea className="h-[80vh] pr-4">
            <h1 className="text-2xl font-bold mb-4">Privacy Policy</h1>
            <p className="text-sm text-gray-600 mb-6">
              LAST UPDATED: August 21, 2025
            </p>

            <h2 className="text-lg font-bold mb-2">ABOUT US</h2>
            <p className="mb-4">
              Our Platforms "Platforms" means the website(s), including but not
              limited to https://dolcereset.app/ (the "Site"); mobile
              applications (means applications, each an “App”, collectively
              “Apps”) and any related documentation, services; any images,
              logos, wellness plans, and all other materials and content
              accessible within the Apps or Site (“App Content”) are owned,
              managed, and operated by Dolce Reset, a private limited company,
              incorporated and registered in [Insert Jurisdiction] with company
              number [Insert Number] whose registered office is at [Insert
              Address] (“we”, “us”, “our” or the “Company”).
            </p>
            <p className="mb-4">
              We can be contacted by writing to [Insert Address] or via
              info@dolceresetmenopausa.org.
            </p>
            <p className="mb-6">
              At Dolce Reset, we are dedicated to leveraging technology to
              support women’s wellness during menopause, fostering emotional
              well-being, and enhancing convenience in mobile usage. We
              prioritize transparency and accountability in our data practices,
              ensuring you understand how your data is handled while benefiting
              from our Platforms.
            </p>

            <h2 className="text-lg font-bold mb-2">
              YOUR DATA COLLECTED BY US
            </h2>
            <p className="mb-4">
              As you engage with our Platforms, we gather data concerning a
              recognized or identifiable living individual ("personal data")
              through:
            </p>
            <ul className="list-disc list-inside mb-4 space-y-2">
              <li>
                <strong>Data Directly Provided by You:</strong> Information you
                input, such as name, email address, or other details during
                registration or account setup.
              </li>
              <li>
                <strong>Data Automatically Collected by Us:</strong> Details
                about your device (e.g., model, OS, IP address) and actions
                within the Platforms.
              </li>
              <li>
                <strong>Data Acquired via Cookies:</strong> We use cookies and
                similar technologies to track preferences and interactions. See
                our Cookie Policy for more.
              </li>
            </ul>

            <h2 className="text-lg font-bold mb-2">WHY WE PROCESS YOUR DATA</h2>
            <ul className="list-disc list-inside mb-4 space-y-2">
              <li>Providing customer support via email.</li>
              <li>
                Enhancing Platform features by analyzing usage to tailor
                experiences.
              </li>
              <li>Improving technical aspects for better user experience.</li>
              <li>Optimizing advertising strategies by analyzing campaigns.</li>
              <li>Improving our Site using analytics.</li>
            </ul>

            <h2 className="text-lg font-bold mb-2">HOW YOUR DATA IS HANDLED</h2>
            <p className="mb-4">
              We process your personal data based on legal bases, including
              Legitimate Interest, Contract, Legal Obligation, and Consent. For
              sensitive data (e.g., health data), explicit consent is required.
              Purchases involve third-party payment systems.
            </p>

            <h2 className="text-lg font-bold mb-2">DATA RETENTION</h2>
            <p className="mb-4">
              We retain your personal data while your account is active or as
              needed, not exceeding 2 months from account deactivation or
              deletion.
            </p>

            <h2 className="text-lg font-bold mb-2">
              SHARING OF YOUR PERSONAL DATA
            </h2>
            <ul className="list-disc list-inside mb-4 space-y-2">
              <li>Third-party service providers (hosting, analytics, support).</li>
              <li>Marketing providers (with consent).</li>
              <li>Compliance with laws or emergencies.</li>
              <li>
                Aggregated/anonymized data shared without identification.
              </li>
              <li>Group companies under privacy standards.</li>
              <li>Publicly available data (leaderboards, chats).</li>
            </ul>

            <h2 className="text-lg font-bold mb-2">
              DATA STORAGE AND CROSS-BORDER TRANSFERS
            </h2>
            <p className="mb-4">
              Data is stored in the EU. For services outside the EU, we use
              Standard Contractual Clauses and security measures. By providing
              data, you consent to its transfer outside the EU.
            </p>

            <h2 className="text-lg font-bold mb-2">SECURITY</h2>
            <p className="mb-4">
              We use SSL encryption, encrypted databases, and secure servers. In
              case of a breach, we’ll notify you promptly.
            </p>

            <h2 className="text-lg font-bold mb-2">YOUR PRIVACY RIGHTS</h2>
            <ul className="list-disc list-inside mb-4 space-y-2">
              <li>Access, rectify, or delete your data.</li>
              <li>Object, restrict, or port data.</li>
              <li>Withdraw consent where applicable.</li>
              <li>File a complaint with authorities.</li>
            </ul>

            <h2 className="text-lg font-bold mb-2">
              OUR POLICIES CONCERNING CHILDREN
            </h2>
            <p className="mb-4">
              Users must be 18 (or minimum legal age per region). Underage users
              require parental consent. Data collected from children will be
              deleted.
            </p>

            <h2 className="text-lg font-bold mb-2">
              HOW CAN YOU MANAGE YOUR DATA?
            </h2>
            <p className="mb-4">
              Access, correct, or delete data by contacting us or via app
              settings on Android/iOS. Deleting your account removes access and
              progress.
            </p>

            <h2 className="text-lg font-bold mb-2">
              CHANGES TO THIS PRIVACY POLICY
            </h2>
            <p className="mb-4">
              We may amend this policy to reflect legal changes, practices, or
              technology. Check periodically for updates.
            </p>

            <h2 className="text-lg font-bold mb-2">
              PRIVACY NOTICE FOR CALIFORNIA RESIDENTS, US
            </h2>
            <p className="mb-4">
              We don’t sell personal info for money but may share basic data
              with ad partners (CCPA “selling”). Opt out via
              info@dolceresetmenopausa.org.
            </p>

            <h2 className="text-lg font-bold mb-2">
              PRIVACY NOTICE FOR VIRGINIA, CONNECTICUT, COLORADO, UTAH, AND
              NEVADA, US
            </h2>
            <p className="mb-4">
              We collect and process data as described, including sensitive
              information. Rights include opting out of targeted ads. Nevada
              residents may opt out of sales (not applicable).
            </p>
          </ScrollArea>
        </CardContent>
      </Card>
    </div>
  );
}