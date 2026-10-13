# Flutter To-Do List App

A simple mobile app to manage your daily tasks, built with Flutter.

## Features

- Add, edit, and delete tasks
- Mark tasks as completed (with strikethrough)
- Swipe a task left to delete it, with undo support
- Filter tasks by status: **All**, **Active**, **Completed**
- Tasks are saved locally and persist between sessions
- Clean Material 3 interface

## Screenshots



## Project Structure

```
flutter_todo_app/
├── android/
├── ios/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   ├── task.dart             # Task model + JSON serialization
│   │   └── task_filter.dart      # Status filter enum
│   ├── screens/
│   │   ├── task_list_screen.dart # Main list screen
│   │   └── task_form_screen.dart # Add / edit form
│   ├── services/
│   │   └── task_repository.dart  # Local storage (shared_preferences)
│   └── widgets/
│       ├── task_tile.dart        # Single task row
│       ├── task_filter_bar.dart  # Filter selector
│       └── empty_state.dart      # Empty list placeholder
├── test/
├── assets/
├── pubspec.yaml
├── .gitignore
└── README.md
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart 3.12+)

### Install & run

```bash
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

### Analyze

```bash
flutter analyze
```

## Built With

- Flutter (Material 3)
- [shared_preferences](https://pub.dev/packages/shared_preferences) for local storage

## What I Learned

- Flutter widgets and layout
- Managing state with `setState`
- Building and validating forms
- Persisting data locally
