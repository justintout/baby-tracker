# Baby Tracker

A mobile app for tracking newborn information with real-time sync between caregivers.

## Features

- **Tracking**: Feedings (breast/bottle/formula), diaper changes, sleep/naps
- **Multi-user sync**: Parents and caregivers share access in real-time
- **Photos & videos**: Capture and share moments
- **Quick entry**: One-tap buttons, Siri Shortcuts, home screen widgets
- **Offline support**: Works without connectivity, syncs when online

## Tech Stack

- **Mobile App**: Flutter (iOS & Android)
- **Backend**: Go on Google Cloud Run
- **Database**: Firebase Firestore
- **Auth**: Firebase Auth
- **Storage**: Firebase Storage

## Project Structure

```
/backend/     # Go API server
/app/         # Flutter mobile app
/firebase/    # Firestore rules and indexes
```

## Development

### Prerequisites

- Flutter SDK 3.x
- Go 1.21+
- Firebase CLI
- Xcode (for iOS)
- Android Studio (for Android)

### Setup

See individual README files in `/backend` and `/app` directories.

## License

Proprietary - All rights reserved
