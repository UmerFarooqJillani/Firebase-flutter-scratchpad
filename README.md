# <p align="center"> Firebase Scratchpad</p>

## Repo Structure
```dart
firebase-scratchpad/
│
├── README.md
├── pubspec.yaml
├── analysis_options.yaml
├── .gitignore
│
├── docs/               // This is a theory layer.
│   ├── 00_overview/
│   │   ├── learning-roadmap.md
│   │   ├── firebase-mental-model.md
│   │   └── glossary.md
│   │
│   ├── 01_setup/
│   │   ├── firebase-project-setup.md
│   │   ├── flutterfire-configuration.md
│   │   └── common-setup-errors.md
│   │
│   ├── 02_core/
│   │   ├── firebase-core.md
│   │   ├── initialization-flow.md
│   │   └── under-the-hood.md
│   │
│   ├── 03_auth/
│   │   ├── email-password-auth.md
│   │   ├── auth-state-flow.md
│   │   ├── token-session-explanation.md
│   │   └── common-auth-errors.md
│   │
│   ├── 04_firestore/
│   │   ├── collections-documents.md
│   │   ├── crud-operations.md
│   │   ├── realtime-streams.md
│   │   └── firestore-data-modeling.md
│   │
│   ├── 05_storage/
│   │   ├── file-upload-flow.md
│   │   ├── download-urls.md
│   │   └── storage-link-with-firestore.md
│   │
│   ├── 06_rules/
│   │   ├── firestore-rules.md
│   │   ├── storage-rules.md
│   │   └── security-thinking.md
│   │
│   ├── 07_architecture/
│   │   ├── feature-first-structure.md
│   │   ├── repository-pattern.md
│   │   ├── service-layer.md
│   │   └── state-management-notes.md
│   │
│   ├── 08_offline_and_cache/
│   │   ├── offline-behavior.md
│   │   ├── sync-mental-model.md
│   │   └── conflict-thinking.md
│   │
│   ├── 09_testing/
│   │   ├── emulator-suite.md
│   │   ├── mock-vs-real-firebase.md
│   │   └── testing-strategy.md
│   │
│   └── 10_production/
│       ├── crash-handling.md
│       ├── performance-notes.md
│       ├── deployment-checklist.md
│       └── common-production-mistakes.md
│
├── lib/                // This is a practice layer.
│   ├── main.dart
│   ├── app/
│   │   ├── app.dart
│   │   ├── routes/
│   │   │   └── app_router.dart
│   │   └── theme/
│   │       └── app_theme.dart
│   │
│   ├── core/
│   │   ├── config/
│   │   │   └── firebase_config_notes.dart
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   ├── errors/
│   │   │   ├── app_exception.dart
│   │   │   └── firebase_failure_mapper.dart
│   │   ├── utils/
│   │   │   ├── logger.dart
│   │   │   └── validators.dart
│   │   └── widgets/
│   │       ├── app_loader.dart
│   │       └── app_error_view.dart
│   │
│   ├── services/     // This is where direct Firebase SDK interaction begins.
│   │   ├── firebase/
│   │   │   ├── firebase_initializer.dart
│   │   │   ├── auth_service.dart
│   │   │   ├── firestore_service.dart
│   │   │   └── storage_service.dart
│   │   └── local/
│   │       └── local_notes_service.dart
│   │
│   ├── features/
│   │   ├── dashboard/
│   │   │   └── presentation/
│   │   │       └── dashboard_screen.dart
│   │   │
│   │   ├── auth/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   ├── models/
│   │   │   │   └── repositories/
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   ├── repositories/
│   │   │   │   └── usecases/
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       ├── screens/
│   │   │       └── widgets/
│   │   │
│   │   ├── profile/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   ├── notes/
│   │   │   ├── data/
│   │   │   ├── domain/
│   │   │   └── presentation/
│   │   │
│   │   └── storage_demo/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   │
│   └── firebase_options.dart
│
├── assets/
│   ├── images/
│   └── icons/
│
└── test/
    ├── unit/
    ├── widget/
    └── integration/
```
--- 
