import '../entities/entry.dart';

abstract class EntryRepository {
  Future<Entry> createEntry(Entry entry);

  Future<Entry?> getEntry(String familyId, String childId, String entryId);

  Stream<List<Entry>> watchEntries(String familyId, String childId);

  Stream<List<Entry>> watchEntriesForDate(
    String familyId,
    String childId,
    DateTime date,
  );

  Future<Entry> updateEntry(Entry entry);

  Future<void> deleteEntry(String familyId, String childId, String entryId);
}
