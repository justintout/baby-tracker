import '../entities/user.dart';

abstract class UserRepository {
  Future<AppUser?> getUser(String userId);

  Stream<AppUser?> watchUser(String userId);

  Future<void> saveUser(AppUser user);

  Future<void> updateSettings({
    required String userId,
    String? defaultChildId,
    bool? notifications,
    String? theme,
  });

  Future<void> addFamilyToUser(String userId, String familyId, {String? email});
}
