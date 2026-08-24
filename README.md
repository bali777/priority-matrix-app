# Priority Matrix

A dark-themed task manager built with Flutter, based on an **impact / effort
matrix** (a variant of the Eisenhower Matrix). Sort tasks by dragging cards
between four quadrants, keep new items in the inbox strip, and tick things off
as you go.

## What's new in this revision

The project previously could not launch at all. This revision fixes:

1. **Entry point** — `main.dart` now lives at `lib/main.dart`, the path the
   Flutter tool actually runs. (It used to sit in the repository root, so
   `flutter run` found no app to launch.)
2. **Runtime crash** — the quadrant `DragTarget` builders returned `Expanded`
   widgets, which is illegal inside a non-Flex parent ("Incorrect use of
   ParentDataWidget"). The layout was rebuilt so `Expanded` wraps the
   `DragTarget`.
3. **Missing platform scaffolding** — the repository had no `android/`,
   `ios/` or `web/` folders, so there was nothing to build. They are now
   generated from the official Flutter 3.47 templates (Kotlin DSL, AGP 9.1.0).
4. **Dead UI** — the checkbox icon was not tappable and "New Task" cards could
   not be renamed. Tasks are now fully interactive: add, rename, move, toggle,
   delete.
5. Project hygiene — `.gitignore`, `analysis_options.yaml`, widget tests and
   this README were added; the unused `cupertino_icons` dependency was
   dropped.

## Quadrants

|                      | Difficult            | Easy                      |
| -------------------- | -------------------- | ------------------------- |
| **High impact**      | 1 — Big bets: plan   | 2 — Quick wins: do first  |
| **Low impact**       | 3 — Time sinks: cut  | 4 — Filler: if time allows|

## Getting started

### English

```bash
# 1. Install the Flutter SDK (3.10 or newer) — https://docs.flutter.dev/get-started/install
flutter doctor          # make sure your toolchain is healthy

# 2. Fetch dependencies (none are hosted — works offline)
flutter pub get

# 3. Run it
flutter run             # chooses an attached device/emulator
flutter run -d chrome   # or in the browser
```

Build a release APK with `flutter build apk` (output in `build/app/outputs/`).

> **Upgrading / repairing the platform folders:** if your Flutter version is
> older or newer than the templates committed here, regenerate them with
> ```bash
> flutter create . --platforms android,ios,web --project-name priority_matrix_app
> ```
> This keeps your Dart code and only refreshes the native scaffolding.

### اردو

1. پہلے [Flutter SDK](https://docs.flutter.dev/get-started/install) انسٹال کریں اور `flutter doctor` چلا کر سب ٹھیک ہونے کی تصدیق کریں۔
2. `flutter pub get` چلائیں۔
3. `flutter run` چلائیں — ایپ فون کے ایمولیٹر یا براؤزر (`flutter run -d chrome`) پر کھل جائے گی۔

**اصل خرابی کیا تھی؟** `main.dart` غلط جگہ (`lib/` کے باہر) تھی، `android/` وغیرہ فولڈرز موجود ہی نہیں تھے، اور ایک لے آؤٹ بگ (`DragTarget` کے اندر `Expanded`) کی وجہ سے ایپ کریش ہو جاتی تھی — تینوں اب ٹھیک کر دیے گئے ہیں۔

## Features

- 2×2 impact/effort matrix + inbox strip
- Drag & drop tasks between quadrants (drop zones highlight on hover)
- Add tasks through a dialog with title + quadrant picker
- Tap a card to edit (rename, move, mark complete)
- Long-press a card to delete it
- Per-quadrant accent colours and task counts
- Dark theme, Material 3

## Project structure

```
lib/
  main.dart            # app entry point & theme
  matrix_screen.dart   # the board, dialogs, drag & drop
  task_card.dart       # interactive card widget
  task_model.dart      # Task model + TaskQuadrant enum
test/
  widget_test.dart     # basic smoke tests
android/ ios/ web/     # generated platform scaffolding
```

## Roadmap ideas

- Persist tasks with `shared_preferences` or a local database
- Due dates & reminders
- Undo for deletions
