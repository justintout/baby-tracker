import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../domain/entities/entry.dart';

class FirestoreEntryDataSource {
  FirestoreEntryDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<Entry> createEntry(Entry entry) async {
    final collectionPath =
        FirestorePaths.entriesCollection(entry.familyId, entry.childId);
    final docRef = _firestore.collection(collectionPath).doc();

    final entryWithId = entry.copyWith(id: docRef.id);
    await docRef.set(_entryToFirestore(entryWithId));
    return entryWithId;
  }

  Future<Entry?> getEntry(
      String familyId, String childId, String entryId) async {
    final doc = await _firestore
        .doc(FirestorePaths.entry(familyId, childId, entryId))
        .get();

    if (!doc.exists) return null;
    return _entryFromFirestore(doc, familyId, childId);
  }

  Stream<List<Entry>> watchEntries(String familyId, String childId) {
    return _firestore
        .collection(FirestorePaths.entriesCollection(familyId, childId))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _entryFromFirestore(doc, familyId, childId))
            .toList());
  }

  Stream<List<Entry>> watchEntriesForDate(
    String familyId,
    String childId,
    DateTime date,
  ) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _firestore
        .collection(FirestorePaths.entriesCollection(familyId, childId))
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _entryFromFirestore(doc, familyId, childId))
            .toList());
  }

  Future<Entry> updateEntry(Entry entry) async {
    final docRef = _firestore
        .doc(FirestorePaths.entry(entry.familyId, entry.childId, entry.id));
    await docRef.update(_entryToFirestore(entry));
    return entry;
  }

  Future<void> deleteEntry(
      String familyId, String childId, String entryId) async {
    await _firestore
        .doc(FirestorePaths.entry(familyId, childId, entryId))
        .delete();
  }

  Entry _entryFromFirestore(
      DocumentSnapshot doc, String familyId, String childId) {
    final data = doc.data() as Map<String, dynamic>;

    return Entry(
      id: doc.id,
      familyId: familyId,
      childId: childId,
      type: EntryType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => EntryType.feeding,
      ),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] as String,
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      updatedBy: data['updatedBy'] as String,
      notes: data['notes'] as String?,
      mediaIds: List<String>.from(data['mediaIds'] ?? []),
      feedingType: data['feedingType'] != null
          ? FeedingType.values.firstWhere(
              (t) => t.name == data['feedingType'],
              orElse: () => FeedingType.bottle,
            )
          : null,
      amount: (data['amount'] as num?)?.toDouble(),
      duration: data['duration'] as int?,
      diaperType: data['diaperType'] != null
          ? DiaperType.values.firstWhere(
              (t) => t.name == data['diaperType'],
              orElse: () => DiaperType.wet,
            )
          : null,
      endTime: data['endTime'] != null
          ? (data['endTime'] as Timestamp).toDate()
          : null,
      quality: data['quality'] != null
          ? SleepQuality.values.firstWhere(
              (t) => t.name == data['quality'],
              orElse: () => SleepQuality.good,
            )
          : null,
    );
  }

  Map<String, dynamic> _entryToFirestore(Entry entry) {
    return {
      'type': entry.type.name,
      'timestamp': Timestamp.fromDate(entry.timestamp),
      'createdAt': Timestamp.fromDate(entry.createdAt),
      'createdBy': entry.createdBy,
      'updatedAt': Timestamp.fromDate(entry.updatedAt),
      'updatedBy': entry.updatedBy,
      'notes': entry.notes,
      'mediaIds': entry.mediaIds,
      'feedingType': entry.feedingType?.name,
      'amount': entry.amount,
      'duration': entry.duration,
      'diaperType': entry.diaperType?.name,
      'endTime':
          entry.endTime != null ? Timestamp.fromDate(entry.endTime!) : null,
      'quality': entry.quality?.name,
    };
  }
}
