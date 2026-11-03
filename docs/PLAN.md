# Traffic Law KH — Plan

- **Team:** Viseth (team lead, GitHub) and Sue
- **Time:** about 1 hour a day each → **about 56 hours in total** (Tue, Nov 3 → Mon, Nov 30)
- **Planned work:** about 46 hours
- **Buffer** (extra time for problems and learning): Sun Nov 22, Tue–Wed Nov 24–25 (bug fixes), Sat Nov 28, Mon Nov 30 morning → about **10 hours = 22%**
- ⚠️ **Our rule is a 30–50% buffer.** To reach it, each member gives **1 extra hour on Sat and Sun of Weeks 2–4** when the team is behind (up to 12 more hours → about 48%). *Team decision needed.*
- **Final milestone:** demo on Mon, Nov 30, 2026

## 1. Milestones (one per week)

| Milestone | Dates | Goal | Done when |
|---|---|---|---|
| **M1 – Clickable prototype** | Tue Nov 3 → Sun Nov 8 | Figma prototype + Flutter project created | All 9 screens in Figma, clickable; project builds on both simulators |
| **M2 – Content, Law, Signs** | Mon Nov 9 → Sun Nov 15 | Real content JSON, Law PDF works, signs list works | Chapter → PDF opens at the right page; signs grid shows real signs |
| **M3 – Quiz + Progress** | Mon Nov 16 → Sun Nov 22 | Full quiz flow and My Progress | User can take a quiz, see the score, see mistakes, practice them again |
| **M4 – Playable build + demo** | Mon Nov 23 → Mon Nov 30 | Tested, fixed, demo ready | "Ready to launch" in OVERVIEW.md is all ✅ |

## 2. Epics (big groups of work, used as labels)

| Label | Epic |
|---|---|
| `E0-setup` | Project setup and technical spike |
| `E1-design` | Figma prototype and design system |
| `E2-content` | Content JSON and images |
| `E3-law` | Law PDF |
| `E4-signs` | Road signs |
| `E5-quiz` | Quiz |
| `E6-progress` | My Progress dashboard |
| `E7-test` | Testing and demo |

**Board columns:** Backlog → This week → In progress → Review → Done.
**Rule:** a card moves to **Done** only after the other member has tested it (see the Definition of Done in OVERVIEW.md).

## 3. Week 1 in detail (30–60 minute tasks)

| Day | Sue (1 h) | Viseth (1 h) |
|---|---|---|
| **Tue Nov 3** | #1 Create Figma file + pages + frame 390×844 (30 min) · #2 Color + text styles (30 min) | #3 Create Flutter project, push to GitHub, add Sue as collaborator (60 min) |
| **Wed Nov 4** | #4 Components: primary button, top bar, feature card (60 min) | #5 Components: answer option (all states), list tile, sign card (60 min) |
| **Thu Nov 5** | #6 **Together:** design the question screen + explanation box (60 min, on a call) | #6 (together) |
| **Fri Nov 6** | #7 Home + Topic list screens (60 min) | #8 Chapter list + PDF reader screens (60 min) |
| **Sat Nov 7** | #9 Result + My Progress screens (60 min) | #10 Sign categories + Sign detail screens (60 min) |
| **Sun Nov 8** | #11 Prototype links: Home + quiz flow (40 min) · #12 Click-through test + fixes (20 min) | #11 Prototype links: law + signs flow (40 min) · #12 (together) |

> Sue's other class project is due Nov 10. If a Week 1 day is missed, move it to Mon Nov 9 and push the spike (#13) to Tue.

## 4. Issues (for the GitHub Projects board)

Format: **#ID Title** · owner · date · label
*Description.* → **AC** (acceptance criteria: how we know it is done)

### M1 – Clickable prototype (Week 1)

**#1 Set up Figma file** · Sue · Tue Nov 3 · `E1-design`
*Shared Figma file with pages: Styles, Components, Screens.* → **AC:** both members can edit; one 390×844 frame exists.

