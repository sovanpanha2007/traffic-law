# Traffic Law KH: Project Milestone 2

**Course:** CADT | IDT, Mobile Dev Term 19, Gen 11
**Team:** Vorng Viseth, Vong Sovanpanha
**Project:** Traffic Law KH, a Flutter app that teaches Cambodian traffic law in Khmer

---

## 1. Scope of this milestone

Milestone 2 covers the **model layer**, the **service layer** and the **test layer** for the whole app's logic: law chapters, road signs, quizzes, progress and saved content. The screens and the PDF viewer are not part of this submission.

Milestone 1 described the business goal, the users, the use cases and the functional requirements. This milestone implements the domain logic behind each of them.

## 2. Architecture

```text
lib/
├── models/
│   ├── question.dart
│   ├── topic.dart
│   ├── chapter.dart
│   ├── road_sign.dart
│   ├── quiz.dart
│   └── quiz_result.dart
├── service/
│   ├── quiz_service.dart
│   ├── progress_service.dart
│   ├── law_service.dart
│   └── sign_service.dart
└── data/
    ├── content_repository.dart
    └── progress_storage.dart
test/
├── quiz_service_test.dart
├── progress_service_test.dart
├── law_and_sign_service_test.dart
├── content_repository_test.dart
├── shared_prefs_storage_test.dart
└── test_data.dart
assets/data/
├── chapters.json
├── signs.json
└── questions.json
```

- **`models/`** holds the classes that represent the business domain. Each one has a `fromJson` factory where it is loaded from a file.
- **`service/`** holds the business operations and rules.
- **`data/`** loads the content files and saves progress. The services never touch the files or the phone directly.
- **`test/`** holds the tests. The tests use a fake storage class instead of the phone.

## 3. Model layer

The model contains six classes, which meets the requirement of at least 3.

### 3.1 Classes

| Class | Attributes | Methods | Role |
|---|---|---|---|
| `Topic` | `id` (String), `title` | `fromJson` | A quiz topic such as "speed" |
| `Question` | `id`, `topicId`, `text`, `image`, `options` (2 to 4), `correctIndex`, `explanation`, `lawPage` | `isCorrect(int)`, `fromJson` | One multiple-choice question |
| `Chapter` | `id` (int), `title`, `startPage` (at least 1), `topicId` (optional) | `fromJson` | One chapter of the law, linked to its quiz topic if it has one |
| `RoadSign` | `id`, `category`, `name`, `meaning`, `image` | `fromJson` | One road sign |
| `Quiz` | `questions` (list of `Question`), `answers` | `isFinished`, `currentQuestion`, `addAnswer(int)` | One quiz attempt |
| `QuizResult` | `topicId`, `score`, `total`, `wrongQuestionIds`, `correctQuestionIds`, `date` | `percent`, `fromJson`, `toJson` | The saved outcome of a quiz on one topic |

Constructors validate their input. For example, a `Question` must have 2 to 4 options and a `correctIndex` inside them, and a `Chapter` must start on page 1 or later.

### 3.2 Relationships

| Relationship | Type | Explanation |
|---|---|---|
| `Quiz` → `Question` | Aggregation | A quiz holds the questions it was built from. The questions exist independently. |
| `Question` → `Topic` (by `topicId`) | Association | Each question belongs to one topic. |
| `QuizResult` → `Topic` (by `topicId`) | Association | A saved result refers to the topic it was taken on. |
| `Chapter` → `Topic` (by `topicId`, optional) | Association | A chapter can name the quiz topic that tests it. A chapter with no quiz has no `topicId`. |
| `LawService` → `Chapter` | Aggregation | The service holds the chapter list, but the chapters exist on their own. |
| `SignService` → `RoadSign` | Aggregation | The service holds the signs, but the signs exist on their own. |
| `RoadSign` → category (by `category` ID) | Association | Each sign belongs to one category, identified by its ID. |

The model therefore has four composition or aggregation relationships, which meets the requirement of at least 2.

