# Q&A Prep — Anticipated audience questions on MLflow 3 OSS

> Speaker prep for the 5-minute Q&A after the talk. Questions are written the way a technical / model-risk bank audience would actually phrase them. Each answer is short and defensible; speaker notes flag where to qualify, deflect, or say "I'll get back to you."
>
> Skim time: ~90 seconds before going on. Sorted by the order questions typically come in: scope → ops → eval → governance → ecosystem.

## A. Architecture & OSS scope

### A1. "What's actually in OSS vs Databricks-only? I want a clear line."
**A.** OSS: Production-Grade Tracing (`mlflow-tracing`), LoggedModel, Prompt Registry, LLM Judges, `mlflow.genai.evaluate`, the tracking server itself. Databricks-only: Review App (no-code annotation UI), Deployment Jobs, Quality Gates, Unity Catalog as governance plane, online monitoring dashboards. The pillars in this talk all work on pure OSS; everything Databricks adds is a *workflow layer* on top, not a precondition. *(See slide 17.)*

**Speaker note**: this question always comes. Don't bluff — point to slide 17 and the table in the SPEC.

### A2. "How does `mlflow-tracing` relate to the main `mlflow` package?"
**A.** It's a lightweight standalone package designed for production apps that don't want to pull the full MLflow dependency tree. You get autolog + span emission + trace export, without the experiment-tracking heavy machinery. You can run it in your prod containers and ship traces to a remote tracking server.

### A3. "What's the storage backend for the tracking server? Can we point it at Postgres?"
**A.** Yes — the OSS tracking server supports a SQL backend (Postgres, MySQL, SQLite) for metadata and a configurable artifact store for blobs (S3, Azure Blob, GCS, local FS). For a bank in EU, you'd typically run a Postgres in the EU region with an S3-compatible artifact store. HA is standard Postgres HA — MLflow is stateless.

### A4. "Is OpenTelemetry mandatory? We already run Jaeger / Datadog."
**A.** Tracing is built on OpenTelemetry, so spans are interoperable. You can dual-export — keep sending your OTel spans to Jaeger or Datadog *and* to MLflow, or just bridge from your existing collector into MLflow's trace store. MLflow doesn't force its own protocol.

**Speaker note**: if pressed on exact exporter configuration, defer — "happy to dig into your specific setup after."

### A5. "Migration from MLflow 2 to 3 — is it breaking?"
**A.** Tracking-server upgrade is in-place; existing runs and models stay. New constructs (LoggedModel, Prompt Registry, traces) are additive — you don't *have* to use them. The mental-model shift (run → application+version+trace+judgment) is bigger than the API shift.

## B. Tracing in production

### B1. "What's the latency overhead per LLM call?"
**A.** Span emission is async — typically sub-millisecond on the hot path because spans are buffered and flushed on a background thread. The actual cost is in serializing prompt/completion text into span attributes; for very large prompts you may want truncation. Compared to the LLM call latency (hundreds of ms to seconds), it's noise.

**Speaker note**: don't quote specific numbers — they'll vary by setup. "Sub-ms on the hot path, dominated by serialization for huge prompts."

### B2. "Cost — how much storage per trace? Per million inferences?"
**A.** Depends on prompt and response size. Rule of thumb: a small RAG trace (one retrieval + one LLM call) is on the order of 10-50 KB of JSON. At a million inferences/month with 50 KB each that's ~50 GB/month before compression — trivial on S3. The cost is in *retaining* traces for regulatory periods, which is a retention-policy question, not a tracing-cost question.

### B3. "Can we sample 1% of production traces instead of all of them?"
**A.** Yes — OTel sampling primitives apply. You can do tail-based or head-based sampling, and you can stratify (always sample errors, sample 1% of successes). For regulator-defensible logs, you typically want 100% of inferences logged with truncated content + 100% sampling on a subset where you keep full content.

### B4. "PII in traces — how do we redact safely?"
**A.** Two layers. First, span attribute processors at the OTel level — Presidio or a custom regex pipeline runs *before* the span is exported. Second, what you choose to put into span attributes in the first place (e.g., log retrieved document IDs, not full doc bodies). Slide 18 lists what stays in vs out of MLflow.

**Speaker note**: this question gets follow-ups about RIB/IBAN. The honest answer: "you write the redactor; MLflow gives you the hook."

### B5. "What if the tracking server is down — does our prod app fail?"
**A.** No — tracing is fire-and-forget through an OTel collector. If the collector or server is down, spans queue locally and back off; the app keeps serving. You lose observability for the outage window, not service.

## C. Evaluation & LLM Judges

