import '../entities/family.dart';

abstract class FamilyRepository {
  Future<Family> createFamily({
    required String name,
    required String userId,
    required String displayName,
  });

  Future<Family?> getFamily(String familyId);

  Stream<Family?> watchFamily(String familyId);

  Stream<List<Family>> watchFamilies(List<String> familyIds);
}
