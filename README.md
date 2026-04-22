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
│   │   ├── learning.md
│   │   ├── ...
│   │   └── ...
│   │
│   └── 01_setup/
│       ├── firebase.md
│       ├── ***.md
│       └── ...
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
│   │   │   └── ...
│   │   ├── utils/
│   │   │   ├── ...
│   │   │   └── validators.dart
│   │   └── widgets/
│   │       ├── ...
│   │       └── ...
│   │
│   ├── services/     // This is where direct Firebase SDK interaction begins.
│   │   ├── firebase/
│   │   │   ├── firebase_initializer.dart
│   │   │   └── ...
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
