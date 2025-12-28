import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/user.dart';

class FirestoreUserDataSource {
  FirestoreUserDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<AppUser?> getUser(String userId) async {
    final doc = await _firestore.doc(FirestorePaths.user(userId)).get();
    if (!doc.exists) return null;
    return _userFromFirestore(doc);
  }

  Stream<AppUser?> watchUser(String userId) {
    return _firestore
        .doc(FirestorePaths.user(userId))
        .snapshots()
        .map((doc) => doc.exists ? _userFromFirestore(doc) : null);
  }

  Future<void> saveUser(AppUser user) async {
    await _firestore.doc(FirestorePaths.user(user.id)).set(
          _userToFirestore(user),
          SetOptions(merge: true),
        );
  }

  Future<void> updateSettings({
    required String userId,
    String? defaultChildId,
    bool? notifications,
    String? theme,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': Timestamp.now(),
    };

    if (defaultChildId != null) {
      updates['settings.defaultChildId'] = defaultChildId;
    }
    if (notifications != null) {
      updates['settings.notifications'] = notifications;
    }
    if (theme != null) {
      updates['settings.theme'] = theme;
    }

    await _firestore.doc(FirestorePaths.user(userId)).update(updates);
  }

  Future<void> addFamilyToUser(String userId, String familyId, {String? email}) async {
    final docRef = _firestore.doc(FirestorePaths.user(userId));
    final doc = await docRef.get();

    if (doc.exists) {
      // Update existing user
      await docRef.update({
        'familyIds': FieldValue.arrayUnion([familyId]),
        'updatedAt': Timestamp.now(),
      });
    } else {
      // Create new user document
      await docRef.set({
        'email': email ?? '',
        'familyIds': [familyId],
        'settings': {
          'notifications': true,
          'theme': 'system',
        },
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      });
    }
  }

  AppUser _userFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final settingsData = data['settings'] as Map<String, dynamic>?;

    return AppUser(
      id: doc.id,
      email: data['email'] as String,
      displayName: data['displayName'] as String?,
      photoURL: data['photoURL'] as String?,
      familyIds: List<String>.from(data['familyIds'] ?? []),
      settings: settingsData != null
          ? UserSettings(
              defaultChildId: settingsData['defaultChildId'] as String?,
              notifications: settingsData['notifications'] as bool? ?? true,
              theme: settingsData['theme'] as String? ?? 'system',
            )
          : const UserSettings(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> _userToFirestore(AppUser user) {
    return {
      'email': user.email,
      'displayName': user.displayName,
      'photoURL': user.photoURL,
      'familyIds': user.familyIds,
      'settings': {
        'defaultChildId': user.settings.defaultChildId,
        'notifications': user.settings.notifications,
        'theme': user.settings.theme,
      },
      'createdAt': user.createdAt != null
          ? Timestamp.fromDate(user.createdAt!)
          : FieldValue.serverTimestamp(),
      'updatedAt': Timestamp.now(),
    };
  }
}
