import React from "react";

export default function GDPRComplianceGuide() {
  return (
    <div className="p-6 max-w-4xl mx-auto text-gray-800">
      <h1 className="text-3xl font-bold mb-4 text-center">
        GDPR Compliance Guide for Dolce Reset
      </h1>
      <p className="text-sm text-gray-500 mb-6 text-center">
        Effective Date: August 21, 2025
      </p>

      <section className="mb-6">
        <h2 className="text-xl font-semibold mb-2">Introduction</h2>
        <p>
          The General Data Protection Regulation (GDPR), effective since May 25, 2018,
          governs the processing of personal data of individuals within the European Union (EU)
          and the European Economic Area (EEA), including Italy. As Dolce Reset, operating the
          marketplace at <a href="https://dolcereset.app/" className="text-purple-600 underline">https://dolcereset.app/</a>,
          you are subject to GDPR if you process personal data of EU/EEA residents, whether as a
          data controller or processor. This guide outlines key GDPR requirements to ensure compliance.
        </p>
      </section>

      <section className="mb-6">
        <h2 className="text-xl font-semibold mb-2">Key GDPR Obligations</h2>
        <ol className="list-decimal pl-6 space-y-4">
          <li>
            <strong>Legal Basis for Processing</strong> – Process personal data only with a valid legal basis under Article 6, such as:
            <ul className="list-disc pl-6 mt-1">
              <li>Consent: Freely given, specific, informed, and unambiguous.</li>
              <li>Contract: Necessary for performing a contract with the data subject.</li>
              <li>Legitimate Interests: Balanced against individual rights.</li>
              <li>Legal Obligation: Required by EU or Italian law.</li>
            </ul>
            For sensitive data (e.g., health data), Article 9 requires explicit consent.
          </li>

          <li>
            <strong>Data Subject Rights</strong> – Ensure users can exercise rights under Articles 15–22, including access, rectification,
            erasure, restriction, portability, objection, and rights related to automated decision-making.
          </li>

          <li>
            <strong>Transparency and Privacy Policy</strong> – Maintain a clear, accessible Privacy Policy per Article 13–14, covering identity of controller,
            purposes, legal bases, categories, recipients, retention, and rights.
          </li>

          <li>
            <strong>Data Protection by Design and Default</strong> – Implement measures such as data minimization, pseudonymization, encryption, and default privacy settings.
          </li>

          <li>
            <strong>Security and Breach Notification</strong> – Safeguard data with encryption and servers; notify the Garante within 72 hours of breaches and inform users if high risk.
          </li>

          <li>
            <strong>Data Protection Officer (DPO)</strong> – Appoint if large-scale sensitive data is processed. Publish contact info and ensure independence.
          </li>

          <li>
            <strong>Data Transfers Outside the EU/EEA</strong> – Use SCCs or adequacy decisions for transfers. Document mechanisms.
          </li>

          <li>
            <strong>Record-Keeping and Accountability</strong> – Maintain Article 30 records and conduct DPIAs for high-risk processing.
          </li>

          <li>
            <strong>Processor Agreements</strong> – Contractually bind processors (Article 28) with obligations on security and cooperation.
          </li>

          <li>
            <strong>Cooperation with Authorities</strong> – Cooperate with the Garante and comply with investigations.
          </li>
        </ol>
      </section>

      <section className="mb-6">
        <h2 className="text-xl font-semibold mb-2">Penalties</h2>
        <p>
          Non-compliance may lead to fines up to €20 million or 4% of annual global turnover (whichever is higher).
          The Garante may also issue warnings, bans, or corrective orders.
        </p>
      </section>

      <section className="mb-6">
        <h2 className="text-xl font-semibold mb-2">Italian-Specific Considerations</h2>
        <p>
          The Garante places special focus on health data. Explicit consent is critical. Italy’s Data Protection Code (Legislative Decree No. 196/2003)
          and Consumer Code impose further requirements, especially for e-commerce and health-related platforms.
        </p>
      </section>

      <section className="mb-6">
        <h2 className="text-xl font-semibold mb-2">Implementation Steps for Dolce Reset</h2>
        <ul className="list-disc pl-6 space-y-1">
          <li>Update Privacy Policy and Terms to reflect GDPR obligations.</li>
          <li>Appoint a DPO if required and publish details.</li>
          <li>Conduct DPIAs for AI or health data usage.</li>
          <li>Train staff on GDPR practices.</li>
          <li>Audit processors for SCCs and security.</li>
          <li>Establish a breach response plan.</li>
        </ul>
      </section>

      <section className="mb-6">
        <h2 className="text-xl font-semibold mb-2">Contact</h2>
        <p>
          For GDPR-related queries, contact Dolce Reset at
          <a href="mailto:info@dolceresetmenopausa.org" className="text-purple-600 underline"> info@dolceresetmenopausa.org</a>
          or the Garante at
          <a href="mailto:garante@gpdp.it" className="text-purple-600 underline"> garante@gpdp.it</a>.
        </p>
      </section>
    </div>
  );
}