**#2 Color and text styles** · Sue · Tue Nov 3 · `E1-design`
*Add the colors and text styles from DESIGN.md as Figma styles.* → **AC:** all colors and the 5 text styles exist, and Khmer sample text shows in Kantumruy Pro.

**#3 Create Flutter project and repo** · Viseth · Tue Nov 3 · `E0-setup`
*`flutter create traffic_law`, push to the repo, folder structure from ARCHITECTURE.md (empty files are OK).* → **AC:** Sue can clone and run it on the iOS Simulator; Viseth can run it on the Android emulator; both use the same Flutter version.

**#4 Components part 1** · Sue · Wed Nov 4 · `E1-design`
*Primary button, top bar, feature card.* → **AC:** each is a Figma component following DESIGN.md.

**#5 Components part 2** · Viseth · Wed Nov 4 · `E1-design`
*Answer option (default / selected / correct / wrong / disabled), list tile, sign card.* → **AC:** all 5 answer states exist as variants.

**#6 Flagship screen: question screen** · both · Thu Nov 5 · `E1-design`
*Before and after answering, with the explanation box.* → **AC:** the team lead approves it; it uses only components and styles.

**#7 Home + Topic list** · Sue · Fri Nov 6 · `E1-design` → **AC:** matches the wireframes in DESIGN.md; uses components only.

**#8 Chapter list + PDF reader** · Viseth · Fri Nov 6 · `E1-design` → **AC:** same as #7.

**#9 Result + My Progress** · Sue · Sat Nov 7 · `E1-design` → **AC:** My Progress shows topic bars, the mistakes list and the empty state.

**#10 Sign categories + Sign detail** · Viseth · Sat Nov 7 · `E1-design` → **AC:** same as #7.

**#11 Prototype links** · both · Sun Nov 8 · `E1-design`
*Connect buttons to screens in Figma Prototype mode.* → **AC:** you can click from Home into every screen and back.

**#12 Click-through test and submit** · both · Sun Nov 8 · `E1-design` → **AC:** no dead buttons; the link is shared with the teacher.

### M2 – Content, Law, Signs (Week 2)

**#13 Technical spike: PDF viewer** · Viseth · Mon Nov 9 · `E0-setup`
*Small test from ARCHITECTURE.md §9.* → **AC:** Khmer shows correctly in the PDF on both simulators; opening at page 21 works; pinch zoom works. If it fails → tell Sue the same day and try `pdfx`.

**#14 Theme and strings** · Sue · Mon Nov 9 · `E0-setup`
*`app_theme.dart` (colors and fonts from DESIGN.md), `strings.dart` (Khmer UI text).* → **AC:** the app uses Kantumruy Pro; no Khmer text is written directly inside screen files.

**#15 Packages, assets, fonts** · Viseth · Tue Nov 10 · `E0-setup`
*Add `pdfrx`, `shared_preferences`, asset folders and fonts in `pubspec.yaml`.* → **AC:** `flutter pub get` works for both members; the versions are written in ARCHITECTURE.md.

**#16 Models + placeholder JSON** · Sue · Tue Nov 10 · `E2-content`
*The 5 models with `fromJson`, and small sample JSON files.* → **AC:** a unit test loads each sample JSON into models without errors.

**#17 Home screen + navigation** · Viseth · Wed Nov 11 · `E3-law`
→ **AC:** the 3 cards open the 3 sections; Back returns Home.

**#18 ContentRepository** · Sue · Wed Nov 11 · `E2-content`
*Load chapters, signs, topics and questions once from assets.* → **AC:** the second load does not read the file again; a broken JSON shows an error message, not a crash.

**#19 chapters.json + Chapter list screen** · Viseth · Thu Nov 12 · `E3-law`
→ **AC:** all real chapters show in order with their titles.

