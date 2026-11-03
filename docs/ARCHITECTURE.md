# Traffic Law KH — Architecture

Beginner-friendly. We use **the simplest tools that work**, because we are new to Flutter and have about 1 hour a day each.

## 1. The big picture

```
            ┌───────────── assets (inside the app, read-only) ─────────────┐
            │  pdf/traffic_law_2017.pdf   data/*.json   images/signs/*.png   │
            └───────────────────────────────┬───────────────────────────────┘
                                            │ load once
                                  ContentRepository
                                            │ gives models (Chapter, RoadSign, Question…)
                                            ▼
   Home ──► Law screens      Signs screens      Quiz screens ──► Result ──► My Progress
                                                      │                         ▲
                                                      │ save result             │ read results
                                                      ▼                         │
                                            ProgressStorage (shared_preferences, on the phone)
```

- **Content** (law, signs, questions) never changes while the app runs. It lives in JSON files inside the app.
- **Progress** (quiz results, mistakes) changes. It is saved on the phone with `shared_preferences`.

## 2. Screens and navigation

We use Flutter's built-in `Navigator.push` with `MaterialPageRoute`, so we need no router package. Back is the normal back button or gesture.

```
HomeScreen
├── ChapterListScreen ──► PdfReaderScreen(startPage)
├── SignCategoryScreen ──► SignDetailScreen(sign)
└── TopicListScreen
     ├── QuestionScreen(topic) ──► ResultScreen(result) ──► ProgressScreen
     └── ProgressScreen ──► QuestionScreen(mistakes only)
```

| Screen | File | Job |
|---|---|---|
| HomeScreen | `screens/home/home_screen.dart` | 3 big cards: Law, Road Signs, Quiz |
| ChapterListScreen | `screens/law/chapter_list_screen.dart` | List of chapters from `chapters.json` |
| PdfReaderScreen | `screens/law/pdf_reader_screen.dart` | Shows the law PDF and opens it at `startPage` |
| SignCategoryScreen | `screens/signs/sign_category_screen.dart` | Category tabs/chips + a grid of signs |
| SignDetailScreen | `screens/signs/sign_detail_screen.dart` | Big picture, name, meaning |
| TopicListScreen | `screens/quiz/topic_list_screen.dart` | Quiz topics + "My Progress" button |
| QuestionScreen | `screens/quiz/question_screen.dart` | One question at a time, answer feedback, explanation |
| ResultScreen | `screens/quiz/result_screen.dart` | Score, buttons: "Try again", "My Progress" |
| ProgressScreen | `screens/quiz/progress_screen.dart` | Score per topic + mistakes list |

## 3. Folder structure

```
traffic-law/
├── lib/
│   ├── main.dart                 # starts the app
│   ├── app.dart                  # MaterialApp, theme, HomeScreen
│   ├── core/
│   │   ├── app_theme.dart        # colors, fonts, text styles (from DESIGN.md)
│   │   └── strings.dart          # ALL Khmer UI text in one place
│   ├── models/
│   │   ├── chapter.dart
│   │   ├── road_sign.dart
│   │   ├── topic.dart
│   │   ├── question.dart
│   │   └── quiz_result.dart
│   ├── data/
│   │   ├── content_repository.dart   # reads JSON from assets
│   │   └── progress_storage.dart     # saves/reads progress on the phone
│   ├── screens/
│   │   ├── home/  law/  signs/  quiz/
│   └── widgets/                  # reusable UI pieces (see DESIGN.md)
│       ├── feature_card.dart
│       ├── answer_option.dart
│       ├── explanation_box.dart
│       ├── topic_progress_tile.dart
│       └── empty_state.dart
├── assets/
│   ├── pdf/traffic_law_2017.pdf
│   ├── data/chapters.json  signs.json  questions.json
│   ├── images/signs/             # one PNG per sign, e.g. w01.png
│   └── fonts/                    # Kantumruy Pro .ttf files
├── test/                         # unit tests (models, storage, score logic)
└── docs/                         # these planning docs
```

**Rule to avoid Git conflicts:** each person owns different files. Viseth owns `screens/home`, `screens/law`, `screens/signs`, `screens/quiz/progress_screen.dart`, `chapters.json`, `signs.json`. Sue owns `core/`, `models/`, `data/`, the other files in `screens/quiz`, and `questions.json`. `pubspec.yaml` is changed **only by Viseth**: ask him if you need a package or asset folder.

## 4. Data models

| Model | Fields | Example |
|---|---|---|
| `Chapter` | `id` (int), `title` (String), `startPage` (int) | 3, "ល្បឿន", 21 |
| `RoadSign` | `id` (String), `category` (String), `name` (String), `meaning` (String), `image` (String path) | "w01", "warning", … |
| `Topic` | `id` (String), `title` (String) | "speed", "ល្បឿន" |
| `Question` | `id` (String), `topicId`, `text`, `image` (optional), `options` (List of 2–4 String), `correctIndex` (int), `explanation` (String), `lawPage` (optional int) | – |
| `QuizResult` | `topicId`, `date` (ISO text), `score` (int), `total` (int), `wrongQuestionIds` (List of String) | "speed", "2026-11-20T09:15", 7, 10, ["sp03", …] |

