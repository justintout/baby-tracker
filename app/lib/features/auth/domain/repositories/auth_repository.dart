import '../entities/user.dart';

abstract class AuthRepository {
  /// Stream of current user state (null when signed out)
  Stream<AppUser?> get authStateChanges;

  /// Get the current user (null if not signed in)
  AppUser? get currentUser;

  /// Send a magic link to the given email
  Future<void> sendSignInLink({required String email});

  /// Complete sign in with the magic link
  Future<AppUser> signInWithEmailLink({
    required String email,
    required String emailLink,
  });

  /// Check if a link is a valid sign-in link
  bool isSignInWithEmailLink(String link);

  /// Sign out the current user
  Future<void> signOut();

  /// Update user profile
  Future<void> updateProfile({
    String? displayName,
    String? photoURL,
  });
}
