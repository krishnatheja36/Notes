# Credit Karma (Intuit) Recruiter Intro Call — Complete 1-Day Prep Guide

**Call:** Thursday, May 14, 2026, 2:30 PM PT (5:30 PM ET) with Boris Arsh  
**Duration:** 30 minutes via Zoom  
**Referral:** Nischith  
**Role:** Data Engineer, Oakland (Experimentation Platform / Internal Data Engineering)

---

## Part 1: Pre-Call Reading (30 min) — Read This First

### What This Role Actually Is

**Internal data engineering + platform engineering at consumer scale.**

Credit Karma is building the data infrastructure that Intuit/Credit Karma uses internally. The role emphasizes:
- **Software engineering applied to data** — "reliable, testable, maintainable"
- **Experimentation platform** — A/B testing infrastructure supporting PMs and data scientists
- **Platform & service development** — not just pipelines, but products

**Why this matters for you:** Your config-driven framework, 800+ pipeline ownership, and CDC-to-Kafka modernization are **directly relevant**. This is the same shape of work you've been doing at SIG.

### The Stack Gap (and How to Bridge It)

**Their stack:** Google Dataflow, BigQuery, Airflow/Composer (GCP's managed Airflow)  
**Your stack:** Spark, Hadoop, Kafka, Oracle, AWS

**Your bridge (say naturally, not defensive):**
> "I have AWS Data Engineer Associate and have worked extensively with the AWS analogs of these services — Spark is to Dataflow what Hadoop/Hive is to BigQuery from an architecture standpoint. The patterns are the same: distributed compute, columnar storage, partitioning strategy, resource management. I'd expect a short ramp on GCP-specific tooling, but the foundational concepts translate directly."

This shows senior judgment + architectural depth + confidence.

---

## Part 2: Your 60-Second Background Pitch

**Practice this until it feels natural — NOT robotic. Aim for 55-65 seconds.**

---

### **Version A: Neutral Opening (If Boris says "Tell me about yourself")**

> I'm a Senior Data Engineer with nine plus years of experience, currently at Susquehanna International Group — a quantitative trading firm where I've built data infrastructure at scale. I own over 800 automated production pipelines and led the modernization from legacy Informatica toward event-driven, streaming-first architecture. I built a config-driven PySpark framework that cut operational overhead by 75% and runtime by 50%. I also led a zero-downtime Hadoop cluster migration and designed a CDC-to-Kafka streaming system during a major platform overhaul. My stack is Python, PySpark, SQL, Hadoop, Hive, Kafka, Oracle, and AWS. I have a master's in Information Systems from GWU and AWS Data Engineer Associate certification. Before SIG, I spent three years at Apple as an ETL consultant embedded with their data warehouse team.

**Tone:** Confident, metrics-anchored, specific.

---

### **Version B: If He Asks "What's Your Background?"** (Slightly shorter)

> Nine plus years as a Senior Data Engineer, currently at Susquehanna where I own 800+ production pipelines. I've focused on modernizing legacy infrastructure toward streaming and lakehouse architectures — built a config-driven PySpark framework that reduced ops overhead by 75%, led a CDC-to-Kafka migration, and performed a zero-downtime Hadoop cluster upgrade. My stack is Python, PySpark, SQL, Kafka, Hadoop, AWS. Master's from GWU, AWS Certified Data Engineer Associate, three years before that embedded with Apple's data warehouse team at Infosys.

**Tone:** More direct, slightly faster.

---

## Part 3: Pre-Staged Answers to Expected Questions

### **1. "Why are you looking to move?"**

**What they're really asking:** Are you fleeing a bad situation, or is this a intentional career move?

> I'm relocating to the Bay Area — my wife is at Cisco, and we've decided it makes sense to consolidate on the West Coast. I've been at Susquehanna for over six years, which has been incredibly valuable, but I feel ready for a new chapter. I'm looking for senior IC roles at companies with serious data infrastructure scale, where the work has real impact.

**Keys:**
- Lead with location (positive reason)
- No SIG negativity
- Emphasize "ready for new chapter" not "got bored"
- Mention scale/impact as your bar

**If he digs:** "What specifically are you looking for in the next role?"

> Senior individual contributor work where I own data systems end-to-end. I want to be deep in architecture and modernization — designing systems for scale, reliability, and operational simplicity. Experimentation platforms are interesting because they're foundational infrastructure that enables the rest of the company to move faster.

---

### **2. "Why Credit Karma specifically?"**

**What they're really asking:** Did you just apply everywhere, or is there something real here?

> Credit Karma operates at serious consumer scale with a complex data footprint, and your role description hit two things I care about: one, experimentation platform work — that's exactly the kind of foundational data engineering I want to be doing. Two, applying software engineering rigor to data systems, which is how I've always operated. And honestly, the Nischith referral mattered — he gave me confidence that the team and culture are real, not just the resume on paper.

**Keys:**
- Specific to the role (experimentation platform)
- Show you read the JD
- Reference Nischith legitimately (don't overdo it)
- No generic "I'm excited to be here"

---

### **3. "Tell me about your experience at Susquehanna."**

**This is your story. You have depth here. Pick ONE angle and go 2-3 minutes deep.**

#### **Option A: Infrastructure Modernization** (Best angle for platform role)

> When I joined SIG, we had a large legacy Informatica PowerCenter footprint — high operational overhead, vendor lock-in, difficult to scale. Over six years, I championed a modernization strategy: first, I built a config-driven PySpark framework that let us ingest new data sources with parameter files only, zero code changes. That cut operational overhead by 75% and let us onboard new data much faster. Second, I led a CDC-to-Kafka migration during a major initiative — decoupling producers from consumers, improving fault tolerance, reducing infrastructure costs. Third, I led a zero-downtime migration from Hadoop 2.6 to 3.1 — implemented columnar storage, partition pruning, which gave us measurable gains in query performance and storage efficiency. The theme was: moving from manual, high-touch infrastructure to automated, event-driven, self-service systems. I own 800+ pipelines now, and that volume is sustainable only because of these platform improvements.

**Why this works:**
- Shows strategic thinking (not just tactical fixes)
- Demonstrates architectural depth
- Ties to platform engineering mindset
- Shows you can execute large projects

---

#### **Option B: Real-Time Streaming** (If he asks about Kafka / real-time)

> At SIG, we process millions of financial transactions daily in real time. I designed a hybrid CDC-to-Kafka system that captures change events from source databases — Oracle, MySQL — and distributes them to downstream systems in near real time. The tricky part was maintaining ordering guarantees and consistency across heterogeneous consumers while scaling horizontally. We use Kafka Connect for source connectors, managed the schema evolution, and built topology that ensures no data loss. That streaming backbone enabled us to move from batch-heavy to event-driven architecture, which reduced latency and unlocked new products we couldn't support before.

**Why this works:**
- Shows you've built production streaming systems
- Demonstrates understanding of real-time tradeoffs
- Relevant to experimentation platforms (they need real-time metrics)

---

#### **Option C: Operational Excellence** (If he asks about reliability / runbooks)

> At SIG, I own 800+ production pipelines. The key to managing that volume is obsessive operational discipline: standardized alerting, runbook-driven incident response, automated reconciliation, SLA tracking. I authored comprehensive runbooks on SharePoint for each pipeline family, which reduced incident resolution time by 70% and enabled faster onboarding of new team members. We also have Prometheus/Grafana dashboards for each pipeline class so operations can triage issues without needing engineering. The philosophy is: if something can be documented and automated, it should be. That's how you scale.

**Why this works:**
- Shows you're not just a builder, you're an operator
- Demonstrates platform thinking (enabling others)
- Relevant to "reliable, testable, maintainable"

---

### **4. "What's your tech stack?"**

**Short, confident answer:**

> Python, PySpark, SQL, Hadoop, Hive, Kafka for streaming, Oracle and MySQL for databases, AWS cloud. I also have experience with Informatica PowerCenter, but I've moved away from that toward open-source and cloud-native tools. I'm AWS Certified Data Engineer Associate and Databricks Accredited. I'm comfortable learning new tools quickly — the fundamentals of distributed systems, data modeling, and operational reliability transfer across platforms.

**If he asks about GCP:** "I don't have production GCP experience, but I'm familiar with the architecture — Dataflow is conceptually similar to Spark on YARN, BigQuery is their columnar warehouse. I'd expect a short ramp on the GCP specifics, but the patterns are ones I know well."

---

### **5. "Where else are you in process?"**

**Strategy:** Mention other opportunities without naming (creates urgency, doesn't burn bridges)

> I'm in late-stage interviews with another Bay Area data platform team — first technical round in about a week. I'm also actively interviewing at a few other companies. So I'm moving relatively quickly through processes.

**Keys:**
- "Late stage" = leverage without being aggressive
- Don't name Snowflake
- "Actively interviewing" = you're hot, not desperate
- "Moving quickly" = sets tempo expectations

**If he presses for specifics:** "I prefer not to name them at this stage, but happy to talk about what I'm looking for in a role."

---

### **6. "When could you start?"**

> Two weeks from an offer would be standard. I'm relocating from Philadelphia, so I'll need a little time to wrap up logistics, but nothing that would delay a June start if we moved fast.

**Keys:**
- Standard two weeks
- Acknowledge relocation but not a blocker
- Open to June start

---

### **7. "What are your comp expectations?"**

**Strategy:** Give a range if comfortable, but you can also punt intelligently.

#### **Option A: Giving a number** (if you're comfortable)

Senior DE at Intuit/Credit Karma, Bay Area:
- Base: $190K - $240K
- Bonus: 10-15%
- RSU: $80K - $120K/year
- Total: $320K - $390K

**Your pitch:**
> I'm targeting total comp in the $320 to 380K range, with flexibility based on the full package and level. That said, I'd love to hear what the band is for this role — happy to share my current comp for context if that's helpful.

#### **Option B: Punting intelligently** (also fine)

> I'm calibrating across the Bay Area market right now and would love to understand what the band is for this level first. Happy to share my current total comp if that's useful as a baseline.

**Keys:**
- Don't lowball yourself
- Show flexibility but also self-awareness
- Comp conversation is for later rounds anyway

---

## Part 4: Questions to Ask Boris (Pick 2-3)

**Strategy:** Ask questions where you actually want the answer, not to sound smart.

### **#1: Team & Reporting** (Most important)

> "Can you tell me more about the team structure and where this role sits? Is it the experimentation platform team specifically, or a broader data eng function that supports it?"

**Why:** You want to know if you're working on ML/analytics infrastructure or something else.

---

### **#2: Why This Hire** (Momentum signal)

> "What's driving this hire — is it a new team, backfill, or expansion of an existing function?"

**Why:** New/expansion = growth, which is usually better than backfill.

---

### **#3: Interview Process** (Logistics, most universally useful)

> "What does the interview process look like beyond this call? How many rounds, what are the focus areas, and what's the typical timeline?"

**Why:** Helps you plan, shows you're serious.

---

### **#4: Onsite Expectations** (Practical for you)

> "Onsite expectations for Oakland — how many days a week, and is there flexibility for someone relocating from the East Coast?"

**Why:** You need to know this for your own planning.

---

### **#5: Team Size & Reporting** (Optional, if he hasn't covered)

> "What's the team size and who would I report to?"

**Why:** Context on scope.

---

## Part 5: Tactical Call Prep (Day-of)

### **Morning of the Call (Thursday, May 14)**

#### **9 AM - 11 AM: Focused Prep** (~2 hours)

1. **Read this guide one more time** (20 min)
   - Focus on Parts 2-4 (your pitches and answers)
   - Do not cram new information

2. **Practice your 60-second pitch out loud** (15 min)
   - Record yourself on your phone
   - Listen back — does it sound natural?
   - Trim anything that feels scripted

3. **Review the JD and your resume side-by-side** (15 min)
   - Highlight 3-4 resume bullets that map to the JD
   - Know which story you'll lead with if he asks open-ended questions

4. **Prepare your physical/digital setup** (10 min)
   - Open Zoom link in browser (test it works)
   - Have resume open in PDF reader
   - Have JD open in another tab
   - Have notepad nearby (physical or notes app)
   - Close Slack, email, all other notifications

#### **11 AM - 12:30 PM: Break & Light Context**

- Go for a walk, eat lunch, decompress
- Read Section 1 of this guide once more (role context)
- Don't prep more — you'll overthink

#### **2:00 PM - 2:28 PM: Final Setup**

- Join Zoom 2 minutes early (2:28 PM PT = 5:28 PM ET)
- Camera and audio tested
- Sit in a quiet place, good lighting
- Smile — it comes through in your voice

---

## Part 6: During the Call — Checklist

| Moment | What to Do |
|---|---|
| **Boris joins** | Smile, warm greeting, "Thanks for making time" |
| **He introduces himself** | Listen, write down his role/background if relevant |
| **"Tell me about yourself"** | Use Version A or B pitch (55-65 sec) |
| **Any technical question** | Give specific example from SIG, include metrics |
| **He talks about Credit Karma** | Nod, take notes, listen for language clues |
| **Ask your questions** | Pick 2-3 from Part 4, ask naturally |
| **He pitches the role** | Listen, ask follow-ups if needed |
| **Wrapping up** | Confirm next steps, thank him |

---

## Part 7: After the Call (Within 24 Hours)

### **Thank-You Email** (send within 24 hours)

**Subject:** Thanks for the conversation - Credit Karma DE role

> Hi Boris,
> 
> Thanks for taking the time to discuss the Data Engineer role at Credit Karma today. I really appreciated learning more about the experimentation platform work and the team's focus on platform engineering rigor — that's exactly the kind of foundational infrastructure work I'm excited about.
> 
> I'm looking forward to the next steps in the process.
> 
> Best,  
> Krishna

**Keys:**
- 2 sentences max
- Specific detail (experimentation platform, platform engineering)
- Professional but warm
- No ask, just appreciation

---

### **Update Nischith**

Quick message:
> Hey Nischith — had a great call with Boris at Credit Karma this afternoon. Thanks for the referral and the context on the team. Felt like a real fit. I'll keep you posted as things progress.

**Why:** He vouched for you; loop closure matters for future referrals.

---

## Part 8: Red Flags — What NOT to Do

❌ **Don't:**
- Badmouth Susquehanna or any previous employer
- Name Snowflake when discussing other processes (say "another data platform team")
- Lead with compensation (too early)
- Over-explain why you're leaving
- Ask Boris technical questions about data architecture (that's for later rounds)
- Speak negatively about GCP/Google (you don't have experience, and that's fine)

✅ **Do:**
- Be specific with metrics and examples
- Show genuine interest in their platform problem
- Reference Nischith naturally but not excessively
- Ask logistical questions (onsite, process, timeline)
- Keep answers to 1-2 minutes unless he keeps digging

---

## Part 9: Timeline & Expectations After This Call

**If Boris likes you:**
- He'll send a follow-up email within 1-3 days with next steps
- Likely: a technical phone screen (1 hour, data design or coding)
- Or: a peer conversation with a senior engineer on the team
- Then: onsite if you pass technical (usually 4-5 hours, multiple rounds)

**Timeline:** Expect 2-3 weeks from this call to an offer if everything moves fast.

**Your leverage:** You have Snowflake in motion (mention subtly if asked).

---

## Part 10: Quick Reference Cards (Print or Screenshot)

### **Card 1: 60-Second Pitch** (memorize this cold)

> 9 years as Senior Data Engineer at Susquehanna. Own 800+ production pipelines. Built config-driven PySpark framework reducing ops overhead 75% and runtime 50%. Led CDC-to-Kafka modernization and zero-downtime Hadoop migration. Stack: Python, PySpark, SQL, Kafka, Hadoop, AWS. Master's GWU, AWS certified.

---

### **Card 2: Why Credit Karma**

> Consumer-scale data infrastructure + experimentation platform + software engineering rigor = my sweet spot. Nischith's referral gave me confidence the team is real.

---

### **Card 3: My Top Stories** (pick based on what he asks)

1. **Config-driven framework** — 75% ops reduction, config only, zero code
2. **CDC-to-Kafka** — streaming modernization, fault tolerance, cost reduction
3. **Hadoop migration** — zero downtime, 2.6 to 3.1, columnar + pruning
4. **Operational excellence** — 800+ pipelines, runbooks, 70% faster incident resolution

---

### **Card 4: Questions to Ask**

1. Team structure and scope
2. What's driving this hire
3. Interview process and timeline
4. Onsite expectations
5. Team size and reporting

---

### **Card 5: Red Flags Checklist**

- ✅ Don't badmouth SIG
- ✅ Don't name Snowflake
- ✅ Don't lead with comp
- ✅ Don't ask technical questions
- ✅ Do be warm and specific
- ✅ Do update Nischith after

---

## Final Tips

### **Tone for the Call**

- **Warm + confident.** You've done this before (800+ pipelines).
- **Specific + humble.** You have deep technical knowledge, but you're not arrogant about it.
- **Interested + not desperate.** You have other options, but this one genuinely interests you.

### **Energy Level**

- You're working from home, so **smile while speaking** — it changes your voice
- Take a walk before the call to get energy up
- Have water nearby
- Don't slouch on camera

### **If You Get Stuck**

If Boris asks something unexpected:
1. **Pause for 1-2 seconds** (shows you're thinking)
2. **Say something true** — even if it's "That's a great question, let me think about that for a moment"
3. **Give a specific example** if possible
4. **Ask a follow-up** if you need time: "Are you asking about X or Y?"

---

## Timeline: Thursday May 14 Prep Schedule

| Time | Activity | Duration |
|---|---|---|
| 9:00 AM | Read this guide Part 1-4 | 20 min |
| 9:20 AM | Practice your 60-sec pitch out loud | 15 min |
| 9:35 AM | Review JD + resume mapping | 15 min |
| 9:50 AM | Prep your physical/digital setup | 10 min |
| 10:00 AM | Review one core story deeply (pick one from Part 3) | 15 min |
| 10:15 AM | Break / light review | 45 min |
| 11:00 AM | Lunch + decompress | 60 min |
| 12:00 PM | Read Part 1 one more time for context | 10 min |
| 12:10 PM | Free time (don't cram more) | until call |
| 2:28 PM | Join Zoom early, smile, settle in | 2 min |
| 2:30 PM | **CALL STARTS** | 30 min |
| 3:00 PM | **CALL ENDS** |  |

---

## Done.

You're ready. This call is a **vibe check and logistics conversation**, not a technical assessment. Boris wants to confirm:
1. You're real and serious
2. You fit the role and team culture
3. Logistics (relocation, timeline, comp) work

**You've got this.** Go crush it.

After the call, send the thank-you email within 24 hours and update Nischith. That's it.

Good luck. See you after for debrief if you want.
