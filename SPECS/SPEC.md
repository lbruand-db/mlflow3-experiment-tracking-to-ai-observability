# SPEC — From Experiment Tracking to AI Observability (MLflow 3 OSS)

> Source of truth for the presentation `talk.typ`. Aligned with the MLflow 3.0 launch narrative ("unified AI experimentation, observability, and governance"), but **scoped to the open-source project**. Databricks-managed features are mentioned only where the audience would otherwise hit a gap. Update this file before changing the deck.

## Meta

- **Title**: From Experiment Tracking to AI Observability
- **Subtitle**: MLflow 3 OSS — unifying experimentation, observability, and governance for GenAI
- **Audience**: A top-tier French bank — ML engineers, MLOps, data scientists, model risk officers. Audience is **already familiar with MLflow 3 basics**; the talk must go beyond a feature tour and land an operating model.
- **Stance**: **Tech talk, not sales play.** Anchor every claim in the OSS project (`mlflow`, `mlflow-tracing`). Databricks is mentioned only in one explicit "what managed adds on top" slide and as a one-liner inside the Governance pillar — nowhere else.
- **Language**: English slides; FR-aware examples (e.g., "éligibilité prêt immobilier", "service client"). Speaker can present in either language.
- **Duration**: 45 min — ~40 min presentation + 5 min Q&A. No live demo.
- **Format**: Typst deck on `dbrx.typ`. The template is Databricks-branded (speaker is a Databricks SA), but slide *content* stays vendor-neutral on the technology.
- **Deliverables**:
  1. `talk.typ` — the presentation
  2. This SPEC kept up to date

## Source Alignment

The deck mirrors the MLflow 3.0 launch framing: **one platform spanning GenAI, classic ML, and deep learning**, organized around three pillars — **Experimentation, Observability, Governance** — and a **Continuous Improvement Cycle** that turns production signals back into better applications. Terms we reuse verbatim because the audience will recognize them: *Production-Grade Tracing, LLM Judges, Prompt Registry, LoggedModel, Continuous Improvement Cycle*.

### OSS vs managed — feature map (used throughout the deck)

| Feature | OSS MLflow 3 | Databricks-managed only |
|---|---|---|
| Production-Grade Tracing (OpenTelemetry, `mlflow-tracing`, 20+ autolog integrations) | ✅ | — |
| LoggedModel (unified artifact across GenAI / ML / DL) | ✅ | — |
| Prompt Registry (Git-style versioning, diffs, DSPy optimizer) | ✅ | — |
| LLM Judges + `mlflow.genai.evaluate` + custom scorers | ✅ | — |
| Version tracking binding traces ↔ code ↔ prompt ↔ dataset | ✅ | — |
| Review App (no-code expert annotation UI) | — | ✅ |
| Deployment Jobs + Quality Gates | — | ✅ |
| Unity Catalog as governance plane for models / prompts / apps / datasets | — | ✅ |
| Online monitoring dashboards (AI/BI integration) | — | ✅ |

When a slide describes a managed-only capability, say so explicitly and offer the OSS analogue (e.g., "in OSS you wire this into your own CI/CD").

## Narrative Arc

The audience already knows the feature list — we earn their attention by showing the *shift in mental model* and the *bank-specific operating model*, not the API.

### Act I — The shift (5 min, ~4 slides)
Why MLflow had to grow from experiment tracker to AI lifecycle plane. The failure modes of GenAI apps (silent quality regressions, hallucinations on a KYC summary, prompt drift after a vendor model upgrade, cost spikes) are invisible to a classic experiment tracker. MLflow 3 reframes the unit of work from "run" to **application + version + trace + judgment**, with **LoggedModel** as the new central abstraction.

### Act II — The three pillars of MLflow 3 OSS (15 min, ~7 slides)
Each pillar is presented with the **bank-relevant concern it answers**, grounded in OSS APIs.

