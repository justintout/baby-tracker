import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/family.dart';

class FirestoreFamilyDataSource {
  FirestoreFamilyDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<Family> createFamily({
    required String name,
    required String userId,
    required String displayName,
  }) async {
    final docRef = _firestore.collection(FirestorePaths.families).doc();
    final now = DateTime.now();

    final family = Family(
      id: docRef.id,
      name: name,
      createdAt: now,
      createdBy: userId,
      memberIds: [userId],
      members: {
        userId: Member(
          role: MemberRole.owner,
          joinedAt: now,
          displayName: displayName,
        ),
      },
    );

    await docRef.set(_familyToFirestore(family));
    return family;
  }

  Future<Family?> getFamily(String familyId) async {
    final doc = await _firestore
        .collection(FirestorePaths.families)
        .doc(familyId)
        .get();

    if (!doc.exists) return null;
    return _familyFromFirestore(doc);
  }

  Stream<Family?> watchFamily(String familyId) {
    return _firestore
        .collection(FirestorePaths.families)
        .doc(familyId)
        .snapshots()
        .map((doc) => doc.exists ? _familyFromFirestore(doc) : null);
  }

  Stream<List<Family>> watchFamilies(List<String> familyIds) {
    if (familyIds.isEmpty) return Stream.value([]);

    return _firestore
        .collection(FirestorePaths.families)
        .where(FieldPath.documentId, whereIn: familyIds)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => _familyFromFirestore(doc)).toList());
  }

  Family _familyFromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final membersData = data['members'] as Map<String, dynamic>?;

    return Family(
      id: doc.id,
      name: data['name'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] as String,
      memberIds: List<String>.from(data['memberIds'] ?? []),
      members: membersData?.map(
            (key, value) {
              final memberData = value as Map<String, dynamic>;
              return MapEntry(
                key,
                Member(
                  role: MemberRole.values.firstWhere(
                    (r) => r.name == memberData['role'],
                    orElse: () => MemberRole.caregiver,
                  ),
                  joinedAt: (memberData['joinedAt'] as Timestamp).toDate(),
                  displayName: memberData['displayName'] as String,
                ),
              );
            },
          ) ??
          {},
    );
  }

  Map<String, dynamic> _familyToFirestore(Family family) {
    return {
      'name': family.name,
      'createdAt': Timestamp.fromDate(family.createdAt),
      'createdBy': family.createdBy,
      'memberIds': family.memberIds,
      'members': family.members.map(
        (key, value) => MapEntry(key, {
          'role': value.role.name,
          'joinedAt': Timestamp.fromDate(value.joinedAt),
          'displayName': value.displayName,
        }),
      ),
    };
  }
}
