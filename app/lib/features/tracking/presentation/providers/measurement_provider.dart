import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../family/presentation/providers/family_provider.dart';
import '../../data/datasources/firestore_measurement_datasource.dart';
import '../../data/repositories/measurement_repository_impl.dart';
import '../../domain/entities/measurement.dart';
import '../../domain/repositories/measurement_repository.dart';

// Datasource provider
final firestoreMeasurementDataSourceProvider =
    Provider<FirestoreMeasurementDataSource>(
        (ref) => FirestoreMeasurementDataSource());

// Repository provider
final measurementRepositoryProvider = Provider<MeasurementRepository>((ref) {
  return MeasurementRepositoryImpl(
    dataSource: ref.watch(firestoreMeasurementDataSourceProvider),
  );
});

// Stream of all measurements for selected child
final measurementsProvider = StreamProvider<List<Measurement>>((ref) {
  final family = ref.watch(currentFamilyProvider);
  final child = ref.watch(selectedChildProvider);

  if (family == null || child == null) {
    return Stream.value([]);
  }

  final measurementRepo = ref.watch(measurementRepositoryProvider);
  return measurementRepo.watchMeasurements(family.id, child.id);
});

// Latest measurement for selected child
final latestMeasurementProvider = FutureProvider<Measurement?>((ref) async {
  final family = ref.watch(currentFamilyProvider);
  final child = ref.watch(selectedChildProvider);

  if (family == null || child == null) {
    return null;
  }

  final measurementRepo = ref.watch(measurementRepositoryProvider);
  return measurementRepo.getLatestMeasurement(family.id, child.id);
});

// Measurement controller for mutations
final measurementControllerProvider =
    StateNotifierProvider<MeasurementController, AsyncValue<void>>((ref) {
  return MeasurementController(ref);
});

class MeasurementController extends StateNotifier<AsyncValue<void>> {
  MeasurementController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  MeasurementRepository get _measurementRepo =>
      _ref.read(measurementRepositoryProvider);

  /// Log a new measurement
  Future<Measurement?> logMeasurement({
    required DateTime date,
    double? weightOz,
    double? heightInches,
    double? headCircumferenceInches,
    String? notes,
  }) async {
    state = const AsyncValue.loading();

    try {
      final authUser = _ref.read(currentUserProvider);
      final family = _ref.read(currentFamilyProvider);
      final child = _ref.read(selectedChildProvider);

      if (authUser == null || family == null || child == null) {
        throw Exception('Missing required data');
      }

      final now = DateTime.now();
      final measurement = Measurement(
        id: '', // Will be set by Firestore
        familyId: family.id,
        childId: child.id,
        date: date,
        createdAt: now,
        createdBy: authUser.id,
        updatedAt: now,
        updatedBy: authUser.id,
        notes: notes,
        weightOz: weightOz,
        heightInches: heightInches,
        headCircumferenceInches: headCircumferenceInches,
      );

      final created = await _measurementRepo.createMeasurement(measurement);
      state = const AsyncValue.data(null);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Update an existing measurement
  Future<void> updateMeasurement(Measurement measurement) async {
    state = const AsyncValue.loading();

    try {
      final authUser = _ref.read(currentUserProvider);
      if (authUser == null) throw Exception('Not authenticated');

      final updated = measurement.copyWith(
        updatedAt: DateTime.now(),
        updatedBy: authUser.id,
      );

      await _measurementRepo.updateMeasurement(updated);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Delete a measurement
  Future<void> deleteMeasurement(Measurement measurement) async {
    state = const AsyncValue.loading();

    try {
      await _measurementRepo.deleteMeasurement(
          measurement.familyId, measurement.childId, measurement.id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