1. **Experimentation** — Prompt Registry (Git-style versioning, DSPy optimizer), LoggedModel as the unified artifact across GenAI/ML/DL, evaluation with LLM Judges + custom scorers via `mlflow.genai.evaluate`. Bank concern: reproducibility and defensible quality metrics. *(Note: the Review App for expert annotation is Databricks-only; in OSS you collect annotations through your own tooling or notebook workflows.)*
2. **Observability** — Production-Grade Tracing on OpenTelemetry, packaged as the lightweight `mlflow-tracing` library; autolog across 20+ GenAI libraries (LangChain, LangGraph, OpenAI, LlamaIndex…); spans for retriever, LLM, tool calls; inputs/outputs/latency/cost on every span; **every trace bound to a LoggedModel version + Prompt version**. Bank concern: full audit trail per inference, root-cause in minutes not days, post-market monitoring.
3. **Governance (the OSS read)** — What OSS gives you is *evidence*, not a workflow engine: versioned artifacts (LoggedModel, Prompt Registry), evaluation runs as first-class records, lineage across runs / prompts / datasets / traces. You wire those artifacts into your existing change-management. *(One line: managed Databricks adds Deployment Jobs, Quality Gates, and Unity Catalog as the governance plane — useful, but not required to make MLflow 3 OSS regulator-defensible.)*

The act closes on the **Continuous Improvement Cycle** diagram: dev → trace → eval dataset → judge → deploy → prod trace → annotate/review → back to eval dataset.

### Act III — Operating model for a bank (15 min, ~7 slides)
- Mapping MLflow 3 **OSS** artifacts onto **EU AI Act** obligations (Art. 12 logging via tracing, Art. 14 human oversight via expert annotation workflows, Art. 17 QMS via versioned eval runs, Art. 72 post-market monitoring via sampled production tracing + re-evaluation) and **DORA** ICT-incident reporting.
- Model Risk Management: the validation pack assembled from OSS primitives = LoggedModel version + traces + eval run + your own sign-off log. Analogue to SR 11-7 / ACPR guidance.
- RACI: who owns prompts, who signs off evals, who is paged on a production scorer breach.
- Data residency and PII: where you host the tracking server, redaction strategies at trace ingest, what stays *out* of MLflow.
- One explicit slide: **what Databricks-managed adds on top** — Review App, Deployment Jobs, Quality Gates, UC governance, online monitoring dashboards. Honest, brief, no pitch.

## Slide-by-slide Outline

