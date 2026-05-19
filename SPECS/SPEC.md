# SPEC — From Experiment Tracking to AI Observability (MLflow 3 OSS)

> Source of truth for the presentation `mlflow3-day-in-the-life-of-a-data-scientist.typ`. Aligned with the MLflow 3.0 launch narrative ("unified AI experimentation, observability, and governance"), but **scoped to the open-source project**. Databricks-managed features are mentioned only where the audience would otherwise hit a gap. Update this file before changing the deck.

## Meta

- **Title**: From Experiment Tracking to AI Observability
- **Subtitle**: MLflow 3 OSS — unifying experimentation, observability, and governance for GenAI
- **Audience**: A top-tier French bank — ML engineers, MLOps, data scientists, model risk officers. Audience is **already familiar with MLflow 3 basics**; the talk must go beyond a feature tour and land an operating model.
- **Stance**: **Tech talk, not sales play.** Anchor every claim in the OSS project (`mlflow`, `mlflow-tracing`). Databricks is mentioned only in one explicit "what managed adds on top" slide and as a one-liner inside the Governance pillar — nowhere else.
- **Language**: English slides; FR-aware examples (e.g., "éligibilité prêt immobilier", "service client"). Speaker can present in either language.
- **Duration**: 45 min — ~40 min presentation + 5 min Q&A. No live demo.
- **Format**: Typst deck on `dbrx.typ`. The template is Databricks-branded (speaker is a Databricks SA), but slide *content* stays vendor-neutral on the technology.
- **Deliverables**:
  1. `mlflow3-day-in-the-life-of-a-data-scientist.typ` — the presentation
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

## Narrative Spine: Marc's Week

The deck has a protagonist. **Marc** is a data scientist at the bank — portrait at `assets/marc.png` (stylized, ~3:4 aspect, transparent background). Reuse the same image on every Marc slide (small inset, top-left or as a column figure) so the audience locks onto the character. He shipped a *prêt immobilier* eligibility assistant six months ago — it works, it's in production, real customers use it. Then he has a week.

| Day | What happens to Marc | What Marc has today | What he needs |
|---|---|---|---|
| **Monday** | A customer (Mme Dubois) is told the wrong DTI threshold. Marc gets paged. | A timestamp and a transcript fragment. | The exact prompt that ran, the docs the retriever pulled, what the LLM actually returned. |
| **Tuesday** | The LLM vendor silently pushed a model upgrade. Some answers got worse, some better. | Vibes. | A baseline to diff against and a version stamp on every prod call. |
| **Wednesday** | His PM asks "is it getting better since launch?" | Anecdotes and screenshots. | A defensible number, computed the same way every week. |
| **Thursday** | His Model Risk officer needs the validation pack before Friday's committee. | A Jupyter notebook and three screenshots. | A reproducible bundle: model version + traces + eval runs + sign-off log. |

**The talk is Marc's week, told twice.** First time (Act I): how it actually went. Second time (Acts II–III): the same week with MLflow 3 OSS — each pillar earns its slot by fixing one of Marc's days. The **Continuous Improvement Cycle** is Monday's incident becoming Tuesday's test case. The operating-model act is Marc + his MLOps peer + his MR officer, with RACI emerging naturally from the trio.

**Marc is not a strawman.** He is competent, well-intentioned, and using the best practices of MLflow 2 + a notebook-first workflow. His pains are structural, not personal. Every slide must pass the test: *"would I, in Marc's shoes, have been any better off?"* If the room hears "Marc was naive," the frame is broken.

## Narrative Arc

The audience already knows the feature list — we earn their attention by giving them a character to follow, and reframing the *shift in mental model* through his eyes.

### Act I — Marc's week, as it happened (8 min, ~5 slides)
Introduce Marc. Walk Monday through Thursday. Each day is one canonical GenAI-in-prod failure mode — silent incident, vendor drift, no quality signal, no audit evidence — recognizable to every practitioner in the room. Close the act with the diagnosis: classic MLflow + a notebook can't fix any of these, because the unit of work is wrong. MLflow 3 reframes it from "run" to **application + version + trace + judgment**, with **LoggedModel** as the new central abstraction.

### Act II — Marc's four answers (15 min, ~7 slides)
Each pillar of MLflow 3 OSS rescues one of Marc's days, and earns its slot accordingly.

