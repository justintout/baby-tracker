import '../../domain/entities/child.dart';
import '../../domain/repositories/child_repository.dart';
import '../datasources/firestore_child_datasource.dart';

class ChildRepositoryImpl implements ChildRepository {
  ChildRepositoryImpl({required FirestoreChildDataSource dataSource})
      : _dataSource = dataSource;

  final FirestoreChildDataSource _dataSource;

  @override
  Future<Child> createChild({
    required String familyId,
    required String name,
    required DateTime birthDate,
    String? photoURL,
  }) =>
      _dataSource.createChild(
        familyId: familyId,
        name: name,
        birthDate: birthDate,
        photoURL: photoURL,
      );

  @override
  Future<Child?> getChild(String familyId, String childId) =>
      _dataSource.getChild(familyId, childId);

  @override
  Stream<Child?> watchChild(String familyId, String childId) =>
      _dataSource.watchChild(familyId, childId);

  @override
  Stream<List<Child>> watchChildren(String familyId) =>
      _dataSource.watchChildren(familyId);

  @override
  Future<Child> updateChild({
    required String familyId,
    required String childId,
    String? name,
    DateTime? birthDate,
    String? photoURL,
  }) =>
      _dataSource.updateChild(
        familyId: familyId,
        childId: childId,
        name: name,
        birthDate: birthDate,
        photoURL: photoURL,
      );

  @override
  Future<void> deleteChild(String familyId, String childId) =>
      _dataSource.deleteChild(familyId, childId);
}