## 4. Service layer

The service layer contains four services with 15 business operations.

### 4.1 `QuizService`

| Operation | Uses | Description |
|---|---|---|
| `startTopicQuiz(topicId, allQuestions)` | `Question`, `Quiz` | Builds a quiz from one topic's questions. |
| `startPracticeQuiz(allQuestions, mistakeIds)` | `Question`, `Quiz` | Builds a quiz from the user's mistake questions, across topics. |
| `answer(quiz, index)` | `Quiz`, `Question` | Records an answer to the current question. |
| `finish(quiz)` | `Quiz`, `QuizResult` | Returns one `QuizResult` per topic covered, or `null` if the quiz isn't finished. |

### 4.2 `ProgressService`

| Operation | Uses | Description |
|---|---|---|
| `load()` | `ProgressStorage` | Loads saved results and mistakes into memory. |
| `saveResult(result)` | `QuizResult`, mistake list, `ProgressStorage` | Stores the result, adds wrong IDs to the mistake list, removes correct IDs, and saves both. Uses several entities at once. |
| `latestScoreByTopic()` | `QuizResult` list | Returns each topic's score from its newest result. |
| `isWeak(topicId)` | `latestScoreByTopic` | True when the latest score is below 70%. |
| `resetAll(confirmed)` | `ProgressStorage` | Clears all progress, only after confirmation. |

### 4.3 `LawService`

| Operation | Uses | Description |
|---|---|---|
| `chapters` | `Chapter` list | Returns chapters sorted by ID. |
| `findChapter(id)` | `Chapter` list | Returns the chapter with that ID. |
| `startPageFor(chapterId)` | `findChapter` | Returns the chapter's start page. |
| `chapterForTopic(topicId)` | `Chapter` list | Returns the chapter linked to a quiz topic, or `null` if none. |

### 4.4 `SignService`

| Operation | Uses | Description |
|---|---|---|
| `signsIn(categoryId)` | `RoadSign`, categories | Returns the signs in one category. |
| `findSign(id)` | `RoadSign` list | Returns the sign with that ID. |

### 4.5 Business rules

| # | Rule | Enforced by |
|---|---|---|
| R1 | A quiz cannot be started on a topic with no questions. | `QuizService.startTopicQuiz` |
| R2 | A question answered wrong is added to the mistake list. | `ProgressService.saveResult` |
| R3 | A mistake is removed after the user answers that question correctly once, in any quiz. | `ProgressService.saveResult` |
| R4 | A topic is "weak" when its latest score is below 70%. | `ProgressService.isWeak` |
| R5 | A quiz quit midway is not saved. | `QuizService.finish` returns `null` |
| R6 | A practice quiz needs at least one mistake. | `QuizService.startPracticeQuiz` |
| R7 | A saved result must have at least one question, and its correct and wrong IDs must add up to the total. | `ProgressService.saveResult` |
| R8 | Progress is only reset after the user confirms. | `ProgressService.resetAll` |
| R9 | A sign must belong to a known category. | `SignService` constructor |

### 4.6 Preconditions

| Operation | Precondition | Error if broken |
|---|---|---|
| `startTopicQuiz` | Topic has at least one question | `ArgumentError` |
| `startPracticeQuiz` | At least one mistake ID | `StateError` |
| `startPracticeQuiz` | At least one mistake exists in the content | `ArgumentError` |
| `answer` | Quiz isn't finished | `StateError` |
| `answer` | Index is inside the options | `RangeError` |
| `saveResult` | Total is at least 1 | `ArgumentError` |
| `saveResult` | Correct + wrong IDs equal the total | `ArgumentError` |
| `resetAll` | `confirmed` is `true` | `StateError` |
| `findChapter` | Chapter exists | `ArgumentError` |
| `signsIn` | Category exists | `ArgumentError` |
| `findSign` | Sign exists | `ArgumentError` |

## 5. Data layer

