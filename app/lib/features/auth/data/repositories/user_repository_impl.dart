import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/firestore_user_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required FirestoreUserDataSource dataSource})
      : _dataSource = dataSource;

  final FirestoreUserDataSource _dataSource;

  @override
  Future<AppUser?> getUser(String userId) => _dataSource.getUser(userId);

  @override
  Stream<AppUser?> watchUser(String userId) => _dataSource.watchUser(userId);

  @override
  Future<void> saveUser(AppUser user) => _dataSource.saveUser(user);

  @override
  Future<void> updateSettings({
    required String userId,
    String? defaultChildId,
    bool? notifications,
    String? theme,
  }) =>
      _dataSource.updateSettings(
        userId: userId,
        defaultChildId: defaultChildId,
        notifications: notifications,
        theme: theme,
      );

  @override
  Future<void> addFamilyToUser(String userId, String familyId, {String? email}) =>
      _dataSource.addFamilyToUser(userId, familyId, email: email);
}
