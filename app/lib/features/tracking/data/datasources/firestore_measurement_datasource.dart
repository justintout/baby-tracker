import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/measurement.dart';

class FirestoreMeasurementDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _measurementsRef(
      String familyId, String childId) {
    return _firestore
        .collection('families')
        .doc(familyId)
        .collection('children')
        .doc(childId)
        .collection('measurements');
  }

  Stream<List<Measurement>> watchMeasurements(
      String familyId, String childId) {
    return _measurementsRef(familyId, childId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return _measurementFromFirestore(doc.id, familyId, childId, data);
            }).toList());
  }

  Future<Measurement?> getMeasurement(
      String familyId, String childId, String measurementId) async {
    final doc =
        await _measurementsRef(familyId, childId).doc(measurementId).get();
    if (!doc.exists) return null;
    return _measurementFromFirestore(doc.id, familyId, childId, doc.data()!);
  }

  Future<Measurement?> getLatestMeasurement(
      String familyId, String childId) async {
    final snapshot = await _measurementsRef(familyId, childId)
        .orderBy('date', descending: true)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return _measurementFromFirestore(doc.id, familyId, childId, doc.data());
  }

  Future<Measurement> createMeasurement(Measurement measurement) async {
    final data = _measurementToFirestore(measurement);
    final docRef = await _measurementsRef(measurement.familyId, measurement.childId)
        .add(data);
    return measurement.copyWith(id: docRef.id);
  }

  Future<void> updateMeasurement(Measurement measurement) async {
    final data = _measurementToFirestore(measurement);
    await _measurementsRef(measurement.familyId, measurement.childId)
        .doc(measurement.id)
        .update(data);
  }

  Future<void> deleteMeasurement(
      String familyId, String childId, String measurementId) async {
    await _measurementsRef(familyId, childId).doc(measurementId).delete();
  }

  Measurement _measurementFromFirestore(
    String id,
    String familyId,
    String childId,
    Map<String, dynamic> data,
  ) {
    return Measurement(
      id: id,
      familyId: familyId,
      childId: childId,
      date: (data['date'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      createdBy: data['createdBy'] as String,
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      updatedBy: data['updatedBy'] as String,
      notes: data['notes'] as String?,
      weightOz: (data['weightOz'] as num?)?.toDouble(),
      heightInches: (data['heightInches'] as num?)?.toDouble(),
      headCircumferenceInches:
          (data['headCircumferenceInches'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> _measurementToFirestore(Measurement measurement) {
    return {
      'date': Timestamp.fromDate(measurement.date),
      'createdAt': Timestamp.fromDate(measurement.createdAt),
      'createdBy': measurement.createdBy,
      'updatedAt': Timestamp.fromDate(measurement.updatedAt),
      'updatedBy': measurement.updatedBy,
      if (measurement.notes != null) 'notes': measurement.notes,
      if (measurement.weightOz != null) 'weightOz': measurement.weightOz,
      if (measurement.heightInches != null)
        'heightInches': measurement.heightInches,
      if (measurement.headCircumferenceInches != null)
        'headCircumferenceInches': measurement.headCircumferenceInches,
    };
  }
}
