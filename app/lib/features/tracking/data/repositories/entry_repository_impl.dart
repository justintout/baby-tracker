import '../../domain/entities/entry.dart';
import '../../domain/repositories/entry_repository.dart';
import '../datasources/firestore_entry_datasource.dart';

class EntryRepositoryImpl implements EntryRepository {
  EntryRepositoryImpl({required FirestoreEntryDataSource dataSource})
      : _dataSource = dataSource;

  final FirestoreEntryDataSource _dataSource;

  @override
  Future<Entry> createEntry(Entry entry) => _dataSource.createEntry(entry);

  @override
  Future<Entry?> getEntry(String familyId, String childId, String entryId) =>
      _dataSource.getEntry(familyId, childId, entryId);

  @override
  Stream<List<Entry>> watchEntries(String familyId, String childId) =>
      _dataSource.watchEntries(familyId, childId);

  @override
  Stream<List<Entry>> watchEntriesForDate(
    String familyId,
    String childId,
    DateTime date,
  ) =>
      _dataSource.watchEntriesForDate(familyId, childId, date);

  @override
  Future<Entry> updateEntry(Entry entry) => _dataSource.updateEntry(entry);

  @override
  Future<void> deleteEntry(String familyId, String childId, String entryId) =>
      _dataSource.deleteEntry(familyId, childId, entryId);
}
