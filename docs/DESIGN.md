# Traffic Law KH — Design

> **Status: draft for team review.** ✅ = decided together. 📝 = proposal, please approve or change.

## 1. Decisions so far

| Item | Decision | Status |
|---|---|---|
| Style | Dark blue + white: calm, official, trustworthy | ✅ |
| Font | **Kantumruy Pro** (Khmer and English), files bundled in the app | ✅ |
| Figma frame | **390 × 844** (iPhone 14 size, fits most Android phones too) | ✅ |
| Prototype | Clickable Figma prototype, all 9 screens, due **Sun Nov 8** | ✅ |
| App language | Khmer only (English is a nice-to-have) | ✅ |

## 2. Colors 📝

All text/background pairs below pass **WCAG AA** (an accessibility rule: contrast of at least 4.5 to 1, so text is easy to read).

| Name | Hex | Use | Contrast |
|---|---|---|---|
| `primary` | `#0D2B55` | Top bar, primary buttons, headings | White text on it: 14.1 |
| `primaryLight` | `#1F4E8C` | Links, selected tab, progress bar fill | On white: 8.3 |
| `background` | `#FFFFFF` | Screen background | – |
| `surface` | `#F4F6FA` | Cards, list tiles | `primary` on it: 13.0 |
| `textMain` | `#1A1A1A` | Body text | On white: 17.4 |
| `textSub` | `#5B6573` | Secondary text, captions | On white: 5.9 |
| `correct` | `#1B7F3A` on `#E8F5EC` | Correct answer | 4.5 |
| `wrong` | `#C62828` on `#FDECEC` | Wrong answer | 4.9 |
| `weak` | `#8A5A00` on `#FFF4D6` | "Weak topic" tag (under 70%) | 5.4 |

**Rule:** never use color alone to show right or wrong. Always add an icon too (✓ / ✗).

## 3. Typography (text styles) 📝

Khmer has vowels and subscript letters above and below the line, so it needs **more line height** than English. Use 1.5 or more, or the letters get cut off.

| Style | Size | Weight | Line height | Use |
|---|---|---|---|---|
| `title` | 22 | SemiBold | 1.5 | Screen titles |
| `heading` | 18 | SemiBold | 1.5 | Card titles, question text |
| `body` | 16 | Regular | 1.6 | Normal text, answers, explanations |
| `label` | 14 | Medium | 1.5 | Buttons, chips, tags |
| `caption` | 13 | Regular | 1.5 | Small info ("Question 3/10") |

Minimum size: 13. Never write Khmer below 13 pt.

## 4. Spacing, shape, touch 📝

- **Spacing scale:** 4 · 8 · 12 · 16 · 24 · 32 (use only these numbers)
- **Screen side padding:** 16
- **Corner radius:** 12 (cards, buttons, answer options), 8 (chips, tags)
- **Touch targets:** at least **48 × 48** (easy to tap with a thumb)
- **Shadows:** none or very light. Use the `surface` color to separate cards.
- **Icons:** Material Icons (built into Flutter), outlined style

## 5. Reusable components 📝

| Component | Looks like | States | Used on |
|---|---|---|---|
| **Top bar** | `primary` background, white title, back arrow | – | All screens except Home |
| **Feature card** | Big card: icon + title + short line | default, pressed | Home |
| **List tile** | Number badge + title + › arrow | default, pressed | Chapter list |
| **Sign card** | Sign image + name below | default, pressed | Sign grid |
| **Category chip** | Rounded label | selected (`primaryLight`), not selected | Sign categories |
| **Topic tile** | Topic name + progress bar + % + optional "weak" tag | not started, in progress, weak | Topic list, My Progress |
| **Answer option** | Full-width box with letter (ក ខ គ ឃ) + text | default, selected, **correct ✓**, **wrong ✗**, disabled | Question screen |
| **Explanation box** | `surface` box, 💡 icon, explanation text, "Law page 21" link (nice-to-have) | – | Question screen, mistakes list |
| **Primary button** | Full width, `primary`, white text, height 52 | enabled, disabled, pressed | Next, Start, Try again |
| **Secondary button** | White, `primary` border and text | enabled, pressed | My Progress, Reset |
| **Empty state** | Icon + short message + one button | – | My Progress (no results), errors |
| **Confirm dialog** | Title + message + Cancel / Confirm | – | Quit quiz, reset progress |

## 6. Screens (wireframes) 📝

In the app, all labels are in Khmer. They are written in English here so both of us can review quickly.

### Flagship screen: Question (design this first, Thu Nov 5)

