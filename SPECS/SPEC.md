# SPEC — From Experiment Tracking to AI Observability (MLflow 3)

> Source of truth for the presentation `talk.typ` and the live demo under `demo/`. Aligned with the Databricks MLflow 3.0 launch narrative ("unified AI experimentation, observability, and governance"). Update this file before changing the deck.

## Meta

- **Title**: From Experiment Tracking to AI Observability
- **Subtitle**: MLflow 3 — unifying experimentation, observability, and governance for GenAI
- **Audience**: A top-tier French bank — ML engineers, MLOps, data scientists, model risk officers. Audience is **already familiar with MLflow 3 basics**; the talk must go beyond a feature tour and land an operating model.
- **Language**: English slides; FR-aware examples (e.g., "éligibilité prêt immobilier", "service client"). Speaker can present in either language.
- **Duration**: 45 min — 25 min presentation + 15 min live demo + 5 min Q&A.
- **Format**: Typst deck on `dbrx.typ`; demo in a Databricks EU workspace with a small GenAI app repo.
- **Deliverables**:
  1. `talk.typ` — the presentation
  2. `demo/` — runnable demo app + notebooks
  3. This SPEC kept up to date

## Source Alignment

The deck mirrors the Databricks framing from the MLflow 3.0 launch blog: **one platform spanning GenAI, classic ML, and deep learning**, organized around three pillars — **Experimentation, Observability, Governance** — and a **Continuous Improvement Cycle** that turns production signals back into better applications. Key terms we reuse verbatim so the audience recognizes them: *Production-Grade Tracing, LLM Judges, Review App, Prompt Registry, LoggedModel, Deployment Jobs, Quality Gates, Continuous Improvement Cycle*.

## Narrative Arc

The audience already knows the feature list — we earn their attention by showing the *shift in mental model* and the *bank-specific operating model*, not the API.

### Act I — The shift (5 min, ~4 slides)
Why MLflow had to grow from experiment tracker to AI lifecycle plane. The failure modes of GenAI apps (silent quality regressions, hallucinations on a KYC summary, prompt drift after a vendor model upgrade, cost spikes) are invisible to a classic experiment tracker. MLflow 3 reframes the unit of work from "run" to **application + version + trace + judgment**.

### Act II — The three pillars of MLflow 3 (12 min, ~7 slides)
Each pillar is presented with the **bank-relevant concern it answers**, not just the feature.

1. **Experimentation** — Prompt Registry (Git-style versioning, DSPy optimizer), LoggedModel as the unified artifact across GenAI/ML/DL, evaluation with LLM Judges + custom scorers, the Review App for expert annotation. Bank concern: reproducibility and defensible quality metrics.
2. **Observability** — Production-Grade Tracing on OpenTelemetry across 20+ GenAI libraries; spans for retriever, LLM, tool calls; inputs/outputs/latency/cost on every span; traces link back to exact code, prompt, and data. Bank concern: full audit trail per inference, root-cause in minutes not days, post-market monitoring.
3. **Governance** — Unity Catalog as the single governance plane for models, GenAI apps, prompts, and datasets; Deployment Jobs enforce Quality Gates and approval workflows before prod. Bank concern: separation of duties, regulator-defensible change control, model risk validation pack assembled automatically.

The act closes on the **Continuous Improvement Cycle** diagram: dev → trace → eval dataset → judge → deploy → trace → monitor → review → back to eval dataset.

### Act III — Operating model for a bank (8 min, ~5 slides)
- Mapping MLflow 3 artifacts onto **EU AI Act** obligations (Art. 12 logging, Art. 14 human oversight, Art. 17 quality management, Art. 72 post-market monitoring) and **DORA** ICT-incident reporting.
- Model Risk Management: how MLflow 3 feeds the bank's existing validation workflow (analogue to SR 11-7 / ACPR guidance) — the validation pack = experiment + traces + eval reports + Deployment Job approval trail.
- RACI: who owns prompts, who signs off evals, who is paged on a production scorer breach.
- Data residency and PII: Paris region, customer-managed keys, trace redaction strategies, what stays *out* of MLflow.

### Act IV — Demo (15 min)
French retail-bank customer-support assistant, end-to-end across all three pillars (see Demo Plan).

## Slide-by-slide Outline

