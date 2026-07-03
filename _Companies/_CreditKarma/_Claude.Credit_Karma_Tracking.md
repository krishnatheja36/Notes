# Credit Karma — Interview Tracking

**Interview: Wednesday May 27, 2:00 PM**

---

## 2-DAY BATTLE PLAN

---

### NIGHT 1 — Monday May 25 into Tuesday (All-Nighter)

**Phase 1 — Python Fundamentals first (2–3 hrs)**

- [X] Part 0: Read decorators (@property, @staticmethod, @classmethod, @abstractmethod)
- [X] Part 0: OOP — four pillars, dunder methods, dataclasses
- [X] Part 0: Lambda, map/filter/zip, comprehensions, generators
- [X] Part 0: Error handling, context managers, type hints
- [X] Goal: understand the concepts, not memorize — you'll see them in the problems

**Phase 2 — Tier 1: Confirmed Asked (2 hrs)**

- [X] Bank Account class — read, then write from memory ← **CONFIRMED ASKED**
- [X] Robot class — read, then write from memory ← **CONFIRMED ASKED**
- [X] Number of Islands (Graph DFS)
- [ ] Robot Grid / Unique Paths (DP)
- [ ] DP patterns (Fibonacci, Knapsack, LCS)

**Phase 3 — Tier 2: The Weak Spot (1 hr)**

- [ ] **Histogram 4-line template — write from memory, no peeking** ← lost a round
- [ ] HTTP Log parsing — read the full parse_log_line pattern

**Phase 4 — Tier 3: New Problems (1–2 hrs)**

- [ ] Two Sum (hash map complement)
- [ ] Valid Anagram + Group Anagrams
- [ ] Longest Substring Without Repeating Characters (sliding window)
- [ ] Sieve of Eratosthenes
- [ ] Find Duplicates (Counter)

**Phase 5 — Tier 4: Core Problems (2 hrs)**

- [ ] Rain Water (DP — 3-pass approach)
- [ ] Balanced Brackets + Matching Parens (Stack)
- [ ] Merge Sorted Lists (Two Pointers)
- [ ] Missing Number (Math — Gauss formula)
- [ ] Rectangle Overlap (Intervals)
- [ ] String Mapping (bijection — two dicts)
- [ ] Append Frequency (Counter + string rebuild)
- [ ] Even/Odd Ordering

**Phase 6 — Tier 5: Rapid Scan to dawn (2 hrs, 20 min each)**

- [ ] Add Two Numbers (string) + Reverse String + FizzBuzz
- [ ] Reverse Linked List + Add Two Numbers (LL)
- [ ] Validate BST + Max Depth Tree
- [ ] Clone Graph (BFS + hash map)
- [ ] Top K Frequent + Merge Intervals

---

### NIGHT 2 — Tuesday May 26 from 5 PM (All-Nighter)

**5 PM – 7 PM: Weak spots + anything missed from Night 1**

- [ ] Redo anything you blanked on from Night 1
- [ ] Re-read Histogram + Log (Part 14) — read it again cold
- [ ] Re-read Bank Account + Robot class from memory

**7 PM – 9 PM: Mock Practice — OUT LOUD with a timer**

- [ ] Mock 1: OOP problem — explain → code → test → complexity (15 min)
- [ ] Mock 2: Any algorithm problem (15 min)
- [ ] Mock 3: Graph or DP problem (15 min)
- [ ] Say your approach before every line of code

**9 PM – 11 PM: Reference Read**

- [ ] Read Part 20 (Pressure Management — what to say when you blank)
- [ ] Read Part 21 (CoderPad Specific Tips)
- [ ] Read Part 10 (Key Phrases for Collaborative Round)
- [ ] Read Part 7 (Collaborative Framework — 60-second rule)

**11 PM onward: Light only**

- [ ] Skim `_Claude.Credit_Karma_Python_cheat_sheet.md` — pattern templates, complexity table
- [ ] Read the Final Checklist below once
- [ ] No new problems after midnight — consolidate what you know

