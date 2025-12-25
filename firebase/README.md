# Firebase Configuration

## Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable the following services:
   - **Authentication**: Email/Password, Google, Apple Sign-In
   - **Cloud Firestore**: Start in production mode
   - **Cloud Storage**: Start in production mode

### 2. Configure Flutter App

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase (run from /app directory)
cd app
flutterfire configure --project=YOUR_PROJECT_ID
```

This will generate `lib/firebase_options.dart`.

### 3. Configure Go Backend

1. Go to Firebase Console → Project Settings → Service Accounts
2. Generate new private key
3. Save as `serviceAccountKey.json` (gitignored)
4. Set environment variable:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/serviceAccountKey.json
```

### 4. Deploy Security Rules

```bash
# From project root
firebase deploy --only firestore:rules,storage:rules
```

## Files

- `firestore.rules` - Firestore security rules
- `storage.rules` - Cloud Storage security rules
- `firestore.indexes.json` - Composite index definitions

## Security Rules Overview

### Firestore

- **Users**: Can only write own document, all signed-in users can read
- **Families**: Members can read/write, only creator can delete
- **Children**: Family members only
- **Entries**: Family members can read/create, creator can delete
- **Media**: Family members can read, creator can update/delete
- **Invitations**: Read-only from client, backend writes via Admin SDK

### Storage

- **Media files**: 50MB max, images/videos only, family members only
- **Profile photos**: 5MB max, images only, owner or family members
