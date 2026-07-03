# Sephora Pre-Screen — Complete 1-Day Prep Guide

**Call:** Sunday, June 15, 2026, 3:00 PM EDT  
**Duration:** 30 minutes via Zoom  
**With:** Meg Galloway, Talent Partner  
**Role:** Senior Engineer, Marketing Technology (288017)  
**Zoom:** https://sephora.zoom.us/j/91024829676 | Passcode: 452831

---

## Part 1: Pre-Call Reading (30 min) — Read This First

### What This Role Actually Is

**Marketing data infrastructure at enterprise scale, GCP-first, with an AI/ML overlay.**

Sephora is building the data backbone for its marketing technology stack. The role covers:
- **Batch + real-time data pipelines** — ingesting raw data into a Data Lake, ETL development
- **Marketing campaign enablement** — cross-functional data delivery to marketing teams via GCP/GMP
- **Cross-cloud integration** — GCP as primary, Azure as secondary
- **AI augmented engineering** — they explicitly call out GitHub Copilot, Claude Code, and prompt engineering as valued skills
- **ML exposure** — regression, classification, clustering; applying MLaaS to marketing use cases

**Why this matters for you:** Your config-driven PySpark framework, 800+ pipeline ownership, CDC-to-Kafka work, and Informatica ETL background are all directly named in their JD. This is not a stretch role — your profile is a strong match on the core data engineering competencies.

### The Stack Gap (and How to Bridge It)

**Their stack:** GCP, GMP (Google Marketing Platform), BigQuery, Informatica (named as a plus), Azure  
**Your stack:** PySpark, Kafka, Oracle, MySQL, Hadoop/Hive, Informatica, AWS

**Your bridge — say this naturally, not defensively:**

> "My cloud work has been AWS-centric, but the architectural patterns are the same — distributed compute, columnar storage, event-driven ingestion. I've worked with Informatica PowerCenter extensively and I'm familiar with BigQuery's columnar model. I'd expect a short ramp on GCP-specific tooling, but the foundational concepts I apply daily transfer directly."

**On the ML/AI angle:** You don't need to be a data scientist. The JD describes applying MLaaS and knowing when to use these tools — not building models from scratch. Your experience building pipelines that feed analytical and ML workflows is the right framing.

> "I haven't built production ML models myself, but I've built the infrastructure that enables them — reliable, low-latency pipelines feeding downstream data science teams. I'm familiar with the MLaaS model conceptually and have used AI-augmented tools like Claude for engineering productivity."

---

## Part 2: Your 60-Second Background Pitch

**Practice this until it feels natural — NOT robotic. Aim for 55-65 seconds.**

---

### **Version A: If Meg says "Tell me about yourself"**

> I'm a Senior Data Engineer with nine-plus years of experience, currently at Susquehanna International Group — a quantitative trading firm where I build data infrastructure at scale. I own over 800 automated production pipelines and led the modernization from legacy Informatica toward event-driven, streaming-first architecture using PySpark and Kafka. I built a config-driven PySpark framework that reduced operational overhead by 75% and runtime by 50%. My stack is Python, PySpark, SQL, Hadoop, Hive, Kafka, Oracle, MySQL, and AWS. I have a master's in Information Systems from GWU and AWS Data Engineer Associate certification. Before SIG, I spent three years at Apple as an ETL consultant embedded with their data warehouse team. I'm relocating to the Bay Area and looking for my next senior IC role — and Sephora's marketing data platform is exactly the kind of infrastructure and scale I want to work on.

**Tone:** Confident, metrics-anchored, specific. End on the "why Sephora" hook.

---

### **Version B: If she asks "Walk me through your background"** (slightly shorter)

> Nine-plus years as a Senior Data Engineer, currently at Susquehanna where I own 800+ production pipelines. I've focused on modernizing legacy Informatica infrastructure toward streaming and config-driven PySpark frameworks — reduced ops overhead by 75%, led a CDC-to-Kafka migration, and performed a zero-downtime Hadoop cluster upgrade. Stack is Python, PySpark, SQL, Kafka, Hadoop, AWS. Master's from GWU, AWS certified, three years before that embedded with Apple's data warehouse team at Infosys. Relocating to the Bay Area, and this role is a strong fit for where I want to go next.

---

## Part 3: Pre-Staged Answers to Expected Questions

### **1. "Why are you looking to move?"**

**What she's really asking:** Is this a thoughtful transition, or are you fleeing something?

> I'm relocating to the Bay Area — my wife works at Cisco, and we've decided it makes sense to consolidate on the West Coast. I've been at Susquehanna for over six years, which has been incredibly valuable, but I feel ready for a new chapter. I'm looking for senior IC roles where the data infrastructure work has real business impact — and marketing technology at a company like Sephora, where data directly drives customer decisions, is exactly what I'm targeting.

