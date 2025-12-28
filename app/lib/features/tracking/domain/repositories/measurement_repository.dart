import '../entities/measurement.dart';

abstract class MeasurementRepository {
  /// Stream of measurements for a child
  Stream<List<Measurement>> watchMeasurements(String familyId, String childId);

  /// Get a single measurement
  Future<Measurement?> getMeasurement(
      String familyId, String childId, String measurementId);

  /// Get the most recent measurement
  Future<Measurement?> getLatestMeasurement(String familyId, String childId);

  /// Create a new measurement
  Future<Measurement> createMeasurement(Measurement measurement);

  /// Update an existing measurement
  Future<void> updateMeasurement(Measurement measurement);

  /// Delete a measurement
  Future<void> deleteMeasurement(
      String familyId, String childId, String measurementId);
}