Each model has a `fromJson` factory. `QuizResult` also has `toJson`, because we save it.

## 5. JSON content format

`assets/data/chapters.json`
```json
[
  { "id": 1, "title": "បទប្បញ្ញត្តិទូទៅ", "startPage": 1 }
]
```

`assets/data/signs.json`
```json
{
  "categories": [
    { "id": "warning", "title": "ស្លាកសញ្ញាព្រមាន" }
  ],
  "signs": [
    {
      "id": "w01",
      "category": "warning",
      "name": "…",
      "meaning": "…",
      "image": "assets/images/signs/w01.png"
    }
  ]
}
```

`assets/data/questions.json`
```json
{
  "topics": [
    { "id": "speed", "title": "ល្បឿន" }
  ],
  "questions": [
    {
      "id": "sp01",
      "topicId": "speed",
      "text": "…",
      "image": null,
      "options": ["…", "…", "…"],
      "correctIndex": 1,
      "explanation": "…",
      "lawPage": 21
    }
  ]
}
```

**JSON rules:** write it in VS Code (it marks errors in red), use UTF-8, give every item a unique `id`, never change an `id` after release (saved progress uses it), and `correctIndex` starts at **0**.

## 6. Local storage plan (`progress_storage.dart`)

We use **`shared_preferences`** (saves small key–value data on the phone). Two keys:

| Key | Value | When it changes |
|---|---|---|
| `quiz_results` | JSON text: list of `QuizResult` | After each finished quiz |
| `mistake_ids` | List of question IDs | Add wrong IDs after a quiz. Remove an ID when it is answered correctly. |

Methods:
- `saveResult(QuizResult r)` adds the result and updates `mistake_ids`
- `loadResults()` → `List<QuizResult>`
- `latestScoreByTopic()` → `Map<topicId, percent>` (topic score = latest quiz in that topic)
- `loadMistakeIds()` → `List<String>`
- `resetAll()` (with a confirm dialog in the UI)

A quiz quit in the middle is never saved.

## 7. How screens, state and data talk

- **State management:** only `setState` (Flutter's built-in way to redraw a screen when its data changes). No Provider or Riverpod. No data must be shared live between screens: each screen loads what it needs when it opens.
- **ContentRepository** loads each JSON file **once** and keeps it in memory, so the next screens are fast.
- **Passing data:** through constructor arguments, for example `QuestionScreen(topic: t)` or `PdfReaderScreen(startPage: 21)`.
- **Loading pattern** (the same in every screen):
  ```dart
  late Future<List<Chapter>> _future;

  @override
  void initState() {
    super.initState();
    _future = ContentRepository.instance.loadChapters();
  }
  // build(): FutureBuilder shows loading → error message → list
  ```
- **ProgressScreen** reloads data every time it opens, so it always shows the newest results.

## 8. Package decision log

| Package / tool | Version | Why we chose it |
|---|---|---|
| Flutter (stable) | 3.47.x (3.47.9, released Oct 29, 2026), with Dart 3.13 | Latest stable. `pdfrx` needs Flutter 3.47 or later. Both members must use the same version: check with `flutter --version`. |
| `pdfrx` | `^2.10.1` (MIT license) | Free PDF viewer built on PDFium (Google's PDF engine). Opens a PDF from assets (`PdfViewer.asset`), pinch zoom, go to a page. Syncfusion needs a license, so we don't use it. Needs iOS 15 or later. |
| `shared_preferences` | `^2.5.6` | Official Flutter team package. Simple and enough for our small progress data. Needs Flutter 3.41 or later. |
| State: `setState` | built-in | Easiest for beginners. Nothing needs global state. |
| Navigation: `Navigator` | built-in | Only 9 screens, simple push/pop. |
| Font: Kantumruy Pro | `.ttf` files in `assets/fonts` | Clear Khmer font, free from Google Fonts (open font license). We bundle the files, **not** the `google_fonts` package, because that package downloads fonts from the internet, and our app must work offline. |
| `flutter_lints` | comes with `flutter create` | Shows code-style warnings in `flutter analyze`. |

> Check versions on Day 1 with `flutter pub add pdfrx shared_preferences`, then write the real numbers from `pubspec.lock` here.

## 9. Technical spike (do before feature coding)

The PDF is our riskiest part. The **spike** (a small test app) must prove:
1. `PdfViewer.asset('assets/pdf/traffic_law_2017.pdf')` shows the law with **correct Khmer** on the Android emulator and the iOS Simulator.
2. The viewer can open at a given page (for example page 21) using the controller or an initial-page setting. Check the exact method name in the pdfrx docs.
3. Pinch zoom and scrolling are smooth.

If it fails: try the other free package (`pdfx`), or as a last option, show each chapter's pages as PNG images.