**#20 questions.json part 1** · Sue · Thu Nov 12 · `E2-content`
*Topics 1–2, 10 questions each, with explanations.* → **AC:** valid JSON; unique IDs; every question has an explanation.

**#21 PDF reader at chapter page** · Viseth · Fri Nov 13 · `E3-law`
→ **AC:** tapping a chapter opens the PDF at its `startPage`; works offline; an error message shows if the file fails.

**#22 questions.json part 2** · Sue · Fri Nov 13 · `E2-content` → **AC:** topics 3–4 done (40 questions in total).

**#23 signs.json + sign images** · Viseth · Sat Nov 14 · `E2-content`
*About 30 signs in 3–4 categories, PNG images.* → **AC:** every sign has an image file that exists; images are under 200 KB each.

**#24 Content review** · Sue · Sat Nov 14 · `E2-content`
*Check questions against the law; add `lawPage`.* → **AC:** Viseth has read all 40 questions; no spelling errors were found.

**#25 Sign categories screen** · Viseth · Sun Nov 15 · `E4-signs`
→ **AC:** category chips filter the grid; each sign shows its image and name; a missing image shows a placeholder.

**#26 Topic list screen** · Sue · Sun Nov 15 · `E5-quiz`
→ **AC:** shows all topics from the JSON and a "My Progress" button.

### M3 – Quiz + Progress (Week 3)

**#27 Sign detail screen** · Viseth · Mon Nov 16 · `E4-signs` → **AC:** big image, name, meaning; Back returns to the same category.

**#28 Question screen: show question** · Sue · Mon Nov 16 · `E5-quiz` → **AC:** shows "Question 3/10", the text, an optional image, and 2–4 options.

**#29 Empty and error states (law + signs)** · Viseth · Tue Nov 17 · `E4-signs` → **AC:** no blank screens in any case.

**#30 Answer feedback + explanation** · Sue · Tue Nov 17 · `E5-quiz`
→ **AC:** after a tap, the correct option turns green and a wrong choice turns red; options lock; the explanation appears; "Next" is disabled until an answer is chosen.

**#31 ProgressStorage** · Sue · Wed Nov 18 · `E6-progress`
*`saveResult`, `loadResults`, `latestScoreByTopic`, `loadMistakeIds`, `resetAll`.* → **AC:** unit tests pass; data survives an app restart.

**#32 My Progress UI (sample data)** · Viseth · Wed Nov 18 · `E6-progress` → **AC:** topic bars + mistakes list + empty state match the Figma design.

**#33 Finish quiz + quit dialog** · Sue · Thu Nov 19 · `E5-quiz`
→ **AC:** the last question goes to Result and the quiz is saved; Back in the middle asks "Quit quiz?"; a quit quiz is not saved.

**#34 Connect My Progress to storage** · Viseth · Thu Nov 19 · `E6-progress` → **AC:** shows real results; updates after a new quiz.

**#35 Result screen** · Sue · Fri Nov 20 · `E5-quiz` → **AC:** shows the score and percentage, with "Try again" and "My Progress" buttons.

**#36 Mistakes list details + reset** · Viseth · Fri Nov 20 · `E6-progress`
→ **AC:** each mistake shows the question, the correct answer and the explanation; reset asks for confirmation.

**#37 Practice my mistakes** · Sue · Sat Nov 21 · `E6-progress`
→ **AC:** starts a quiz with only mistake questions; a correct answer removes it from the list; with no mistakes the button is hidden.

**#38 Full flow test round 1** · Viseth · Sat Nov 21 · `E7-test` → **AC:** a bug list is written as GitHub issues.

**Sun Nov 22: buffer** (both): fix bugs from #38 or catch up.

### M4 – Playable build + demo (Week 4)

**#39 Test checklist: Android** · Viseth · Mon Nov 23 · `E7-test` · **#40 Test checklist: iOS** · Sue · Mon Nov 23 · `E7-test`
*Run the checklist below.* → **AC:** every item is marked pass or fail, and failures become issues.