**Keys:**
- Lead with relocation (positive, real reason)
- No SIG negativity
- Connect "new chapter" to Sephora specifically

---

### **2. "Why Sephora?"**

**What she's really asking:** Did you apply everywhere, or is there something real here?

> A few things stand out. One, the scope — marketing technology at Sephora means data infrastructure that directly enables customer campaigns at scale, which is a meaningful shift from financial services data. Two, the JD is honest about the stack — GCP, real-time ingestion, ETL, cross-cloud — and that maps well to what I've built at SIG. And three, Sephora's emphasis on AI-augmented engineering and building scalable, config-driven systems is exactly how I've operated. I use tools like Claude and GitHub Copilot in my day-to-day already.

**Keys:**
- Specific to the role (not generic "great brand")
- Show you read the JD carefully
- Mention AI-augmented angle — it's explicitly in their JD and it differentiates you

---

### **3. "Tell me about your experience with ETL and data pipelines."**

**This is your core story. Pick ONE angle and go 2-3 minutes deep.**

#### **Option A: Config-Driven Framework** (Best for this role — directly mirrors their ETL focus)

> When I joined SIG, we had a large legacy Informatica PowerCenter footprint — high operational overhead, vendor lock-in, hard to scale. Over six years I led a modernization strategy. The centerpiece was a config-driven PySpark framework that lets us onboard new data sources entirely through parameter configuration — zero code changes. That reduced operational overhead by 75% and cut pipeline runtime by 50%. We now ingest from Oracle, MySQL, and other sources through the same framework. What I'm proud of is that it's self-service — a new data source can be onboarded in hours, not sprints. That's the kind of infrastructure Sephora's marketing data stack sounds like it needs: reliable, low-touch, scalable.

#### **Option B: Real-Time / CDC** (If she asks about streaming or real-time marketing data)

> At SIG we process millions of financial transactions daily in near real time. I designed a CDC-to-Kafka system that captures change events from Oracle and MySQL databases and distributes them to downstream consumers in real time. The key challenges were ordering guarantees, schema evolution, and fault tolerance across heterogeneous consumers. That streaming backbone reduced our data latency significantly and enabled downstream use cases we couldn't support on batch-only architecture. For a marketing platform — where campaign timing and personalization depend on fresh data — that kind of streaming foundation is exactly what I'd want to build.

#### **Option C: Informatica Specifically** (If she asks about Informatica experience — it's named in their JD)

> I have extensive hands-on experience with Informatica PowerCenter — it was the primary ETL tool when I joined SIG. I've designed and maintained complex mappings, workflows, and sessions, and I understand its strengths for enterprise batch ETL. I've also led the strategic migration away from it toward open-source and cloud-native tooling, so I understand both its value and its limitations. If Sephora is using Informatica as part of their stack, I can hit the ground running.

---

### **4. "What's your experience with GCP or cloud platforms?"**

> My primary cloud experience is AWS — I'm AWS Data Engineer Associate certified — but the architectural patterns transfer directly. Distributed compute, object storage, columnar warehousing, managed streaming — I've worked with the AWS equivalents of BigQuery, Dataflow, and Pub/Sub. I'd expect a ramp on GCP-specific tooling and GMP specifics, but the foundational thinking is the same. I'm a fast learner with new platforms; the Hadoop-to-AWS transition at SIG was a similar ramp and I was contributing at full capacity within weeks.

---

### **5. "What do you know about our marketing tech stack or GMP?"**

**Honest but forward-leaning:**

> I've done my research on GCP's marketing stack — GMP brings together Campaign Manager, Display & Video 360, and Search Ads 360 into an integrated data layer, and BigQuery is the analytics backbone. I don't have production GMP experience, but I understand its role in marketing attribution and campaign measurement, and the data engineering patterns — ingesting impression/click/conversion events, building audience segments, measuring lift — are similar to data workflows I've built in financial services. I'm confident I'd ramp quickly with exposure to your specific implementation.

---

### **6. "Tell me about your experience with AI or ML tools."**

> Two angles here. On the infrastructure side, I've built the data pipelines that feed downstream ML and analytics workflows — reliable ingestion, schema management, low-latency delivery. On the tooling side, I actively use AI-augmented development tools in my day-to-day — Claude and GitHub Copilot — for code generation, debugging, and documentation. I've found that defining reusable prompts and shared context significantly improves output quality and consistency, which seems to be exactly what your JD describes. I'm not a model-builder, but I understand the MLaaS paradigm and have delivered data infrastructure that enables it.

---

### **7. "Where else are you in process?"**

