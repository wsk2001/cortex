# App Architecture

<!-- AI fills this in during onboarding by scanning your project. -->
<!-- For a brand new project, AI creates this based on the planned structure. -->

All source lives in `src/`. [N] files organized into [N] folders:

```
src/
├── models/         ([N] files -- data models, business logic)
├── views/          ([N] files -- UI screens and components)
├── services/       ([N] files -- API, auth, storage)
└── utils/          ([N] files -- helpers, extensions)
```

## Entry Points

| File | Lines | Role |
|------|-------|------|
| <!-- e.g. --> `App.swift` | ~100 | App entry point. Setup, navigation, lifecycle. |

## Models/

| File | Lines | Role |
|------|-------|------|

## Views/

| File | Lines | Role |
|------|-------|------|

## Services/

| File | Lines | Role |
|------|-------|------|

## Utils/

| File | Lines | Role |
|------|-------|------|

## Data Flow

<!-- How data moves through the app. AI fills this in. -->

```
[Data source]
    ├── [Service 1] (what it provides)
    ├── [Service 2] (what it provides)
    └── [Service 3] (what it provides)

[Local storage]
    ├── [What's stored locally]
    └── [Cache strategy]
```
