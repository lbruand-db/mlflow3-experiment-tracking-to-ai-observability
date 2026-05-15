// ==========================================================================
// From Experiment Tracking to AI Observability — MLflow 3 OSS
// A tech talk for a French bank, told as Marc's week.
// See SPECS/SPEC.md for the canonical outline.
// ==========================================================================

#import "dbrx.typ": *
#import "@preview/cetz:0.4.2": canvas, draw

#show: dbrx-presentation.with(
  title: "From Experiment Tracking to AI Observability",
  author: "Lucas Bruand",
  subject: "MLflow 3 OSS — unifying experimentation, observability, and governance for GenAI",
)

// Custom slide layout for Marc's "day" slides: title left, Marc portrait
// top-right as a recurring visual anchor, bullet content below.
#let marc-day-slide(title: none, body) = {
  freeform-slide()[
    #place(top + left, dx: margin-x, dy: margin-top,
      block(width: 25cm,
        text(size: 40pt, fill: dbrx-dark-navy, title)))
    #place(top + right, dx: -margin-x, dy: 0.5cm,
      image("assets/marc.png", height: 3.3cm))
    #place(top + left, dx: margin-x, dy: 4.6cm,
      block(width: 31.3cm, height: 12.5cm)[
        #set text(size: 26pt, fill: dbrx-charcoal)
        #set list(marker: text(fill: dbrx-charcoal, sym.bullet),
                  indent: 0.6cm, body-indent: 0.4cm, spacing: 0.6em)
        #body
      ])
  ]
}

// --- Slide 1: Title ---
#title-slide(
  title: [From Experiment Tracking to AI Observability],
  subtitle: [MLflow 3 OSS — unifying experimentation, observability, and governance for GenAI],
  author: [Lucas Bruand],
  date: [May 2026],
)

// --- Slide 2: Meet Marc ---
#two-column-slide(
  title: [Meet Marc],
)[
  #align(center + horizon, image("assets/marc.png", height: 13cm))
][
  #v(1.5cm)
  #set text(size: 24pt, fill: dbrx-charcoal)
  Marc is a data scientist at the bank.

  #v(0.4cm)
  Six months ago he shipped a #emph[prêt immobilier] eligibility assistant.

  #v(0.4cm)
  It works in his notebook. Real customers use it.

  #v(0.8cm)
  #text(fill: dbrx-dark-teal, size: 26pt)[This talk is his week.]
]

// --- Slide 3: Quote ---
#quote-slide(
  quote: [A GenAI app fails silently. A classic model fails loudly.],
  bg: "red",
)

// --- Slide 4: Marc's week ---
#two-column-slide(
  title: [Marc's week],
  left-heading: [The day],
  right-heading: [What Marc has],
)[
  - *Monday* — Mme Dubois is told the wrong DTI threshold
  - *Tuesday* — the LLM vendor pushed a silent model upgrade
  - *Wednesday* — his PM asks "is it getting better?"
  - *Thursday* — his MR officer wants the validation pack
][
  - A timestamp and a transcript fragment
  - Vibes
  - Anecdotes and screenshots
  - A Jupyter notebook and three screenshots
]

// --- Slide 5: Why this keeps happening to Marc ---
#content-slide(title: [Why this keeps happening to Marc])[
  Classic MLflow tracks #emph[runs].

  #v(0.4cm)
  Marc needs to track:
  - the *application*
  - its *version*
  - every *trace*
  - and the *judgment* on each output

  #v(0.4cm)
  Enter *LoggedModel* — the new central abstraction in MLflow 3.
]

// --- Slide 6: Act II — section divider ---
#section-slide-dark(
  title: [Act II — Marc's four answers],
  variant: 1,
)

// --- Slide 7: MLflow 3 at a glance ---
#card-slide(
  title: [MLflow 3 at a glance],
  cards: (
    (
      icon: "assets/dbrx-icon-ai.svg",
      heading: [Experimentation],
      body: [Prompt Registry, LoggedModel, LLM Judges, `mlflow.genai.evaluate`. Reproducible, defensible quality.],
      label: [Versioning + evaluation],
    ),
    (
      icon: "assets/dbrx-icon-speed.svg",
      heading: [Observability],
      body: [Production-Grade Tracing on OpenTelemetry. Autolog 20+ libraries. Every trace bound to a version.],
      label: [Per-inference audit trail],
    ),
    (
      icon: "assets/dbrx-icon-data_warehouse.svg",
      heading: [Governance],
      body: [Versioned artifacts + lineage = evidence. Wire into your own change management.],
      label: [Regulator-defensible],
    ),
  ),
)

