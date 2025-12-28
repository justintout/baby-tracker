import '../../domain/entities/measurement.dart';
import '../../domain/repositories/measurement_repository.dart';
import '../datasources/firestore_measurement_datasource.dart';

class MeasurementRepositoryImpl implements MeasurementRepository {
  MeasurementRepositoryImpl({required this.dataSource});

  final FirestoreMeasurementDataSource dataSource;

  @override
  Stream<List<Measurement>> watchMeasurements(
      String familyId, String childId) {
    return dataSource.watchMeasurements(familyId, childId);
  }

  @override
  Future<Measurement?> getMeasurement(
      String familyId, String childId, String measurementId) {
    return dataSource.getMeasurement(familyId, childId, measurementId);
  }

  @override
  Future<Measurement?> getLatestMeasurement(String familyId, String childId) {
    return dataSource.getLatestMeasurement(familyId, childId);
  }

  @override
  Future<Measurement> createMeasurement(Measurement measurement) {
    return dataSource.createMeasurement(measurement);
  }

  @override
  Future<void> updateMeasurement(Measurement measurement) {
    return dataSource.updateMeasurement(measurement);
  }

  @override
  Future<void> deleteMeasurement(
      String familyId, String childId, String measurementId) {
    return dataSource.deleteMeasurement(familyId, childId, measurementId);
  }
}