```
┌──────────────────────────────┐
│ ←  Speed              3 / 10 │  top bar
│ ▓▓▓▓▓▓░░░░░░░░░░░░░░░░░░░░░ │  progress bar
│                              │
│  What is the speed limit for │  heading
│  cars in a city?             │
│  ┌────────────────────────┐  │
│  │      (optional image)  │  │
│  └────────────────────────┘  │
│  ┌────────────────────────┐  │
│  │ ក  30 km/h              │  │  answer option
│  └────────────────────────┘  │
│  ┌────────────────────────┐  │
│  │ ខ  40 km/h          ✓  │  │  correct (green)
│  └────────────────────────┘  │
│  ┌────────────────────────┐  │
│  │ គ  60 km/h          ✗  │  │  user's wrong choice (red)
│  └────────────────────────┘  │
│  ┌ 💡 ───────────────────┐   │
│  │ Explanation text …     │   │  shows after answering
│  └────────────────────────┘   │
│  [          Next          ]   │  disabled until answered
└──────────────────────────────┘
```
(The answers here are only examples. Use real law content.)

### 1. Home
```
┌──────────────────────────────┐
│  Traffic Law KH              │
│  Learn the rules of the road │
│  ┌────────────────────────┐  │
│  │ 📖  Law                 │  │  feature card
│  └────────────────────────┘  │
│  ┌────────────────────────┐  │
│  │ 🚸  Road Signs          │  │
│  └────────────────────────┘  │
│  ┌────────────────────────┐  │
│  │ ✅  Quiz                │  │
│  └────────────────────────┘  │
└──────────────────────────────┘
```

### 2. Chapter list → 3. PDF reader
```
┌──────────────────────────────┐   ┌──────────────────────────────┐
│ ←  Traffic Law (2017)        │   │ ←  Chapter 3       p. 21/80  │
│ ┌──┐                         │   │                              │
│ │1 │ General provisions   ›  │   │      (PDF page, scroll       │
│ └──┘                         │   │       and pinch zoom)        │
│ ┌──┐                         │   │                              │
│ │2 │ …                    ›  │   │                              │
│ └──┘                         │   │                              │
└──────────────────────────────┘   └──────────────────────────────┘
```

### 4. Sign categories → 5. Sign detail
```
┌──────────────────────────────┐   ┌──────────────────────────────┐
│ ←  Road Signs                │   │ ←  Sign                      │
│ (Warning)(Ban)(Must)(Info)   │   │      ┌──────────────┐        │
│ ┌──────┐ ┌──────┐ ┌──────┐   │   │      │  big image   │        │
│ │ img  │ │ img  │ │ img  │   │   │      └──────────────┘        │
│ │ name │ │ name │ │ name │   │   │  Name (heading)              │
│ └──────┘ └──────┘ └──────┘   │   │  Meaning (body)              │
└──────────────────────────────┘   └──────────────────────────────┘
```

### 6. Topic list → 8. Result
```
┌──────────────────────────────┐   ┌──────────────────────────────┐
│ ←  Quiz                      │   │          Your score          │
│ [   📊 My Progress        ]  │   │            7 / 10            │
│ Speed          ▓▓▓▓░  80% ›  │   │             70%              │
│ Right of way   ▓▓░░░  45%    │   │                              │
│                [weak]     ›  │   │ [        Try again        ]  │
│ Parking        not started › │   │ [       My Progress       ]  │
└──────────────────────────────┘   └──────────────────────────────┘
```

### 9. My Progress
```
┌──────────────────────────────┐
│ ←  My Progress               │
│ Score per topic              │
│ Speed          ▓▓▓▓░  80%    │
│ Right of way   ▓▓░░░  45% weak
│ My mistakes (4)              │
│ [   Practice my mistakes   ] │
│ ┌────────────────────────┐   │
│ │ Q: …                    │   │
│ │ ✓ Correct: …            │   │
│ │ 💡 Explanation …        │   │
│ └────────────────────────┘   │
│               [Reset progress]│
└──────────────────────────────┘
Empty state: "No results yet" + [Start a quiz]
```

## 7. Figma file structure

- **Page "Styles":** color styles + text styles (section 2 and 3)
- **Page "Components":** all components from section 5, with variants for states
- **Page "Screens":** 9 screens + empty and error states
- **Prototype:** starting point = Home

## 8. Open questions for our next design talk
1. Approve the color hex values? (Section 2)
2. Answer letters: Khmer **ក ខ គ ឃ** or **1 2 3 4**?
3. App icon and name on the home screen: "Traffic Law KH" or a Khmer name?
4. Sign categories: what are the exact official category names from your source?