// --- Slide 8: Marc's Monday — Production-Grade Tracing ---
#marc-day-slide(title: [Marc's Monday — Production-Grade Tracing])[
  - OpenTelemetry under the hood; lightweight `mlflow-tracing` package
  - Autolog for 20+ libraries: LangChain, LangGraph, OpenAI, LlamaIndex, ...
  - Span tree: retriever · LLM · tool calls
  - Inputs, outputs, latency, cost on every span
  - Every trace bound to *LoggedModel version + Prompt version*

  #v(0.4cm)
  #text(fill: dbrx-dark-teal)[Marc reproduces Monday in five clicks.]
]

// --- Slide 9: Marc's Tuesday — versioned artifacts ---
#marc-day-slide(title: [Marc's Tuesday — versioned artifacts])[
  - *Prompt Registry* — Git-style versioning, diffs, aliases, DSPy optimizer
  - *LoggedModel* — unified artifact across GenAI / ML / DL
  - Version stamp on every prod call
  - Diffs make vendor drift visible the moment it happens

  #v(0.4cm)
  #text(fill: dbrx-dark-teal)[The next vendor upgrade is a Tuesday-morning notification, not a Monday-afternoon page.]
]

// --- Slide 10: Marc's Wednesday — defensible quality ---
#marc-day-slide(title: [Marc's Wednesday — defensible quality])[
  - `mlflow.genai.evaluate` over a golden set
  - *LLM Judges* — research-backed, customizable
  - *Custom scorers* — e.g. "no personalized financial advice"
  - Pass-rate per version, comparable across runs

  #v(0.3cm)
  #text(fill: dbrx-dark-teal)[Marc's PM gets a number, computed the same way every week.]

  #v(0.2cm)
  #text(size: 18pt, fill: dbrx-teal)[Review App for expert annotation is managed-only; in OSS, annotations through notebook workflows.]
]

