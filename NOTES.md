# Baby Tracker - Development Notes

## Architecture Decisions

### 2024-12-25: Initial Architecture

**Stack Selection**:
- Firebase ecosystem (Auth, Firestore, Storage) for real-time sync and offline support
- Go backend on Cloud Run for complex operations (invitations, media processing, exports)
- Flutter with Riverpod for cross-platform mobile

**Data Access Pattern**:
- Direct Firestore access from Flutter for CRUD operations
- Security rules enforce access control
- Backend uses Admin SDK for privileged operations

**Tracking Data Model**:
- Single `entries` collection with `type` field (feeding/diaper/sleep)
- Enables unified timeline queries
- Type-specific fields are nullable

**Conflict Resolution**:
- Last-write-wins (Firestore default)
- Acceptable for additive tracking data
- Entries rarely edited after creation

---

## Monetization Ideas (Deferred)

- Freemium: Free tier with limited history (30 days)
- Paid: Unlimited history, priority support
- Storage tiers for photos/videos
- Ad-free option

---

## TODO / Future Features

- [ ] Apple Watch complication
- [ ] Android widget
- [ ] Growth charts
- [ ] Pediatrician export (PDF)
- [ ] Alexa/Google Home integration
- [ ] Feeding reminders/notifications

---

## Known Issues

(None yet)

---

## Resources

- [Firebase Flutter Setup](https://firebase.google.com/docs/flutter/setup)
- [Cloud Run Go Quickstart](https://cloud.google.com/run/docs/quickstarts/build-and-deploy/go)
- [Riverpod Documentation](https://riverpod.dev/)