1. **Monday — Observability.** Production-Grade Tracing on OpenTelemetry, packaged as the lightweight `mlflow-tracing` library; autolog across 20+ GenAI libraries (LangChain, LangGraph, OpenAI, LlamaIndex…); spans for retriever, LLM, tool calls; inputs/outputs/latency/cost on every span; **every trace bound to a LoggedModel version + Prompt version**. Marc reproduces Monday in five clicks.
2. **Tuesday — Experimentation (versioning).** Prompt Registry (Git-style versioning, DSPy optimizer), LoggedModel as the unified artifact across GenAI/ML/DL. Marc gets a version stamp on every prod call and a baseline to diff against; the next vendor upgrade is a Tuesday-morning notification, not a Monday-afternoon page.
3. **Wednesday — Experimentation (evaluation).** `mlflow.genai.evaluate` with LLM Judges + custom scorers (e.g. "no personalized financial advice"). Marc's PM gets a defensible number, computed the same way every week. *(Review App for expert annotation is Databricks-only; in OSS, Marc collects annotations via notebook workflows.)*
4. **Thursday — Governance, the OSS read.** What OSS gives Marc is *evidence*, not a workflow engine: versioned artifacts (LoggedModel, Prompt Registry), evaluation runs as first-class records, lineage across runs / prompts / datasets / traces. The validation pack assembles itself from primitives Marc already has. *(One line: managed Databricks adds Deployment Jobs, Quality Gates, and Unity Catalog — useful, not required to make MLflow 3 OSS regulator-defensible.)*

Four days, three pillars — Tuesday and Wednesday both sit under Experimentation (versioning vs evaluation). The act closes on the **Continuous Improvement Cycle** diagram: Marc's Monday incident becomes Tuesday's golden-set entry; production data is now Marc's roadmap.

### Act III — Marc's team and his bank (12 min, ~6 slides)
Marc isn't alone. He has an **MLOps peer** who owns the deployment pipeline and a **Model Risk officer** who wants evidence. The operating model is the trio.

- Mapping MLflow 3 **OSS** artifacts onto **EU AI Act** obligations (Art. 12 logging via tracing, Art. 14 human oversight via expert annotation workflows, Art. 17 QMS via versioned eval runs, Art. 72 post-market monitoring via sampled production tracing + re-evaluation) and **DORA** ICT-incident reporting.
- Model Risk Management: Marc's validation pack as the answer to SR 11-7 / ACPR-style guidance — LoggedModel version + traces + eval run + sign-off log, all reproducible.
- RACI: Marc / MLOps peer / MR officer — who owns prompts, who signs off evals, who is paged on a production scorer breach.
- Data residency and PII: where Marc hosts the tracking server, redaction at trace ingest, what stays *out* of MLflow.
- One explicit slide: **what Databricks-managed adds on top** — Review App, Deployment Jobs, Quality Gates, UC governance, online monitoring dashboards. Honest, brief, no pitch.

## Slide-by-slide Outline