### C1. "LLM Judges use other LLMs. Which one? Can we plug in our own?"
**A.** Judges are configurable — you point them at any LLM endpoint (OpenAI, Anthropic, your own Foundation Model API, a self-hosted Llama). The OSS ships with research-backed prompts for built-in judges (correctness, groundedness, safety…), and you can write custom judges in Python that wrap your own LLM call.

### C2. "Judges are non-deterministic. How do you trust them for regulator-facing eval?"
**A.** Three answers. (1) Use deterministic settings — temperature 0, fixed model version. (2) Run each judgment N times and report the distribution, not a single point. (3) Most importantly, *align* the judge to human labels — sample of expert annotations becomes the ground truth, and you measure the judge's agreement rate (Cohen's kappa) before relying on it. An unaligned judge is a vibes machine; an aligned judge with a reported agreement rate is evidence.

**Speaker note**: this is the deepest pillar-2 question. Have a one-liner ready: *"a judge without an alignment report is just another LLM call."*

### C3. "Cost of running judges over a large eval set?"
**A.** Each judgment is an LLM call. For an eval set of 1000 examples × 3 judges × 2 model versions, that's 6000 LLM calls per eval run. At ~$0.001-0.01 per call depending on model, that's $6-60 per full eval run. Cheaper than a single bad-prompt prod outage.

### C4. "Custom scorers — what does the API look like? Can a plain Python function be a scorer?"
**A.** Yes — a scorer is a Python callable that takes the input/output (and optionally the trace) and returns a score. No LLM required; it can be regex, a constraint checker, a classifier, anything. The "no personalized financial advice" example in the deck is a regex + small classifier, not a judge.

### C5. "How do you compare two prompt versions statistically?"
**A.** Built-in is per-scorer pass-rate per version, plus a delta. For real statistical rigor (p-values, effect sizes) you'd post-process the eval-run records — they're stored as queryable rows, not opaque blobs. Bootstrap CIs on pass-rate differences is the usual move.

## D. Prompt Registry

### D1. "Why a Prompt Registry — why not just put prompts in Git?"
**A.** Three reasons OSS Prompt Registry exists *alongside* Git, not instead of. (1) Aliases like `prod` / `candidate` decouple "what's deployed" from "what's committed." (2) The registry binds prompt versions to LoggedModel versions and traces — so when you read a prod trace, you see *exactly* which prompt version ran. (3) DSPy and other optimizers write prompts programmatically; the registry is where those generated prompts land with full provenance. Git is still source of truth for the prompt *file*; the registry is the runtime binding.

### D2. "Where are prompt versions stored — same DB as runs?"
**A.** Yes, the tracking server's metadata DB. They're versioned with diff-able content. Backups and migrations are the same as runs.

### D3. "DSPy optimizer — who owns the prompts after it's done?"
**A.** The optimizer produces a new prompt version, pushed to the registry with an alias like `dspy-candidate`. A human still reviews and promotes it to `prod` via your change-management. The optimizer's output is a candidate, not a release.

## E. Governance, audit, EU AI Act

### E1. "Can MLflow 3 OSS be the system of record for EU AI Act Art. 12 logs?"
**A.** Mechanically, yes — traces are timestamped, immutable in the artifact store, bound to a specific LoggedModel version. Legally, that's a determination your model-risk and legal functions make, not a vendor. The artifacts are *fit for the purpose*; declaring them the system of record is a policy decision your bank owns.

**Speaker note**: this is the right answer. Don't promise compliance — promise primitives.

### E2. "Retention policy — does MLflow ship with built-in TTL?"
**A.** Not as a single dial. You configure retention on the artifact store (S3 lifecycle policies are typical) and on the metadata DB via scheduled deletes. For regulator-facing retention (often 5-10 years), this becomes a storage architecture question.

### E3. "Can a regulator query the store directly? What's the schema?"
**A.** Yes — the metadata DB is plain SQL. Tables for runs, models, traces, prompts, evaluations are documented and queryable. An auditor with read-only DB credentials can run `SELECT` against the validation-pack rows. This is one of the strongest arguments for OSS: the regulator can see how data is structured without depending on a vendor's UI.

### E4. "Does MLflow 3 OSS sign artifacts cryptographically?"
**A.** Not in core. You'd bolt on signing as part of your deployment pipeline (sign the LoggedModel artifact + eval report at promotion time, store the signature alongside). For non-repudiation grade, this is a wrap-around discipline, not an MLflow feature.

**Speaker note**: this is the honest answer. Don't claim it does what it doesn't.

