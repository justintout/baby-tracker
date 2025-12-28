import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../family/presentation/providers/family_provider.dart';
import '../../data/datasources/firestore_entry_datasource.dart';
import '../../data/repositories/entry_repository_impl.dart';
import '../../domain/entities/entry.dart';
import '../../domain/repositories/entry_repository.dart';

// Datasource provider
final firestoreEntryDataSourceProvider =
    Provider<FirestoreEntryDataSource>((ref) => FirestoreEntryDataSource());

// Repository provider
final entryRepositoryProvider = Provider<EntryRepository>((ref) {
  return EntryRepositoryImpl(
    dataSource: ref.watch(firestoreEntryDataSourceProvider),
  );
});

// Stream of today's entries for selected child
final todayEntriesProvider = StreamProvider<List<Entry>>((ref) {
  final family = ref.watch(currentFamilyProvider);
  final child = ref.watch(selectedChildProvider);

  if (family == null || child == null) {
    return Stream.value([]);
  }

  final entryRepository = ref.watch(entryRepositoryProvider);
  return entryRepository.watchEntriesForDate(
    family.id,
    child.id,
    DateTime.now(),
  );
});

// Stream of all entries for selected child
final allEntriesProvider = StreamProvider<List<Entry>>((ref) {
  final family = ref.watch(currentFamilyProvider);
  final child = ref.watch(selectedChildProvider);

  if (family == null || child == null) {
    return Stream.value([]);
  }

  final entryRepository = ref.watch(entryRepositoryProvider);
  return entryRepository.watchEntries(family.id, child.id);
});

// Filter entries by type
final feedingEntriesProvider = Provider<List<Entry>>((ref) {
  final entries = ref.watch(todayEntriesProvider).valueOrNull ?? [];
  return entries.where((e) => e.type == EntryType.feeding).toList();
});

final diaperEntriesProvider = Provider<List<Entry>>((ref) {
  final entries = ref.watch(todayEntriesProvider).valueOrNull ?? [];
  return entries.where((e) => e.type == EntryType.diaper).toList();
});

final sleepEntriesProvider = Provider<List<Entry>>((ref) {
  final entries = ref.watch(todayEntriesProvider).valueOrNull ?? [];
  return entries.where((e) => e.type == EntryType.sleep).toList();
});

// Entry controller for mutations
final entryControllerProvider =
    StateNotifierProvider<EntryController, AsyncValue<void>>((ref) {
  return EntryController(ref);
});

class EntryController extends StateNotifier<AsyncValue<void>> {
  EntryController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  EntryRepository get _entryRepo => _ref.read(entryRepositoryProvider);

  /// Log a feeding
  Future<Entry?> logFeeding({
    required FeedingType feedingType,
    double? amount,
    int? duration,
    String? notes,
    DateTime? timestamp,
  }) async {
    return _createEntry(
      type: EntryType.feeding,
      feedingType: feedingType,
      amount: amount,
      duration: duration,
      notes: notes,
      timestamp: timestamp,
    );
  }

  /// Log a diaper change
  Future<Entry?> logDiaper({
    required DiaperType diaperType,
    String? notes,
    DateTime? timestamp,
  }) async {
    return _createEntry(
      type: EntryType.diaper,
      diaperType: diaperType,
      notes: notes,
      timestamp: timestamp,
    );
  }

  /// Log sleep
  Future<Entry?> logSleep({
    required DateTime startTime,
    DateTime? endTime,
    SleepQuality? quality,
    String? notes,
  }) async {
    return _createEntry(
      type: EntryType.sleep,
      timestamp: startTime,
      endTime: endTime,
      quality: quality,
      notes: notes,
    );
  }

  Future<Entry?> _createEntry({
    required EntryType type,
    FeedingType? feedingType,
    DiaperType? diaperType,
    SleepQuality? quality,
    double? amount,
    int? duration,
    DateTime? endTime,
    String? notes,
    DateTime? timestamp,
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
      final entry = Entry(
        id: '', // Will be set by Firestore
        familyId: family.id,
        childId: child.id,
        type: type,
        timestamp: timestamp ?? now,
        createdAt: now,
        createdBy: authUser.id,
        updatedAt: now,
        updatedBy: authUser.id,
        notes: notes,
        feedingType: feedingType,
        amount: amount,
        duration: duration,
        diaperType: diaperType,
        endTime: endTime,
        quality: quality,
      );

      final created = await _entryRepo.createEntry(entry);
      state = const AsyncValue.data(null);
      return created;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return null;
    }
  }

  /// Update an existing entry
  Future<void> updateEntry(Entry entry) async {
    state = const AsyncValue.loading();

    try {
      final authUser = _ref.read(currentUserProvider);
      if (authUser == null) throw Exception('Not authenticated');

      final updated = entry.copyWith(
        updatedAt: DateTime.now(),
        updatedBy: authUser.id,
      );

      await _entryRepo.updateEntry(updated);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Delete an entry
  Future<void> deleteEntry(Entry entry) async {
    state = const AsyncValue.loading();

    try {
      await _entryRepo.deleteEntry(entry.familyId, entry.childId, entry.id);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