**#41 Bug fixes** · both · Tue Nov 24 – Wed Nov 25 · `E7-test` → **AC:** no open bugs with the `crash` label.

**#42 Real-phone Khmer check + offline test** · both · Thu Nov 26 · `E7-test`
*Borrow one phone for 30 min.* → **AC:** Khmer is correct in the PDF, quiz and signs; the app works in airplane mode.

**#43 Polish to match Figma** · both · Fri Nov 27 · `E1-design` → **AC:** the main screens match the prototype.

**Sat Nov 28: buffer**: do a nice-to-have **only if** #39–#43 are done.

**#44 Demo script + rehearsal** · both · Sun Nov 29 · `E7-test`
*A 3–5 minute story: learn → quiz → mistakes → progress.* → **AC:** rehearsed once from start to end without a crash.

**Mon Nov 30: DEMO** 🎉

## 5. Test checklist (for #39 / #40)
1. The app opens offline (airplane mode).
2. Each chapter opens the PDF at the right page; zoom works.
3. Every sign category shows signs; a sign detail opens.
4. A full quiz in each topic: feedback, explanation, score.
5. Quit in the middle → not saved.
6. My Progress: the empty state on a fresh install, then real scores after quizzes.
7. Practice mistakes: a correct answer removes the question from the list.
8. Close and reopen the app → progress is still there.
9. Reset progress → confirmation → everything is cleared.
10. Khmer text: no broken characters anywhere.

## 6. Risk log

| Risk | Chance | Impact | What we do |
|---|---|---|---|
| PDF viewer fails with Khmer or on iOS | Medium | High | Spike #13 first; fallback `pdfx`, then PNG pages |
| Content (40 questions, 30 signs) is late | Medium | High | Placeholder JSON from #16; content tasks are fixed on the calendar |
| Beginners: tasks take longer than planned | High | Medium | Buffer days + weekend extra hours; ask the AI/teacher after 30 min stuck; cut nice-to-haves first |
| Other class deadlines (Nov 10) | High | Medium | Week 1 is design only; move missed tasks to Mon |
| Khmer looks different on a real phone | Medium | Medium | #42 real-phone check |
| Git merge conflicts | Medium | Medium | File ownership rule (ARCHITECTURE.md); only Viseth edits `pubspec.yaml`; pull before starting work |
| JSON typing errors break the app | Medium | Medium | VS Code + a unit test that loads every JSON (#16) |
| Only emulators, no real devices | Certain | Low | Simulators for daily work + #42 |

## 7. 8-point gate (do not code features until all are ✅)

| # | Question | Status |
|---|---|---|
| 1 | What are we building, for whom, what is out of scope? | ✅ OVERVIEW.md |
| 2 | Single approver, reply time, content fallback? | ✅ Viseth, 24 h, placeholder JSON |
| 3 | Risky parts tested with a spike? | ⏳ PDF spike #13 (Mon Nov 9) |
| 4 | Screen references + data model? | ⏳ Data model ✅ (ARCHITECTURE.md) · Figma due Sun Nov 8 |
| 5 | Stack, hosting, costs, accounts written down? | ✅ Stack in ARCHITECTURE.md · no hosting or server, cost $0 · repo owned by the team (turn on 2FA, the two-step login check, for both members) |
| 6 | Repo, CI checks, previews work? | ⏳ Repo exists; project created in #3 · CI skipped by team choice: run `flutter analyze` before every push instead |
| 7 | 30–60 min tasks for this phase + buffer? | ⏳ Tasks ✅ · buffer is 22%, needs the weekend-hours decision to reach 30%+ |
| 8 | Written "Done" and "Ready to launch"? | ✅ OVERVIEW.md §9 |

**Feature coding starts after #13 passes (Mon Nov 9).** Setup tasks #3, #14, #15 and #16 are allowed before that.