| # | Slide function | Title | Key content |
|---|---|---|---|
| 1 | `title-slide` | From Experiment Tracking to AI Observability | Subtitle ("MLflow 3 OSS"), speaker, date, bank logo placeholder |
| 2 | `content-slide` | Meet Marc | Large portrait (`assets/marc.png`) left; right: Marc, data scientist at the bank; shipped a *prêt immobilier* eligibility assistant six months ago; works in his notebook, real customers use it. This talk is his week. *(Use `two-column-slide` if needed for the portrait+bio layout.)* |
| 3 | `quote-slide` (red) | "A GenAI app fails silently. A classic model fails loudly." | Sets up Marc's Monday |
| 4 | `two-column-slide` | Marc's week | Mon: Mme Dubois incident · Tue: vendor model upgrade · Wed: PM wants a number · Thu: MR validation pack due. Left col: the day. Right col: what Marc has (very little) |
| 5 | `content-slide` | Why this keeps happening to Marc | The unit of work is wrong: classic MLflow tracks "runs"; Marc needs **application + version + trace + judgment**. Enter LoggedModel as the new central abstraction |
| 6 | `section-slide-dark` (variant 1) | Act II — Marc's four answers | "Experimentation · Observability · Governance" |
| 7 | `card-slide` (3 cards) | MLflow 3 at a glance | Experimentation / Observability / Governance — one icon each (`dbrx-icon-ai`, `dbrx-icon-speed`, `dbrx-icon-data_warehouse`) |
| 8 | `content-slide` | Marc's Monday — Production-Grade Tracing | OpenTelemetry; `mlflow-tracing` lightweight package; autolog for 20+ libraries (LangChain, LangGraph, OpenAI, LlamaIndex…); span tree (retriever / LLM / tool); cost & latency on every span; trace ↔ LoggedModel version ↔ Prompt version. Marc reproduces Monday in five clicks |
| 9 | `content-slide` | Marc's Tuesday — versioned artifacts | Prompt Registry with Git-style diffs + DSPy optimizer; LoggedModel as unified artifact across GenAI/ML/DL; version stamp on every prod call catches vendor drift before users do |
| 10 | `content-slide` | Marc's Wednesday — defensible quality | `mlflow.genai.evaluate` with LLM Judges + custom scorers (e.g. "no personalized financial advice"); a number, computed the same way every week. One line: Review App is managed-only — in OSS, annotations through notebook workflows |
| 11 | `dbrx-mermaid` in `freeform-slide` | The Continuous Improvement Cycle | Marc's Monday incident → Tuesday's golden-set entry. dev → trace → eval dataset → judge → deploy → prod trace → annotate → back to eval dataset. Classes: `dbrxGray` (dev), `dbrxTeal` (eval), `dbrxRed` (prod), `dbrxGreen` (feedback edge) |
| 12 | `content-slide` | Marc's Thursday — the validation pack | What OSS gives Marc: LoggedModel version + traces + eval runs + lineage assemble into the MR pack; reproducible, dateable, queryable. One line: managed Databricks adds Deployment Jobs / Quality Gates / UC plane |
| 13 | `section-slide-dark` (variant 2) | Act III — Marc's team |  |
| 14 | `two-column-slide` | EU AI Act × Marc's stack | Left: Art. 12 logging · Art. 14 human oversight · Art. 17 QMS · Art. 72 post-market monitoring. Right: tracing · expert-annotation workflows · versioned eval runs · sampled prod tracing + re-eval |
| 15 | `content-slide` | DORA & model risk for Marc | ICT incident reporting from production traces; ACPR-style validation pack assembled from Marc's MLflow 3 OSS primitives = LoggedModel version + traces + eval run + sign-off log |
| 16 | `board-slide` (3 columns) | RACI: Marc, his MLOps peer, his MR officer | Three named roles: Data Scientist (Marc) / MLOps / Model Risk Officer — cards: prompt versioning, eval suite ownership, scorer thresholds, change-management sign-off, incident triage |
| 17 | `two-column-slide` | What Databricks-managed would add for Marc | Left (OSS, what Marc already has): tracking server, tracing, Prompt Registry, LoggedModel, LLM Judges, evaluate. Right (managed adds): Review App, Deployment Jobs, Quality Gates, UC governance, online monitoring dashboards. **One slide only** — neutral, factual, no pitch |
| 18 | `content-slide` | Data residency & PII | Self-hosting the tracking server, EU region, PII redaction at trace ingest, what stays *out* of MLflow (e.g., raw client identifiers). Applies equally to OSS and managed |
| 19 | `takeaway-slide` (3 rows) | What Marc has now that he didn't last week | 1. Tracing is the new logging — instrument now. 2. Promote scorers, not just models. 3. Prompts are code — register, diff, gate them |
| 20 | `content-slide` | Your Marc starts Monday | 30/60/90-day plan on **OSS**: instrument one app with `mlflow-tracing` (30d) → build eval set + judges from prod traces (60d) → wire Prompt Registry aliases into change-management (90d) |
| 21 | `content-slide` + `dbrx-qr-code` | Resources & Q&A | MLflow 3.0 launch blog, OSS docs, GitHub repo, contact |

## Tone & Visual Guidance

- **Marc is the protagonist.** He is competent and well-intentioned (see Narrative Spine). Every slide must pass the test *"would I, in Marc's shoes, have been any better off?"* — if it reads as "Marc was naive," rewrite it. Marc's name should appear in slide titles wherever the slide concerns one of his days, and his portrait (`assets/marc.png`) should appear as a small recurring visual anchor on those slides.
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