> I'm in active conversations with a couple of Bay Area data engineering teams — one in fintech, one in tech. I'm moving through those processes relatively quickly. I'm being selective about where I go next, and Sephora is genuinely in my top tier because of the marketing tech angle and the GCP-first stack.

**Keys:**
- Don't name other companies
- "Top tier" creates urgency without desperation
- "Being selective" signals you have options

---

### **8. "What are your comp expectations?"**

**Sephora Senior Engineer, Bay Area market:**
- Base: $160K - $200K
- Bonus: 10-15%
- Total: ~$185K - $235K

**Your response:**

> I'm calibrating against the Bay Area market and would love to understand what the band is for this level first. I'm targeting total comp in the $185 to $230K range, with flexibility depending on the full package. Happy to share my current comp if that helps as a baseline.

**If she asks your current comp:**

> At SIG I'm in the $160-170K base range — it's a Philly market. Bay Area is a meaningful step up in cost of living, so I'm looking for a comp increase that reflects that.

---

## Part 4: Questions to Ask Meg (Pick 2-3)

**Strategy:** Ask things you actually want the answer to, not to sound impressive.

### **#1: Team and Scope** (Most important)

> "Can you tell me more about the data engineering team within marketing technology — how big is it, and is this a greenfield build or joining an existing platform?"

**Why:** Tells you whether you're architecting from scratch or inheriting a codebase.

---

### **#2: What's Driving This Hire**

> "What's driving this particular hire right now — is it expansion, a new initiative, or backfill?"

**Why:** Expansion/new initiative = growth opportunity. Backfill = need to understand why.

---

### **#3: Interview Process**

> "What does the process look like beyond this call? How many rounds, what are the focus areas, and what's a typical timeline?"

**Why:** Helps you plan and shows you're serious.

---

### **#4: Visa Sponsorship / H1B Transfer** (Raise this early — don't let it surface later)

> "One thing I want to be transparent about upfront — I'm currently on an H1B at SIG, and I'd need a transfer for any new role. I wanted to raise this early so there are no surprises. Is that something Sephora supports for strong candidates?"

**Why:** Better to address it now than after a technical round. Most companies at this level do support H1B transfers. If they don't, you save everyone's time.

---

### **#5: Location and Onsite Expectations**

> "What are the onsite expectations for this role — is there a set number of days per week, and is there flexibility for someone who's in the process of relocating?"

**Why:** You need this for your own planning.

---

## Part 5: The Visa Conversation — Handle It Confidently

This is the single most important tactical moment in the call. Don't wait for her to ask — bring it up yourself under your questions section. It signals honesty and seniority.

**The framing that works:**

> "Before I ask my questions, I want to be transparent about one thing — I'm currently on an H1B visa at SIG. My I-140 is approved, which simplifies the transfer process significantly, but I did want to flag it early. Is that something your legal and HR teams are comfortable with?"

**If she hedges:** "I understand it adds a step. I'd say my I-140 approval and the strength of my background at SIG make this more straightforward than a new H1B cap case. Happy to provide any documentation you'd need to evaluate."

**Keys:**
- Approved I-140 is your ace — mention it explicitly
- Calm and factual tone, not apologetic
- Don't over-explain

---

## Part 6: During the Call — Checklist

| Moment | What to Do |
|---|---|
| **Meg joins** | Smile, warm greeting, "Thanks for making time" |
| **She introduces herself** | Listen, write down her role and any context she shares |
| **"Tell me about yourself"** | Use Version A pitch (55-65 sec) |
| **Any pipeline/ETL question** | Use a specific SIG story with metrics |
| **She talks about Sephora/the team** | Listen, take notes, absorb language clues |
| **Ask your questions** | Pick 2-3 from Part 4, including visa one |
| **She pitches next steps** | Listen and confirm what's expected |
| **Wrapping up** | Confirm process and timeline, thank her warmly |

---

## Part 7: After the Call

### **Thank-You Email** (send within 2 hours — she's ET, you're ET, same day works)

**Subject:** Thank you — Senior Engineer, Marketing Technology

> Hello Meg,
>
> Thank you for the time today. I really appreciated learning more about the marketing technology team and the data infrastructure work Sephora is building on GCP. The scope of the role — batch and real-time ingestion, ETL at scale, cross-cloud integrations — maps closely to what I've been doing at SIG, and I left the call more interested than before.
>
> Looking forward to the next steps.
>
> Krishna Upadhyaya

**Keys:**
- One specific detail (GCP, batch + real-time)
- "More interested than before" = genuine signal
- Short — she has 20 more calls today

---

## Part 8: Red Flags — What NOT to Do

