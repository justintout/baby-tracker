# Baby Tracker App

Flutter mobile application for tracking newborn activities with real-time multi-caregiver sync.

## Features

- **Magic Link Authentication** - Passwordless email sign-in via Firebase Auth
- **Multiple Baby Profiles** - Create families, add multiple babies, switch between them
- **Activity Tracking** - Log feedings, diaper changes, sleep sessions
- **Growth Measurements** - Track weight (lbs/oz), height, head circumference
- **Insights & Charts** - Daily summaries, growth charts, feeding trends (fl_chart)
- **Real-time Sync** - Firestore-powered sync across devices

## Tech Stack

- **Frontend**: Flutter 3.x with Riverpod state management
- **Backend**: Go 1.24 on Google Cloud Run
- **Database**: Firebase Firestore (real-time sync)
- **Auth**: Firebase Auth (magic link)
- **CI/CD**: GitHub Actions

## Prerequisites

- Flutter SDK 3.x
- Xcode (for iOS)
- Android Studio (for Android)
- Firebase CLI (`npm install -g firebase-tools`)

## Setup

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Configure Firebase

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure --project=baby-tracker-88ca3
```

### 3. Deploy Firestore Rules

```bash
firebase deploy --only firestore:rules
```

### 4. Generate code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Run the app

```bash
# iOS Simulator
flutter run -d ios

# Android Emulator
flutter run -d android
```

## Project Structure

```
lib/
  core/              # Core utilities, theme, constants
  features/          # Feature modules (clean architecture)
    auth/            # Magic link authentication
    family/          # Family & baby profile management
    tracking/        # Entry tracking (feeding, diaper, sleep)
    media/           # Photo/video handling
    settings/        # App settings
  shared/            # Shared widgets and providers
  routing/           # Navigation (go_router)
  main.dart          # Entry point
  app.dart           # MaterialApp configuration
  bootstrap.dart     # Firebase initialization
```

## Architecture

Clean Architecture with feature-based organization:

```
feature/
  domain/           # Business logic (no Flutter dependencies)
    entities/       # Immutable data classes (freezed)
    repositories/   # Abstract interfaces
  data/             # Implementation details
    datasources/    # Firebase/API data sources
    repositories/   # Repository implementations
  presentation/     # UI layer
    providers/      # Riverpod state management
    screens/        # Full-page widgets
    widgets/        # Reusable components
```

## State Management

Using **Riverpod** for reactive state management:
- `StreamProvider` for Firestore real-time listeners
- `StateNotifierProvider` for mutation controllers
- `Provider` for dependency injection

## Firestore Structure

```
users/{userId}
  - email, displayName, familyIds[], settings{}

families/{familyId}
  - name, createdBy, memberIds[], members{}
  └── children/{childId}
        - name, birthDate, photoURL
        ├── entries/{entryId}
        │     - type (feeding/diaper/sleep), timestamp, feedingType, amount, etc.
        └── measurements/{measurementId}
              - date, weightOz, heightInches, headCircumferenceInches
```