| # | Slide function | Title | Key content |
|---|---|---|---|
| 1 | `title-slide` | From Experiment Tracking to AI Observability | Subtitle, speaker, date, bank logo placeholder |
| 2 | `content-slide` | Why this talk, given you already know MLflow 3 | Promise: an operating model and a bank-grade governance map — not a feature recap |
| 3 | `quote-slide` (red) | "A GenAI app fails silently. A classic model fails loudly." | Sets up the observability gap |
| 4 | `two-column-slide` | Classic ML vs GenAI failure modes | Left: accuracy drop, data drift, training-serving skew. Right: hallucination on KYC docs, prompt regression after vendor model upgrade, tool misuse, cost spike, silent quality drift |
| 5 | `section-slide-dark` (variant 1) | Act II — Three pillars, one platform | "Experimentation · Observability · Governance" |
| 6 | `card-slide` (3 cards) | MLflow 3 at a glance | Experimentation / Observability / Governance — one icon each (`dbrx-icon-ai`, `dbrx-icon-speed`, `dbrx-icon-data_warehouse`) |
| 7 | `content-slide` | Pillar 1 — Experimentation, now GenAI-native | Prompt Registry with Git-style diffs and DSPy optimizer; LoggedModel as the unified artifact; LLM Judges; Review App for expert annotation. Bank concern: reproducibility + defensible quality metrics |
| 8 | `content-slide` | Pillar 2 — Production-Grade Tracing | OpenTelemetry under the hood; autolog for 20+ libraries (LangChain, LangGraph, OpenAI, LlamaIndex…); span tree with retriever / LLM / tool spans; cost & latency attribution; trace → exact prompt + code + data. Bank concern: per-inference audit trail, fast RCA |
| 9 | `content-slide` | Pillar 3 — Governance via Unity Catalog | Models, GenAI apps, prompts, datasets all in UC; Deployment Jobs with Quality Gates and approvals. Bank concern: separation of duties, change control, validation pack |
| 10 | `dbrx-mermaid` in `freeform-slide` | The Continuous Improvement Cycle | dev → trace → eval dataset → judge → deploy → prod trace → monitor → label in Review App → back to eval dataset. Classes: `dbrxGray` (dev), `dbrxTeal` (eval), `dbrxRed` (prod), `dbrxGreen` (feedback edge) |
| 11 | `content-slide` | What this unlocks | Concrete capabilities from MLflow 3: trace-driven debugging of LLM chains, automatic eval-dataset creation from production traces, expert-aligned judges, dashboards with user-feedback integration |
| 12 | `section-slide-dark` (variant 2) | Act III — Operating model for a bank |  |
| 13 | `two-column-slide` | EU AI Act × MLflow 3 | Left: Art. 12 logging · Art. 14 human oversight · Art. 17 QMS · Art. 72 post-market monitoring. Right: tracing · Review App · Deployment Jobs / Quality Gates · production monitoring |
| 14 | `content-slide` | DORA & model risk management | ICT incident reporting from production traces; ACPR-style validation pack = run + traces + eval reports + Deployment Job approval trail, all in Unity Catalog |
| 15 | `board-slide` (3 columns) | RACI on a GenAI app | Data Scientist / MLOps / Model Risk Officer — cards: prompt versioning, eval suite ownership, scorer thresholds, Quality Gate sign-off, incident triage |
| 16 | `content-slide` | Data residency & PII | EU region, customer-managed keys, PII redaction at trace ingest, what stays out of MLflow (e.g., raw client identifiers) |
| 17 | `headline-slide` | Demo time | "Customer-support assistant for éligibilité prêt immobilier" |
| 18 | (live demo — no slide; optional `freeform-slide` with repo QR) |  |  |
| 19 | `takeaway-slide` (3 rows) | Take home | 1. Tracing is the new logging — instrument now. 2. Promote scorers, not just models. 3. Prompts are code — register, diff, gate them |
| 20 | `content-slide` | Monday-morning plan | 30/60/90-day pilot: instrument one app with tracing (30d) → build eval set + judges from prod traces (60d) → wire Deployment Jobs into the bank's existing change-management (90d) |
| 21 | `content-slide` + `dbrx-qr-code` | Resources & Q&A | Blog link, docs, demo repo QR, contact |

## Live Demo Plan

**Scenario**: a customer-support assistant for a French retail bank, answering questions about home-loan eligibility ("éligibilité prêt immobilier"). Small enough to fit in 15 min, realistic for the audience.

