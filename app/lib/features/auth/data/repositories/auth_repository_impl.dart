import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required FirebaseAuthDataSource authDataSource,
    required String dynamicLinkDomain,
    required String iOSBundleId,
    required String androidPackageName,
  })  : _authDataSource = authDataSource,
        _dynamicLinkDomain = dynamicLinkDomain,
        _iOSBundleId = iOSBundleId,
        _androidPackageName = androidPackageName;

  final FirebaseAuthDataSource _authDataSource;
  final String _dynamicLinkDomain;
  final String _iOSBundleId;
  final String _androidPackageName;

  @override
  Stream<AppUser?> get authStateChanges {
    return _authDataSource.authStateChanges.map(_mapFirebaseUser);
  }

  @override
  AppUser? get currentUser {
    return _mapFirebaseUser(_authDataSource.currentUser);
  }

  @override
  Future<void> sendSignInLink({required String email}) async {
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://$_dynamicLinkDomain/auth',
      handleCodeInApp: true,
      iOSBundleId: _iOSBundleId,
      androidPackageName: _androidPackageName,
      androidInstallApp: true,
      androidMinimumVersion: '21',
    );

    await _authDataSource.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: actionCodeSettings,
    );
  }

  @override
  Future<AppUser> signInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    final credential = await _authDataSource.signInWithEmailLink(
      email: email,
      emailLink: emailLink,
    );

    final user = _mapFirebaseUser(credential.user);
    if (user == null) {
      throw Exception('Sign in failed: no user returned');
    }

    return user;
  }

  @override
  bool isSignInWithEmailLink(String link) {
    return _authDataSource.isSignInWithEmailLink(link);
  }

  @override
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  @override
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    await _authDataSource.updateProfile(
      displayName: displayName,
      photoURL: photoURL,
    );
  }

  AppUser? _mapFirebaseUser(User? firebaseUser) {
    if (firebaseUser == null) return null;

    return AppUser(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime,
      updatedAt: firebaseUser.metadata.lastSignInTime,
    );
  }
}
