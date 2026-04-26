# Fluxo App - 4-Milestone Implementation Plan (Flutter)

Based on the executive summary, this plan outlines the development of "Fluxo", a personal productivity mobile app using Flutter (Dart) and Generative AI (OpenRouter) with local storage and no backend.

## Milestone 1: Setup & Basic Navigation (Week 1)
**Objective:** Initialize the project, set up navigation, and create the basic UI structure.

*   **Task 1.1: Project Initialization**
    *   Initialize a new Flutter project (`flutter create fluxo`).
    *   Add core dependencies in `pubspec.yaml`: `provider`, `shared_preferences`, `speech_to_text`, `http`, `intl`, `flutter_slidable`.
*   **Task 1.2: App Configuration & Styling**
    *   Set up a global theme system (Light/Dark mode) using `ThemeData` based on the executive summary palette (Deep Blue `#1B3A5C`, Bright Blue `#2D7DD2`, Clean White).
*   **Task 1.3: Navigation Setup**
    *   Implement a `BottomNavigationBar` to handle tab routing between screens.
*   **Task 1.4: Screen Scaffolding**
    *   Create `lib/screens/home_screen.dart` (Hoje / Home).
    *   Create `lib/screens/capture_screen.dart` (Capturar).
    *   Create `lib/screens/history_screen.dart` (Histórico).
    *   Create `lib/screens/settings_screen.dart` (Configurações).

## Milestone 2: AI Integration & Core Logic (Week 2)
**Objective:** Connect the app to the OpenRouter API to process free-form text into structured tasks.

*   **Task 2.1: OpenRouter API Client**
    *   Create `lib/services/openrouter_service.dart`.
    *   Implement a method to send a POST request to `https://openrouter.ai/api/v1/chat/completions` using the `http` package.
*   **Task 2.2: System Prompt Definition**
    *   Create `lib/constants/prompts.dart`.
    *   Define the strict system prompt to enforce JSON output for tasks (`title`, `priority`, `category`, `duration_min`).
*   **Task 2.3: Text Capture Flow**
    *   Implement a `TextField` in `capture_screen.dart`.
    *   Add an "Organizar com IA" button that sends the text to `OpenRouterService`.
    *   Handle loading states and parse the returned JSON string into Dart `Task` model objects.

## Milestone 3: Voice Capture & Local Persistence (Week 3)
**Objective:** Add Speech-to-Text, save tasks locally, and display them.

*   **Task 3.1: Global State Management (Provider)**
    *   Create `lib/providers/task_provider.dart` to manage the list of tasks globally using `ChangeNotifier`.
*   **Task 3.2: Local Storage (SharedPreferences)**
    *   Integrate `shared_preferences` into `TaskProvider` for CRUD operations (`addTask`, `toggleTask`, `deleteTask`) so data persists across app restarts.
*   **Task 3.3: Voice Capture (STT)**
    *   Integrate the `speech_to_text` package in `capture_screen.dart`.
    *   Add a custom `MicButton` widget to start/stop recording and populate the text field.
*   **Task 3.4: Home Screen (Task List)**
    *   Implement a `TaskCard` widget in `lib/widgets/task_card.dart`.
    *   Use `ListView.builder` in `home_screen.dart` to display tasks ordered by priority (Alta -> Média -> Baixa).
*   **Task 3.5: Swipe Actions**
    *   Use the `flutter_slidable` package to add swipe gestures to `TaskCard` (Swipe right to complete, swipe left to delete/postpone).

## Milestone 4: Polish, History & Final Delivery (Week 4)
**Objective:** Finalize secondary screens, add polish, and prepare for delivery.

*   **Task 4.1: History Screen**
    *   Implement `history_screen.dart` to group completed/canceled tasks from the last 7 days using the `intl` package for formatting.
    *   Add a `StatsCard` widget to show the completion percentage.
*   **Task 4.2: Settings Screen**
    *   Implement `settings_screen.dart` to toggle themes, set a username, and clear all `SharedPreferences` data.
*   **Task 4.3: UX Polish**
    *   Add empty states, error handling (e.g., `Snackbar` for API failures), and loading animations.
    *   Ensure the Light/Dark theme toggle works consistently.
*   **Task 4.4: Documentation**
    *   Write a comprehensive `README.md` with setup and running instructions for the school project.

## Verification
Each milestone will be verified by running the app (`flutter run`) and testing the features on a simulator or physical device.
