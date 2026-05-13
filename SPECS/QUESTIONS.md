# QUESTIONS — Scoping the MLflow 3 talk for the bank

Five questions to ask the people preparing the session (account team / bank sponsor) before locking the deck. Each one collapses a real branch in the current SPEC.

## 1. Who is actually in the room, and what is the ratio?

How many of each: ML engineers / data scientists / MLOps / model risk & compliance / business stakeholders? Are any C-level or just the practitioner layer?

*Why it narrows scope:* shifts the weight between Act II (technical pillars + demo) and Act III (governance, EU AI Act, RACI). A 90% practitioner room means cutting two governance slides and extending the demo; a mixed room with model risk officers means the opposite.

## 2. What is their current MLflow estate, and what is the pain point that triggered this talk?

Are they on OSS MLflow 2.x, Managed MLflow on Databricks, both? Do they use Unity Catalog today? Is there a concrete trigger — a failed GenAI pilot, an ACPR inspection finding, a model that hallucinated in UAT, an EU AI Act deadline?

*Why it narrows scope:* determines whether the talk frames MLflow 3 as "add observability to what you have" vs "the reason to migrate". Also tells us which pillar to lead with — pain dictates the opening.

## 3. Is there a real internal GenAI use case the demo should mirror?

Customer support, KYC document summarization, RAG over internal procedures, code/SQL copilot, fraud-narrative generation, complaint triage? Anything they would recognize as "yes, that is one of our apps"?

*Why it narrows scope:* the current SPEC uses a home-loan eligibility assistant as a plausible default; if they have a real internal use case we should swap the demo scenario and the example failure modes. Also tells us which custom scorer to build (e.g., "no personalized financial advice" vs "no PII leakage" vs "no off-policy commitment").

## 4. Which regulator or framework is the live pressure point right now?

EU AI Act (and which deadline — Feb 2025 prohibitions, Aug 2026 high-risk?), DORA, ACPR model-risk guidance, CNIL/GDPR, ECB SSM, internal model risk framework? Is there an active inspection or audit?

*Why it narrows scope:* Act III currently maps to EU AI Act + DORA by default. If their real pressure is, say, ACPR's model-risk circular or a CNIL audit on training data, we re-cut slides 13–14 to lead with that and demote the rest to one summary slide.

## 5. What decision or action are we trying to produce from this session?

Awareness only? Buy-in for a 90-day pilot? Technical alignment with a team already committed? Budget approval at a steering committee? A signed-off architecture for a specific app going to prod?

*Why it narrows scope:* the "Monday-morning plan" slide and the takeaways are written for a pilot pitch today. A budget-approval audience needs a sizing/cost slide; a technical-alignment audience needs a reference architecture slide instead; an awareness session can drop both and lean longer on the demo.