### E5. "Validation pack format — is there a standard export?"
**A.** No fixed standard. The pack is a *bundle of artifacts* — LoggedModel version + traces + eval run + sign-off — each with its own format. Most banks build a thin exporter (Python script that pulls the relevant rows + artifacts into a single zip or PDF). MLflow gives you the queryable primitives; the bundle is yours to shape.

### E6. "RBAC on the tracking server?"
**A.** OSS tracking server has basic auth and a permissions model (experiment-level). Fine-grained RBAC (per-prompt, per-scorer) is typically done by putting MLflow behind your IdP via a reverse proxy or using a Databricks-managed deployment. For a regulated bank, expect to wire it into your SSO/OIDC.

## F. Self-hosting & SRE

### F1. "Tracking server HA — what does production look like?"
**A.** MLflow tracking server is stateless. HA is: multiple replicas behind a load balancer, shared Postgres backend, shared object store. Standard 12-factor. Postgres HA is the only stateful piece.

### F2. "Multi-tenancy — can different teams share one server with isolation?"
**A.** Experiments are the unit of isolation in OSS. Combined with the auth/proxy layer for RBAC, teams can share infra without seeing each other's runs. For stronger isolation (separate DBs per team), run separate tracking-server instances.

### F3. "Schema migrations between MLflow versions — anything to watch out for?"
**A.** MLflow ships Alembic-style migration scripts and a `mlflow db upgrade` command. We've not hit breaking schema changes between minor versions in 2.x; 2 → 3 is bigger but in-place. The honest advice: pin your version in prod, test the upgrade in staging.

## G. Comparisons & ecosystem

### G1. "How does this compare to LangSmith / Arize / Phoenix?"
**A.** Out of scope for this session — happy to do that comparison offline. The short version: LangSmith is LangChain-tight and proprietary; Phoenix is OSS but observability-only (no Prompt Registry, no eval-as-records integrated with traces); Arize is observability + ML monitoring with strong drift detection. MLflow 3's bet is *one platform across the lifecycle*, OSS, and an existing on-prem footprint at most banks.

**Speaker note**: this *will* come up. Stay neutral, refuse to bash. Out-of-scope deflection is OK.

### G2. "Why MLflow over OpenLLMetry?"
**A.** OpenLLMetry is a tracing instrumentation library — it's a building block, and in fact some of the MLflow autolog code is OpenTelemetry-based. They're not competitors; they're stack layers. MLflow consumes OpenTelemetry-format spans and adds the lifecycle layer (versioning, eval, prompts).

### G3. "Can it coexist with our existing Grafana / Jaeger?"
**A.** Yes — dual-export OTel spans. You keep your existing dashboards for low-latency ops monitoring; MLflow adds the version-bound trace store for eval and audit purposes.

## H. Adoption & effort

### H1. "How much engineering time for the 30/60/90 plan?"
**A.** Realistic numbers for one app: ~1 engineer-week to instrument tracing on a clean LangChain/LangGraph app (more for a homegrown stack); ~2 engineer-weeks to build a 200-example golden set + 3 scorers + one aligned judge; ~1-2 weeks to wire Prompt Registry aliases into existing CI/CD. So roughly 1 engineer for one quarter to land all three.

**Speaker note**: caveat heavily on the homegrown-stack number — could be much more.

### H2. "When does managed pay for itself vs OSS?"
**A.** Honest answer: when the Review App and Deployment Jobs would save you building the same workflows in-house, *and* when UC is already your governance plane for data. If you have neither, OSS is fine. If you already run UC across your data estate, the integration tax of *not* using managed gets real.

**Speaker note**: keep this neutral. This is a tech talk, not a managed pitch.

## I. Honest unknowns — say "I'll get back to you"

These are questions where the speaker should *not* bluff. Take notes, follow up.

- Specific perf benchmarks on autolog overhead for *your* stack (depends on integrations)
- Exact list of supported autolog libraries at the version they're running (changes monthly)
- Specific roadmap items for managed-only features ("when will X land in OSS?")
- Specific Databricks pricing
- Any commitment about EU AI Act *compliance certification* — MLflow gives primitives, not a stamp
- Detailed Postgres / S3 sizing for *their* trace volume (need their inference rate first)

---

## How to use this file

- Read top to bottom once the day before the talk
- Skim section headers + bold-leads the morning of
- During Q&A, if a question maps to a section, *answer in 30 seconds max* and offer to follow up offline if they want depth — don't burn the room's time on one questioner
- If a question is in §I (Honest unknowns), say so. The audience trusts speakers who admit uncertainty more than ones who improvise.