**Why this scenario**: it exposes *all three pillars* (prompts to version, traces to inspect, governance gate to cross) and it surfaces a regulator-relevant scorer ("no personalized financial advice") that maps cleanly to EU AI Act human-oversight discussion.

**Repo layout** (`demo/`):

```
demo/
  app.py                       # Gradio chat app; LLM + RAG over loan product docs (FR)
  prompts/
    loan_assistant.yaml        # versioned prompt, also pushed to Prompt Registry
  eval/
    golden.jsonl               # ~30 labeled Q&A pairs in French
    scorers.py                 # custom scorer: "refuses to give personalized financial advice"
  notebooks/
    01_trace_and_explore.py    # autolog + manual @mlflow.trace, inspect span tree
    02_register_prompt.py      # push v1 + v2 to Prompt Registry, set aliases
    03_evaluate.py             # mlflow.genai.evaluate with judges + custom scorer
    04_deployment_job.py       # Deployment Job with Quality Gate on the custom scorer
    05_monitor.py              # production monitor + Review App labeling round-trip
  README.md
```

**Live walkthrough (15 min, scripted with fallbacks)**:

| Min | Step | What audience sees | Pillar | Backup |
|---|---|---|---|---|
| 0–2 | Ask "Suis-je éligible à un prêt immobilier ?" in the app | Trace appears live with full span tree | Observability | Pre-recorded GIF |
| 2–4 | Drill into the trace: retriever span, LLM span, cost/latency attributes | Tabbing through spans, see linked prompt version | Observability | Screenshot fallback |
| 4–6 | Open Prompt Registry: `prod` alias on v1, v2 candidate with Git-style diff | Diff view side-by-side | Experimentation | Pre-published versions |
| 6–10 | `mlflow.genai.evaluate` golden set on v1 vs v2 with built-in judge + custom "no personalized advice" scorer | Eval report, scorer pass-rate per version | Experimentation | Pre-computed run |
| 10–12 | Trigger Deployment Job; Quality Gate blocks v2 because the custom scorer dropped; approver overrides with a note | Approval workflow on screen | Governance | Static screenshot |
| 12–14 | Production monitor view: scorers running on sampled prod traces; one alert; open the offending trace; label it in the Review App so it joins the next eval round | Closed loop demonstrated live | Observability + Experimentation | Pre-seeded alert |
| 14–15 | Flip back to slide 10 (Continuous Improvement Cycle) and recap |  | — | — |

**Demo prerequisites**:
- Databricks workspace (EU region) with MLflow 3 enabled and Unity Catalog
- Foundation Model API endpoint (or external Azure OpenAI through a UC connection)
- Pre-seeded prompt versions, eval run, and one alerting monitor so each step has a click-through fallback if live execution stalls

## Tone & Visual Guidance

- Audience is technical and skeptical — **no marketing slides**, no "AI is transforming everything" openers.
- Use the bank's product vocabulary (prêt immobilier, KYC, service client) — never generic chatbots.
- Mirror the Databricks blog's exact terms: *Experimentation, Observability, Governance*; *Production-Grade Tracing*; *LLM Judges*; *Review App*; *Prompt Registry*; *LoggedModel*; *Deployment Jobs*; *Quality Gates*; *Continuous Improvement Cycle*. The audience will recognize them.
- One secondary color per slide per `dbrx.typ` guidelines: `dbrx-teal` for governance/regulation slides, `dbrx-red` for failure modes, `dbrx-green` for the feedback edge in the cycle diagram.
- Every slide should pass the "would a model risk officer find this credible?" test.

## Open Questions (confirm with user)

1. Exact bank name and whether their logo/colors can appear on the title slide.
2. Slide language — English default, switch to French on request?
3. Demo environment — their EU workspace, or a Databricks-provided sandbox?
4. Regulator angle to emphasize — keep EU AI Act + DORA, or add ACPR / AMF / CNIL / ECB SSM explicitly?
5. Is this pitch-only, or followed by a hands-on lab the next day?

## Out of Scope

- MLflow 2 → 3 migration mechanics (audience already knows MLflow 3)
- Generic "what is GenAI" content
- Vendor comparison vs LangSmith / Arize / etc. — only if asked in Q&A
- Deep dive on Unity Catalog beyond its governance role for MLflow 3 artifacts (separate talk)
