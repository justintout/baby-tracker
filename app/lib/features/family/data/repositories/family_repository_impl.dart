import '../../domain/entities/family.dart';
import '../../domain/repositories/family_repository.dart';
import '../datasources/firestore_family_datasource.dart';

class FamilyRepositoryImpl implements FamilyRepository {
  FamilyRepositoryImpl({required FirestoreFamilyDataSource dataSource})
      : _dataSource = dataSource;

  final FirestoreFamilyDataSource _dataSource;

  @override
  Future<Family> createFamily({
    required String name,
    required String userId,
    required String displayName,
  }) =>
      _dataSource.createFamily(
        name: name,
        userId: userId,
        displayName: displayName,
      );

  @override
  Future<Family?> getFamily(String familyId) => _dataSource.getFamily(familyId);

  @override
  Stream<Family?> watchFamily(String familyId) =>
      _dataSource.watchFamily(familyId);

  @override
  Stream<List<Family>> watchFamilies(List<String> familyIds) =>
      _dataSource.watchFamilies(familyIds);
}