- **Sign categories** are unofficial for now. `assets/data/signs.json` lists four: Warning, Prohibition, Mandatory and Information, with a note to check them against the 2017 law before release. The docs planned 3–4 categories.
- **`ContentRepository`** loads `chapters.json`, `signs.json` and `questions.json` once and keeps them in memory. It rejects broken JSON, missing files, duplicate IDs, and questions with no explanation, and it reports each with a `ContentException`.
- **`ProgressStorage`** is an interface with `saveResult`, `loadResults`, `loadMistakeIds`, `saveMistakeIds` and `resetAll`, the names used in `ARCHITECTURE.md` §6 plus `saveMistakeIds`. **`SharedPrefsProgressStorage`** saves to the phone using the keys `quiz_results` and `mistake_ids`.
- The mistake rules (R2, R3) are applied in `ProgressService`, not in storage, so the business rules stay in the service layer. `latestScoreByTopic` is also in `ProgressService`, while `ARCHITECTURE.md` §6 lists it under storage.

## 6. Test layer

The test suite contains **36 test cases**, which meets the requirement of at least 5. Tests are grouped by the type of scenario they cover.

| # | Test | Type |
|---|---|---|
| T1 | A quiz with all correct answers scores full marks. | Normal |
| T2 | Wrong answers are recorded by question ID. | Normal |
| T3 | A question with `correctIndex` outside its options is rejected. | Invalid |
| T4 | Answering after a quiz is finished is rejected. | Invalid |
| T5 | Starting a quiz on a topic with no questions is rejected (R1). | Invalid |
| T6 | An answer index outside the options is rejected. | Invalid |
| T7 | `finish` returns `null` while questions are unanswered (R5). | Boundary |
| T8 | A practice quiz across two topics gives one result per topic. | Multi-entity |
| T9 | A practice quiz with no mistakes is rejected (R6). | Invalid |
| T10 | A practice quiz whose mistakes are not in the content is rejected. | Invalid |
| T11 | A score of exactly 70% is not weak (R4). | Boundary |
| T12 | A correct answer removes the question from the mistake list (R3). | Special case |
| T13 | Saving a result writes results and mistakes to storage. | Normal |
| T14 | Progress survives a restart. | Normal |
| T15 | The latest score by topic uses the newest result. | Normal |
| T16 | A result with no questions is rejected (R7). | Invalid |
| T17 | A result whose IDs don't add up to the total is rejected (R7). | Invalid |
| T18 | Reset without confirmation is rejected (R8). | Invalid |
| T19 | Confirmed reset clears results and mistakes. | Normal |
| T20 | Chapters load from JSON in stored order. | Normal |
| T21 | A second load does not read the file again. | Normal |
| T22 | Broken JSON shows an error, not a crash. | Invalid |
| T23 | A missing file shows an error. | Invalid |
| T24 | Duplicate question IDs are rejected. | Invalid |
| T25 | A question with no explanation is rejected. | Invalid |
| T26 | A chapter cannot start before page 1. | Boundary |
| T27 | Chapters are returned in ID order. | Normal |
| T28 | The start page of a chapter is found by ID. | Normal |
| T29 | An unknown chapter is rejected. | Invalid |
| T30 | Signs are filtered by category. | Normal |
| T31 | An unknown category is rejected. | Invalid |
| T32 | A sign with an unknown category is rejected (R9). | Invalid |
| T33 | Results and mistakes survive save and load on phone storage. | Normal |
| T34 | Reset removes all saved progress from phone storage. | Normal |
| T35 | A chapter is found from its linked quiz topic. | Normal |
| T36 | A chapter with no quiz topic is allowed, and no topic finds it. | Boundary |

Tests T1, T2, T8 and T13 cover the multi-entity operations, because they involve several classes at once.

## 7. How to run

```bash
flutter pub get
flutter analyze
flutter test
```

## 8. Results

| Check | Result |
|---|---|
| `flutter analyze` | No issues found |
| `flutter test` | All 36 tests passed |
