# Decisions

| Date | Decision | Why |
|---|---|---|
| 2026-11-16 | Add a `SignCategory` model that holds its signs. | The M2 brief needs 2 aggregations inside the model layer. It also makes the sign data easier to use in screens. |
| 2026-11-20 | Rename `lib/models/` to `lib/model/`. | The M2 brief requires `lib/model/`. |
| 2026-11-20 | Keep "weak" at below 70%. | We don't know the real test's pass mark. It is one constant, `ProgressService.weakThreshold`. |
| 2026-11-20 | English content will come as one set of JSON files per language. | English is planned. Only `ContentRepository` changes; models and services stay the same. |
| 2026-11-20 | Keep every quiz result, with no limit. | Needed for a future chart of past scores. Review if storage grows too large. |
