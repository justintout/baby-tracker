import '../entities/child.dart';

abstract class ChildRepository {
  Future<Child> createChild({
    required String familyId,
    required String name,
    required DateTime birthDate,
    String? photoURL,
  });

  Future<Child?> getChild(String familyId, String childId);

  Stream<Child?> watchChild(String familyId, String childId);

  Stream<List<Child>> watchChildren(String familyId);

  Future<Child> updateChild({
    required String familyId,
    required String childId,
    String? name,
    DateTime? birthDate,
    String? photoURL,
  });

  Future<void> deleteChild(String familyId, String childId);
}
