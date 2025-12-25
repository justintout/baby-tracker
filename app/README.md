# Baby Tracker App

Flutter mobile application for tracking newborn information.

## Prerequisites

- Flutter SDK 3.x
- Xcode (for iOS)
- Android Studio (for Android)
- Firebase project configured

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
flutterfire configure --project=YOUR_PROJECT_ID
```

### 3. Generate code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the app

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
    auth/            # Authentication
    family/          # Family & child management
    tracking/        # Entry tracking (feeding, diaper, sleep)
    media/           # Photo/video handling
    settings/        # App settings
  shared/            # Shared widgets and providers
  routing/           # Navigation (go_router)
  main.dart          # Entry point
  app.dart           # MaterialApp configuration
  bootstrap.dart     # Initialization
```

## State Management

Using **Riverpod** with code generation for type-safe, testable state management.

## Architecture

Clean Architecture with feature-based organization:
- **domain/**: Entities, repositories (interfaces), use cases
- **data/**: Repository implementations, data sources, models
- **presentation/**: Screens, widgets, providers