// --- Slide 11: The Continuous Improvement Cycle ---
// Drawn with cetz so the loop-back from Annotate -> Eval is visibly a cycle.
#freeform-slide()[
  #place(top + left, dx: margin-x, dy: margin-top,
    block(width: 31.3cm,
      text(size: 40pt, fill: dbrx-dark-navy)[The Continuous Improvement Cycle]))

  #place(top + left, dx: margin-x, dy: 3.4cm,
    block(width: 31.3cm,
      text(size: 20pt, fill: dbrx-dark-teal)[Marc's Monday incident becomes Tuesday's golden-set entry.]))

  #place(top + left, dx: 0cm, dy: 4.6cm,
    block(width: slide-width, height: 13cm)[
      #set align(center + horizon)
      #canvas(length: 1cm, {
        import draw: *

        let r = 5.2
        let node-half-w = 1.9
        let node-half-h = 0.55

        // (label, angle deg from +x axis, fill, text-color)
        let nodes = (
          ("Develop",    90,  dbrx-light-gray, dbrx-charcoal),
          ("Eval set",   30,  dbrx-teal,       white),
          ("LLM Judge", -30,  dbrx-dark-teal,  white),
          ("Deploy",    -90,  dbrx-dark-navy,  white),
          ("Prod trace",-150, dbrx-red,        white),
          ("Annotate",   150, dbrx-green,      white),
        )

        // Positions (x, y) for each node center
        let pos = nodes.map(n => {
          let theta = n.at(1) * calc.pi / 180.0
          (r * calc.cos(theta), r * calc.sin(theta))
        })

        // Edge from node i center toward node j center, shortened so the
        // arrowhead sits just outside the target rectangle.
        let arrow(i, j, color, thickness) = {
          let (x1, y1) = pos.at(i)
          let (x2, y2) = pos.at(j)
          let dx = x2 - x1
          let dy = y2 - y1
          let dist = calc.sqrt(dx * dx + dy * dy)
          // shrink by ~node radius on each side
          let shrink = 2.0
          let f1 = shrink / dist
          let f2 = (dist - shrink) / dist
          let sx = x1 + dx * f1
          let sy = y1 + dy * f1
          let ex = x1 + dx * f2
          let ey = y1 + dy * f2
          line(
            (sx, sy),
            (ex, ey),
            mark: (end: "stealth", scale: 1.4),
            stroke: (paint: color, thickness: thickness),
          )
        }

        // Draw arrows (clockwise: 0->1->2->3->4->5->0)
        // Index 5 -> 0 is "Annotate -> Develop", but the SPEC feedback edge
        // is "Annotate -> Eval set" (5 -> 1). Wire that explicitly in green.
        arrow(0, 1, dbrx-charcoal, 1.5pt)  // Develop -> Eval set
        arrow(1, 2, dbrx-charcoal, 1.5pt)  // Eval set -> LLM Judge
        arrow(2, 3, dbrx-charcoal, 1.5pt)  // LLM Judge -> Deploy
        arrow(3, 4, dbrx-charcoal, 1.5pt)  // Deploy -> Prod trace
        arrow(4, 5, dbrx-charcoal, 1.5pt)  // Prod trace -> Annotate
        arrow(5, 1, dbrx-green,    3pt)    // Annotate -> Eval set (feedback)

        // Draw nodes on top of arrows
        for (i, n) in nodes.enumerate() {
          let (label, _, fill, txt) = n
          let (x, y) = pos.at(i)
          rect(
            (x - node-half-w, y - node-half-h),
            (x + node-half-w, y + node-half-h),
            fill: fill,
            stroke: fill,
            radius: 0.18,
          )
          content((x, y), text(size: 12pt, fill: txt)[#label])
        }

        // "feedback" label on the green chord
        let (fx1, fy1) = pos.at(5)
        let (fx2, fy2) = pos.at(1)
        content(
          ((fx1 + fx2) / 2, (fy1 + fy2) / 2 + 0.45),
          text(size: 11pt, fill: dbrx-green)[#emph[feedback]],
        )
      })
    ])
]

// --- Slide 12: Marc's Thursday — the validation pack ---
#marc-day-slide(title: [Marc's Thursday — the validation pack])[
  What OSS gives Marc — the bundle he hands to MR:
  - *LoggedModel version* + every checkpoint behind it
  - *Traces* — every prod inference, span by span
  - *Eval runs* — judges, scorers, pass-rates, dated
  - *Lineage* — code · prompt · dataset · run

  #v(0.3cm)
  #text(fill: dbrx-dark-teal)[Reproducible. Dateable. Queryable.]

  #v(0.2cm)
  #text(size: 18pt, fill: dbrx-teal)[Managed Databricks adds Deployment Jobs, Quality Gates, and Unity Catalog as the governance plane — useful, not required.]
]

// --- Slide 13: Act III — section divider ---
#section-slide-dark(
  title: [Act III — Marc's team],
  variant: 2,
)

// --- Slide 14: EU AI Act × Marc's stack ---
#two-column-slide(
  title: [EU AI Act × Marc's stack],
  left-heading: [The obligation],
  right-heading: [What Marc uses],
)[
  - *Art. 12* — automatic logging
  - *Art. 14* — human oversight
  - *Art. 17* — quality management system
  - *Art. 72* — post-market monitoring
][
  - Production-Grade Tracing
  - Annotation workflows over sampled traces
  - Versioned eval runs + custom scorers
  - Sampled prod tracing + re-evaluation
]

// --- Slide 15: DORA & model risk for Marc ---
#content-slide(title: [DORA & model risk for Marc])[
  - *DORA* — ICT incident reports drawn directly from production traces
  - *SR 11-7 / ACPR* — Marc's validation pack:
    - LoggedModel version + every checkpoint
    - Traces + spans on every prod inference
    - Eval runs with judges + custom scorers
    - Marc's own sign-off log

  #v(0.3cm)
  Assembled from primitives that exist in OSS today.
]