❌ **Don't:**
- Badmouth Susquehanna or financial services culture
- Name other companies you're interviewing with
- Lead with compensation (she'll ask)
- Be defensive about the AWS vs GCP gap — bridge it confidently
- Over-explain the visa situation — state it once, clearly, move on
- Ask deep technical questions about Sephora's architecture (save for the hiring manager)

✅ **Do:**
- Be specific with metrics (75% overhead reduction, 800+ pipelines, 50% runtime reduction)
- Show genuine interest in the marketing tech / customer data angle — it's different from fintech
- Mention AI-augmented engineering naturally — it's in their JD and it's true
- Raise the visa question yourself — don't wait
- Keep answers to 90 seconds unless she's clearly digging deeper

---

## Part 9: Quick Reference Cards (Screenshot or Print)

### **Card 1: 60-Second Pitch** (memorize cold)

> 9+ years Senior Data Engineer at SIG. Own 800+ production pipelines. Built config-driven PySpark framework — 75% ops reduction, 50% runtime reduction. Led CDC-to-Kafka modernization and zero-downtime Hadoop migration. Stack: Python, PySpark, SQL, Kafka, Hadoop, Informatica, AWS. Master's GWU, AWS certified. Relocating to Bay Area.

---

### **Card 2: Why Sephora**

> Marketing data at consumer scale + GCP-first stack + AI-augmented engineering focus = strong fit. Data directly drives customer decisions — more tangible impact than financial services pipelines.

---

### **Card 3: My Top Stories** (pick based on what she asks)

1. **Config-driven PySpark framework** — 75% ops reduction, zero-code onboarding
2. **CDC-to-Kafka modernization** — real-time streaming, fault tolerance, latency reduction
3. **Hadoop cluster migration** — zero downtime, 2.6 to 3.1, columnar + partition pruning
4. **Informatica PowerCenter** — extensive hands-on + strategic migration away from it
5. **Operational excellence** — 800+ pipelines, runbooks, 70% faster incident resolution

---

### **Card 4: Questions to Ask**

1. Team structure and scope (greenfield vs existing?)
2. What's driving this hire
3. Interview process and timeline
4. H1B transfer — raise it yourself
5. Onsite expectations and relocation flexibility

---

### **Card 5: Red Flags Checklist**

- ✅ Don't badmouth SIG
- ✅ Don't name other companies
- ✅ Don't be defensive about GCP gap — bridge it
- ✅ Raise the visa question yourself
- ✅ Mention AI tools (Claude, Copilot) — it's in their JD
- ✅ Lead with metrics every time

---

## Timeline: Sunday June 15 Prep Schedule

| Time | Activity | Duration |
|---|---|---|
| 9:00 AM | Read this guide Parts 1-4 | 30 min |
| 9:30 AM | Practice 60-sec pitch out loud — record yourself | 15 min |
| 9:45 AM | Review JD + your resume side by side | 15 min |
| 10:00 AM | Pick one core story and rehearse it out loud | 15 min |
| 10:15 AM | Break — go for a walk, decompress | 60 min |
| 11:15 AM | Read Parts 5-6 (during the call + red flags) | 15 min |
| 11:30 AM | Lunch, decompress — don't cram more | 90 min |
| 1:00 PM | Re-read Quick Reference Cards only | 10 min |
| 1:10 PM | Free time — don't prep more | until 2:50 PM |
| 2:50 PM | Set up Zoom, open resume PDF, open JD tab, close Slack/email | 10 min |
| 2:58 PM | Join Zoom 2 minutes early, smile, settle in | 2 min |
| 3:00 PM | **CALL STARTS** | 30 min |
| 3:30 PM | **CALL ENDS** — send thank-you email within 2 hours | — |

---

## Final Notes

### **Tone for This Call**

- **Warm + confident.** You have 9+ years and 800+ pipelines. You've done this.
- **Specific + humble.** Deep technical background, but not arrogant about it.
- **Interested + not desperate.** Sephora is in your top tier — but you have other conversations in motion.

### **Energy Level**

- You're WFH — smile while speaking, it changes your voice
- Take that walk at 10:15 AM — it matters
- Have water nearby
- Don't slouch on camera, even at home

### **If You Get Stuck**

1. Pause 1-2 seconds — it signals you're thinking, not blanking
2. Say something true, even "Let me make sure I answer that specifically"
3. Give a SIG example with a metric if possible
4. If you're unsure what she's asking: "Are you asking more about X or Y?"

---

## Done.

This is a **vibe check and logistics conversation**, not a technical assessment. Meg wants to confirm:

1. You're real, senior, and serious
2. Your background maps to the role
3. Logistics (relocation, timeline, visa, comp) aren't blockers

You're a strong match on the core competencies. The GCP gap is bridgeable. The visa situation is manageable with your I-140. The AI tools angle is a genuine differentiator.

**Go in confident. Be specific. Raise the visa question yourself. Send the thank-you the same afternoon.**

Good luck — debrief after if you want.
