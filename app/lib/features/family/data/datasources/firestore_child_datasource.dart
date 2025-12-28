import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/child.dart';

class FirestoreChildDataSource {
  FirestoreChildDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<Child> createChild({
    required String familyId,
    required String name,
    required DateTime birthDate,
    String? photoURL,
  }) async {
    final collectionPath = FirestorePaths.childrenCollection(familyId);
    final docRef = _firestore.collection(collectionPath).doc();
    final now = DateTime.now();

    final child = Child(
      id: docRef.id,
      familyId: familyId,
      name: name,
      birthDate: birthDate,
      photoURL: photoURL,
      createdAt: now,
      updatedAt: now,
    );

    await docRef.set(_childToFirestore(child));
    return child;
  }

  Future<Child?> getChild(String familyId, String childId) async {
    final doc =
        await _firestore.doc(FirestorePaths.child(familyId, childId)).get();

    if (!doc.exists) return null;
    return _childFromFirestore(doc, familyId);
  }

  Stream<Child?> watchChild(String familyId, String childId) {
    return _firestore
        .doc(FirestorePaths.child(familyId, childId))
        .snapshots()
        .map((doc) => doc.exists ? _childFromFirestore(doc, familyId) : null);
  }

  Stream<List<Child>> watchChildren(String familyId) {
    return _firestore
        .collection(FirestorePaths.childrenCollection(familyId))
        .orderBy('createdAt')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _childFromFirestore(doc, familyId))
            .toList());
  }

  Future<Child> updateChild({
    required String familyId,
    required String childId,
    String? name,
    DateTime? birthDate,
    String? photoURL,
  }) async {
    final docRef = _firestore.doc(FirestorePaths.child(familyId, childId));
    final updates = <String, dynamic>{
      'updatedAt': Timestamp.now(),
    };

    if (name != null) updates['name'] = name;
    if (birthDate != null) updates['birthDate'] = Timestamp.fromDate(birthDate);
    if (photoURL != null) updates['photoURL'] = photoURL;

    await docRef.update(updates);

    final doc = await docRef.get();
    return _childFromFirestore(doc, familyId);
  }

  Future<void> deleteChild(String familyId, String childId) async {
    await _firestore.doc(FirestorePaths.child(familyId, childId)).delete();
  }

  Child _childFromFirestore(DocumentSnapshot doc, String familyId) {
    final data = doc.data() as Map<String, dynamic>;
    return Child(
      id: doc.id,
      familyId: familyId,
      name: data['name'] as String,
      birthDate: (data['birthDate'] as Timestamp).toDate(),
      photoURL: data['photoURL'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> _childToFirestore(Child child) {
    return {
      'name': child.name,
      'birthDate': Timestamp.fromDate(child.birthDate),
      'photoURL': child.photoURL,
      'createdAt': Timestamp.fromDate(child.createdAt),
      'updatedAt': Timestamp.fromDate(child.updatedAt),
    };
  }
}
