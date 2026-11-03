# Traffic Law KH — Overview

> Flutter class project, Year 3 CS · Team: Viseth (team lead) and Sue · Launch target: **Mon, Nov 30, 2026**
> Repo: https://github.com/sovanpanha2007/traffic-law

## 1. Problem

In Cambodia, you must pass two tests to get a driving license: a QCM (multiple-choice) theory test and a practical driving test. To pass, and to drive safely, people need to understand the traffic law. But the official Law on Land Traffic (2017) is long, uses legal language, and is hard to read on a phone. Road signs are usually memorized without knowing the rule behind them. Existing practice apps focus on memorizing answers, and some answers are unclear or wrong.

## 2. Target users

| User | Need |
|---|---|
| **Test takers** | Prepare for the driving license theory test |
| **New and current drivers** | Refresh or check the rules |
| **General learners** | Understand traffic law, even without taking the test |

Most users speak Khmer as their first language and use mid-range phones, sometimes with slow or no internet.

## 3. Solution

**Traffic Law KH** is a mobile app (Android and iOS) that helps people learn traffic law **in Khmer**. It works **fully offline** and needs **no account**. Everything is saved on the phone.

## 4. Main user flow

The user repeats this loop:

```
Learn (law PDF, road signs)  →  Quiz by topic  →  See score + mistakes  →  Learn again
```

Example: a user reads the chapter about speed, takes the "Speed" quiz, gets 6/10, opens **My Progress**, sees "Speed 60%" and the 4 wrong questions, reads their explanations, and practices those mistakes again.

## 5. Screen list

| # | Screen | Feature |
|---|---|---|
| 1 | Home: 3 big cards (Law, Road Signs, Quiz) | – |
| 2 | Chapter list | Law |
| 3 | PDF reader | Law |
| 4 | Sign categories + sign grid | Road signs |
| 5 | Sign detail (picture + meaning) | Road signs |
| 6 | Topic list + "My Progress" button | Quiz |
| 7 | Question screen (after answering: right/wrong + explanation) | Quiz |
| 8 | Result screen (score) | Quiz |
| 9 | My Progress (score per topic + mistakes list) | Dashboard |

## 6. Scope

### Must-have (MVP: needed for the Nov 30 demo)
1. **Law PDF:** a chapter list. Tapping a chapter opens the official PDF at that chapter's first page. Scroll and pinch zoom.
2. **Road signs:** signs grouped by category, each with a picture, a name and a meaning.
3. **Quiz by topic:** about 4 topics × 10 questions. Instant right/wrong, an explanation for each question, and a final score.
4. **My Progress (small dashboard):** the score for each topic and a list of wrong questions, with a "Practice my mistakes" button.

### Nice-to-have (only if time is left in Week 4)
- English language switch
- From a quiz explanation, tap to open the law PDF at the related page
- Bigger sign view (tap to zoom)
- A chart of past scores

### Out of scope (we will not build)
- Search (Khmer text search in the PDF is not reliable)
- Accounts, login, server, or cloud sync
- Mock exam with timer
- Practical driving test guide, fines lookup
- Publishing to Google Play or the App Store

## 7. Product rules (defaults, confirm in review)
- **Topic score** = the score of the user's **latest** quiz in that topic. It is simple, and it shows improvement right away.
- **A mistake leaves the list** after the user answers that question correctly once, in any quiz.
- A topic is marked **weak** when its score is under **70%** (change this to the real test's pass mark if you know it).
- A quiz that the user quits in the middle is **not saved**.
- All app text is in **Khmer**. All UI text is kept in one file, so English can be added later.

## 8. Roles and approval
- **Team lead and final approver:** Viseth
- **Reply rule:** the approver answers within **24 hours**. If there is no answer, the default choice in our docs is used and work continues.
- **Content fallback:** until real content is ready (Week 2), the app uses placeholder JSON (sample questions and signs), so coding is never blocked.

## 9. Definition of Done

**A task is done when:**
- It works on the **Android emulator** and the **iOS Simulator**
- Khmer text shows correctly (no broken characters or wrong vowel positions)
- `flutter analyze` shows no errors
- The code is pushed to GitHub, and the other member has tested it

**A feature is done when:**
- All its acceptance criteria in `PLAN.md` pass
- The team lead approves it

**Ready to launch (Nov 30) when:**
- All 4 must-have features work **offline** (airplane mode) on both emulator and simulator
- Real content is in the app (no placeholder text)
- Khmer text was checked once on a **real phone** (borrowed)
- No crash during a full run of the demo script
- The Figma prototype and the app match on the main screens
- The demo was practiced at least once
