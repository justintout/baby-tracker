import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/firebase_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

// Keys for shared preferences
const _kPendingEmail = 'pending_email';

// Firebase Auth data source provider
final firebaseAuthDataSourceProvider = Provider<FirebaseAuthDataSource>((ref) {
  return FirebaseAuthDataSource();
});

// Auth repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authDataSource: ref.watch(firebaseAuthDataSourceProvider),
    // For development, use Firebase's default domain
    // In production, configure your own dynamic link domain
    dynamicLinkDomain: 'baby-tracker-88ca3.firebaseapp.com',
    iOSBundleId: 'com.babytracker.babyTracker',
    androidPackageName: 'com.babytracker.baby_tracker',
  );
});

// Auth state stream provider
final authStateProvider = StreamProvider<AppUser?>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Current user provider (for synchronous access)
final currentUserProvider = Provider<AppUser?>((ref) {
  return ref.watch(authStateProvider).valueOrNull;
});

// Is authenticated provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

// Auth controller for handling sign in flow
final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});

// Auth state
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthEmailSent extends AuthState {
  const AuthEmailSent(this.email);
  final String email;
}

class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);
  final AppUser user;
}

class AuthError extends AuthState {
  const AuthError(this.message);
  final String message;
}

// Auth controller
class AuthController extends StateNotifier<AuthState> {
  AuthController(this._ref) : super(const AuthInitial());

  final Ref _ref;

  AuthRepository get _authRepository => _ref.read(authRepositoryProvider);

  /// Send magic link to email
  Future<void> sendSignInLink(String email) async {
    state = const AuthLoading();

    try {
      await _authRepository.sendSignInLink(email: email);

      // Store email for later verification
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kPendingEmail, email);

      state = AuthEmailSent(email);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Complete sign in with magic link
  Future<void> signInWithEmailLink(String emailLink) async {
    state = const AuthLoading();

    try {
      // Get stored email
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(_kPendingEmail);

      if (email == null) {
        state = const AuthError('No pending email found. Please request a new link.');
        return;
      }

      final user = await _authRepository.signInWithEmailLink(
        email: email,
        emailLink: emailLink,
      );

      // Clear stored email
      await prefs.remove(_kPendingEmail);

      state = AuthSuccess(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  /// Check if a link is a valid sign-in link
  bool isSignInWithEmailLink(String link) {
    return _authRepository.isSignInWithEmailLink(link);
  }

  /// Sign out
  Future<void> signOut() async {
    await _authRepository.signOut();
    state = const AuthInitial();
  }

  /// Reset state
  void reset() {
    state = const AuthInitial();
  }
}