---

### INTERVIEW DAY — Wednesday May 27 (Working, Just Revise)

- [ ] Morning: Read cheat sheet once (15 min max)
- [ ] Before interview: Read Part 10 Key Phrases + Part 20 Pressure Management
- [ ] Do ONE warm-up problem out loud (e.g., Balanced Brackets — easy, builds rhythm)
- [ ] Join CoderPad 2 min early, have water nearby, breathe

**Do NOT cram new problems on interview day.**

---

### If You Run Out of Time — Priority Order

| Priority  | What                      | Why                       |
| --------- | ------------------------- | ------------------------- |
| 🔴 Must   | Bank Account OOP          | Confirmed asked twice     |
| 🔴 Must   | Robot class OOP           | Confirmed asked           |
| 🔴 Must   | Histogram 4-line template | Lost a round over this    |
| 🔴 Must   | Balanced Brackets         | Most common easy stack    |
| 🔴 Must   | Missing Number            | Math — 2 lines of code   |
| 🔴 Must   | Two Sum                   | Most iconic easy question |
| 🟡 Should | Number of Islands         | Graph DFS — medium       |
| 🟡 Should | Unique Paths              | DP — medium              |
| 🟡 Should | Rain Water                | DP — medium              |
| 🟡 Should | Valid Anagram             | Counter — very Pythonic  |
| 🟢 Nice   | Trees, Linked Lists       | If time allows            |
| 🟢 Nice   | Merge Intervals, Top K    | If time allows            |

---

## Final Checklist

**OOP — Confirmed Asked (do these first)**

- [ ] Bank Account class (Part 10b Problem 10) ← confirmed asked
- [ ] Robot class with movement methods (Part 22) ← confirmed asked

**Core Algorithms — High Priority**

- [ ] Balanced Brackets (Stack)
- [ ] Matching Parentheses (Stack)
- [ ] Merge Sorted Lists (Two Pointers)
- [ ] Missing Number (Math)
- [ ] Rectangle Overlap (Intervals)
- [ ] String Mapping (Hash Map bijection)
- [ ] Append Frequency (Counter + string)
- [ ] Rain Water (DP — 3-pass approach)
- [ ] Robot Grid / Unique Paths (DP)
- [ ] Number of Islands (Graph DFS/BFS)
- [ ] Even/Odd Ordering (Two Pointers)

**The Weak Spot — Must Know Cold**

- [ ] Histogram 4-line template (`Counter` + `sorted` + `'#' * count`) ← lost a round
- [ ] HTTP log parsing with regex (`parse_log_line` pattern)

**New Problems (Part 23)**

- [ ] Two Sum (hash map complement lookup)
- [ ] Valid Anagram (`Counter(s) == Counter(t)`)
- [ ] Group Anagrams (`tuple(sorted(word))` as key)
- [ ] Longest Substring Without Repeating (sliding window + set)
- [ ] Sieve of Eratosthenes (Prime to N)
- [ ] Find Duplicates (Counter)

**Strings, Linked Lists, Trees, Graphs, Heap**

- [ ] Add Two Numbers (string + linked list versions)
- [ ] Reverse String / Palindrome
- [ ] FizzBuzz CreditKarma variant
- [ ] Reverse Linked List (three-pointer approach)
- [ ] Validate BST (min/max bounds)
- [ ] Max Depth Binary Tree
- [ ] Clone Graph (BFS + hash map)
- [ ] Top K Frequent (Counter + heapq.nlargest)
- [ ] Merge Intervals (sort by start + merge)

**Mindset**

- [ ] Practiced 60-Second Rule out loud on at least 3 problems
- [ ] Know what to say when you blank (Part 20)
- [ ] Read CoderPad tips (Part 21)
- [ ] Read Boris's advice: explain, have a conversation, be collaborative

---

**One round didn't go well. That's data, not a verdict. You know what was asked now. You know the template. Next round will be different.**
