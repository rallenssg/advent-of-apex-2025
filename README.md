# Advent of Apex 2025 — Salesforce Automation & Apex Challenge

Welcome to my Advent of Apex 2025 repository! This project follows the official CampApex.org storyline and daily challenge sequence. Over 25 days, I’ll complete tasks spanning **Flows**, **Validation Rules**, **Apex Fundamentals**, **Algorithms**, **Data Structures**, and **API Integrations**—all centered around helping Grandma Kelly and the family prepare for baby's first Christmas.

This README describes the overall purpose of the project, the repo structure, and the branching workflow used throughout December.

---

## 🎯 Project Goals

* Build and test real **Salesforce automation** inspired by the Advent challenges
* Strengthen **Apex programming** and problem-solving skills
* Explore best practices for **integrations** using Salesforce’s named/external credential model
* Maintain clean documentation for future reference
* Keep challenge progress highly organized using a Git-based daily workflow

---

## 🧱 Repository Structure

This repo uses a **standard Salesforce project structure** with a clear separation between code and documentation.

```
root/
│
├─ force-app/                   # Standard Salesforce DX metadata (or src/ for metadata API)
│   ├─ main/
│   │   ├─ default/
│   │   │   ├─ classes/
│   │   │   ├─ triggers/
│   │   │   ├─ flows/
│   │   │   ├─ objects/
│   │   │   └─ ... other metadata
│
├─ manifests/                   # package.xml for org deployment/retrieval
│
├─ documentation/
│   ├─ index.md                 # Index of days
│   ├─ days/
│   │   ├─ solutions/           # Solution designs
│   │   │   ├─ Day1_Solution.md
│   │   │   ├─ Day2_Solution.md
│   │   │   ├─ Day3_Solution.md
│   │   │   └─ ... up to Day25_Solution.md
│   │   ├─ Day1.md
│   │   ├─ Day2.md
│   │   ├─ Day3.md
│   │   └─ ... up to Day25.md
│
└─ README.md                    # This file
```

### How documentation works

* Each day receives **its own markdown files** under `documentation/days/` and `documentation/days/solutions/`
* Each overview file contains:

  * Challenge description
  * Requirements
  * Notes

* Each solution file contains:

  * Approach / solution notes
  * Relevant Apex, Flow, or metadata details
  * Test summaries
  * Lessons learned

---

## 🌲 Branching Workflow

This repo uses a **“one branch per challenge/day”** model to keep work clean and reviewable.

### Branching Model

* `main` → always contains final, completed solutions
* `day-XX` → working branch for that day’s challenge

### Daily Git Flow

1. Create a new branch:
   `git checkout -b day-XX`
2. Implement the challenge in `/force-app`
3. Document work in:
   `documentation/days/DayXX.md` AND
   `documentation/days/solutions/DayXX_Solution.md`
4. Commit early and often
5. Open a PR into `main`
6. Merge after review / completion

This allows each challenge to be isolated and traceable.

---

## 📖 Story Summary

You’ll help a new family celebrate their baby’s first Christmas through three phases:

### **Phase 1 — Flows, Apex Rules & Validation**

Assist **Grandma Kelly** in setting up the family CRM.

### **Phase 2 — Apex, Algorithms & Data Structures**

Support the family team as they complete last-minute tasks.

### **Phase 3 — Apex Integrations (GET & POST)**

Ensure health, safety, and updates using real API integrations.

Characters include:
Grandma Kelly, Mama & Papa, Dr. Grace Evergreen, Monica McPatchwork, Stella Pinewood, Finn Brightwick, Poppy Wintergold, Shakira Maestro, Ivy Evergreen, and Tinker Bellwright.

---

## 📎 Daily Challenge Index

Links will activate as files are created:

* **[Day 1](documentation/days/Day1.md)**
* **[Day 2](documentation/days/Day2.md)**
* **[Day 3](documentation/days/Day3.md)**
* **[Day 4](documentation/days/Day4.md)**
* **[Day 5](documentation/days/Day5.md)**
* **[Day 6](documentation/days/Day6.md)**
* **[Day 7](documentation/days/Day7.md)**
* **[Day 8](documentation/days/Day8.md)**
* **[Day 9](documentation/days/Day9.md)**
* **[Day 10](documentation/days/Day10.md)**
* **[Day 11](documentation/days/Day11.md)**
* **[Day 12](documentation/days/Day12.md)**
* **[Day 13](documentation/days/Day13.md)**
* **[Day 14](documentation/days/Day14.md)**
* **[Day 15](documentation/days/Day15.md)**
* **[Day 16](documentation/days/Day16.md)**
* **[Day 17](documentation/days/Day17.md)**
* **[Day 18](documentation/days/Day18.md)**
* **[Day 19](documentation/days/Day19.md)**
* **[Day 20](documentation/days/Day20.md)**
* **[Day 21](documentation/days/Day21.md)**
* **[Day 22](documentation/days/Day22.md)**
* **[Day 23](documentation/days/Day23.md)**
* **[Day 24](documentation/days/Day24.md)**
* **[Day 25](documentation/days/Day25.md)**

---

## 🧪 Testing & Validation

For relevant days, each solution will include:

* Apex test classes
* Validation rule logic
* Flow configuration notes
* API callout tests via mocks
* Key takeaways for future reference

---

## 🚀 Getting Started

1. Install Salesforce CLI
2. Auth into your development org
3. Deploy or pull metadata
4. Work from your day branch
5. Document your work before merging

---

## 🎄 Final Notes

This repo will grow daily through December as the Advent challenges are completed.
Everything is designed to be reusable, reference-friendly, and aligned with real Salesforce development patterns.

Happy coding — and Merry Apex! 🎄