// --- Slide 16: RACI ---
#board-slide(
  title: [RACI: Marc, his MLOps peer, his MR officer],
  columns: (
    (heading: [Data Scientist], color: dbrx-teal, items: (
      [Owns prompts and prompt versions],
      [Builds the eval set + scorers],
      [Triages quality alerts],
      [Drives root-cause from traces],
    )),
    (heading: [MLOps peer], color: dbrx-dark-teal, items: (
      [Owns the deployment pipeline],
      [Wires Prompt Registry to CI/CD],
      [Paged on prod incidents],
      [Operates the tracking server],
    )),
    (heading: [Model Risk Officer], color: dbrx-crimson, items: (
      [Signs off scorer thresholds],
      [Reviews validation pack],
      [Approves changes to prod],
      [Owns DORA / EU AI Act mapping],
    )),
  ),
)

// --- Slide 17: What Databricks-managed would add for Marc ---
#two-column-slide(
  title: [What Databricks-managed would add for Marc],
  left-heading: [What Marc has in OSS],
  right-heading: [What managed adds],
)[
  - Tracking server (self-hosted)
  - Production-Grade Tracing
  - Prompt Registry
  - LoggedModel
  - LLM Judges + `mlflow.genai.evaluate`
][
  - Review App (no-code annotation UI)
  - Deployment Jobs
  - Quality Gates
  - Unity Catalog as governance plane
  - Online monitoring dashboards
]

// --- Slide 18: Data residency & PII ---
#content-slide(title: [Data residency & PII])[
  - Self-host the tracking server in the EU region
  - PII redaction at trace ingest (hooks on span attributes)
  - What stays *out* of MLflow: raw client identifiers, KYC PDFs
  - What goes *in*: redacted prompts, retrieved doc IDs, scorer outputs

  #v(0.4cm)
  Applies equally to OSS and managed.
]

// --- Slide 19: Take home ---
#takeaway-slide(
  title: [What Marc has now that he didn't last week],
  items: (
    (
      heading: [Tracing is the new logging — instrument now],
      body: [Every prod inference produces a span tree bound to a version. No more guessing what ran.],
      color: dbrx-red,
    ),
    (
      heading: [Promote scorers, not just models],
      body: [Behaviour is what regulators inspect. Encode "no personalized advice" as a scorer; gate releases on it.],
      color: dbrx-dark-teal,
    ),
    (
      heading: [Prompts are code — register, diff, gate them],
      body: [The Prompt Registry treats prompts the way Git treats source. Marc's vendor-drift Tuesday becomes a notification.],
      color: dbrx-dark-navy,
    ),
  ),
)

// --- Slide 20: Monday-morning plan ---
#content-slide(title: [Your Marc starts Monday])[
  #set text(size: 22pt)
  *30 days* — instrument one app with `mlflow-tracing`
  - Pick the highest-risk GenAI surface (KYC, advisory, complaint triage)
  - Autolog traces; bind every call to a LoggedModel version
  - Publish the first trace dashboard

  #v(0.3cm)
  *60 days* — build the eval set and judges from prod traces
  - Sample prod traces; label a golden set
  - Write 2–3 custom scorers (at least one regulator-defensible)
  - Make `mlflow.genai.evaluate` a CI check

  #v(0.3cm)
  *90 days* — wire Prompt Registry into change management
  - Aliases (`prod`, `candidate`); promotion via existing approval workflow
  - Validation pack assembled at every promotion
]

// --- Slide 21: Resources & Q&A ---
#content-slide(title: [Resources & Q&A])[
  #grid(
    columns: (1fr, auto),
    column-gutter: 2cm,
    align: (left + horizon, center + horizon),
    [
      #text(size: 22pt, fill: dbrx-dark-navy)[MLflow 3 OSS]
      #v(0.6cm)
      #set text(size: 18pt)
      - Launch blog — #text(fill: dbrx-teal)[databricks.com/blog/mlflow-30-...]
      - Docs — #text(fill: dbrx-teal)[mlflow.org/docs/latest]
      - GitHub — #text(fill: dbrx-teal)[github.com/mlflow/mlflow]

      #v(0.8cm)
      #text(size: 20pt, fill: dbrx-charcoal)[Lucas Bruand · lucas.bruand\@databricks.com]
    ],
    [
      #dbrx-qr-code("https://mlflow.org/docs/latest/")
      #v(0.3cm)
      #text(size: 12pt, fill: dbrx-charcoal)[Scan for OSS docs]
    ],
  )
]