| # | Slide function | Title | Key content |
|---|---|---|---|
| 1 | `title-slide` | From Experiment Tracking to AI Observability | Subtitle ("MLflow 3 OSS"), speaker, date, bank logo placeholder |
| 2 | `content-slide` | Why this talk, given you already know MLflow 3 | Promise: an operating model and a bank-grade governance map for **OSS MLflow 3** — not a feature recap, not a managed-platform pitch |
| 3 | `quote-slide` (red) | "A GenAI app fails silently. A classic model fails loudly." | Sets up the observability gap |
| 4 | `two-column-slide` | Classic ML vs GenAI failure modes | Left: accuracy drop, data drift, training-serving skew. Right: hallucination on KYC docs, prompt regression after vendor model upgrade, tool misuse, cost spike, silent quality drift |
| 5 | `content-slide` | The unit of work has changed | run → **application + version + trace + judgment**; introduce LoggedModel as the new central abstraction; trace ↔ version binding |
| 6 | `section-slide-dark` (variant 1) | Act II — Three pillars, one platform | "Experimentation · Observability · Governance" |
| 7 | `card-slide` (3 cards) | MLflow 3 at a glance | Experimentation / Observability / Governance — one icon each (`dbrx-icon-ai`, `dbrx-icon-speed`, `dbrx-icon-data_warehouse`) |
| 8 | `content-slide` | Pillar 1 — Experimentation, now GenAI-native | Prompt Registry with Git-style diffs + DSPy optimizer; LoggedModel as the unified artifact; `mlflow.genai.evaluate` with LLM Judges + custom scorers. One line: Review App for expert annotation is managed-only. Bank concern: reproducibility + defensible quality metrics |
| 9 | `content-slide` | Pillar 2 — Production-Grade Tracing | OpenTelemetry under the hood; `mlflow-tracing` lightweight package; autolog for 20+ libraries; span tree with retriever / LLM / tool spans; cost & latency attribution; trace → exact prompt + code + dataset. Bank concern: per-inference audit trail, fast RCA |
| 10 | `content-slide` | Pillar 3 — Governance via versioned artifacts | What OSS gives you: every trace bound to a LoggedModel version + Prompt version; eval runs as first-class records; lineage you can hand to an auditor. Wire into *your* change management. One line: managed Databricks adds Deployment Jobs / Quality Gates / UC plane |
| 11 | `dbrx-mermaid` in `freeform-slide` | The Continuous Improvement Cycle | dev → trace → eval dataset → judge → deploy → prod trace → annotate → back to eval dataset. Classes: `dbrxGray` (dev), `dbrxTeal` (eval), `dbrxRed` (prod), `dbrxGreen` (feedback edge) |
| 12 | `content-slide` | What this unlocks (OSS, today) | Trace-driven debugging of LLM chains; automatic eval-dataset creation from production traces; expert-aligned judges via human-labeled examples; cost & latency dashboards from trace data |
| 13 | `section-slide-dark` (variant 2) | Act III — Operating model for a bank |  |
| 14 | `two-column-slide` | EU AI Act × MLflow 3 OSS | Left: Art. 12 logging · Art. 14 human oversight · Art. 17 QMS · Art. 72 post-market monitoring. Right: tracing · expert-annotation workflows · versioned eval runs · sampled prod tracing + re-eval |
| 15 | `content-slide` | DORA & model risk management | ICT incident reporting from production traces; ACPR-style validation pack assembled from OSS primitives = LoggedModel version + traces + eval run + your own sign-off log |
| 16 | `board-slide` (3 columns) | RACI on a GenAI app | Data Scientist / MLOps / Model Risk Officer — cards: prompt versioning, eval suite ownership, scorer thresholds, change-management sign-off, incident triage |
| 17 | `two-column-slide` | What managed Databricks adds on top | Left (OSS, what you already have): tracking server, tracing, Prompt Registry, LoggedModel, LLM Judges, evaluate. Right (managed adds): Review App, Deployment Jobs, Quality Gates, UC governance, online monitoring dashboards. **One slide only** — neutral, factual, no pitch |
| 18 | `content-slide` | Data residency & PII | Self-hosting the tracking server, EU region, PII redaction at trace ingest, what stays *out* of MLflow (e.g., raw client identifiers). Applies equally to OSS and managed |
| 19 | `takeaway-slide` (3 rows) | Take home | 1. Tracing is the new logging — instrument now. 2. Promote scorers, not just models. 3. Prompts are code — register, diff, gate them |
| 20 | `content-slide` | Monday-morning plan | 30/60/90-day pilot on **OSS**: instrument one app with `mlflow-tracing` (30d) → build eval set + judges from prod traces (60d) → wire Prompt Registry aliases into the bank's existing change-management (90d) |
| 21 | `content-slide` + `dbrx-qr-code` | Resources & Q&A | MLflow 3.0 launch blog, OSS docs, GitHub repo, contact |

## Tone & Visual Guidance

- Audience is technical and skeptical — **no marketing slides**, no "AI is transforming everything" openers, **no Databricks pitch**.
- Default framing for every feature: "this is in OSS MLflow 3." If a feature is managed-only, say so explicitly and offer the OSS analogue.
- Use the bank's product vocabulary (prêt immobilier, KYC, service client) — never generic chatbots.
- Mirror the MLflow 3.0 launch terms exactly: *Experimentation, Observability, Governance*; *Production-Grade Tracing*; *LLM Judges*; *Prompt Registry*; *LoggedModel*; *Continuous Improvement Cycle*.
- One secondary color per slide per `dbrx.typ` guidelines: `dbrx-teal` for governance/regulation slides, `dbrx-red` for failure modes, `dbrx-green` for the feedback edge in the cycle diagram.
- Every slide should pass the "would a model risk officer find this credible?" test **and** the "is this still true if I rip out the Databricks layer?" test (except slide 17, which is explicitly about the managed layer).

## Open Questions (confirm with user)

1. Exact bank name and whether their logo/colors can appear on the title slide.
2. Slide language — English default, switch to French on request?
3. Regulator angle to emphasize — keep EU AI Act + DORA, or add ACPR / AMF / CNIL / ECB SSM explicitly?
4. Is this pitch-only, or followed by a hands-on lab the next day?
5. Slide 17 ("what managed adds on top") — keep, or drop entirely if the room is explicitly OSS-only and any Databricks mention is unwelcome?

## Out of Scope

- MLflow 2 → 3 migration mechanics (audience already knows MLflow 3)
- Generic "what is GenAI" content
- Vendor comparison vs LangSmith / Arize / etc. — only if asked in Q&A
- Live demo — out of scope for this 45-min slot
- Deep dive on Unity Catalog or any Databricks-managed surface beyond the one acknowledgement slide (slide 17)
