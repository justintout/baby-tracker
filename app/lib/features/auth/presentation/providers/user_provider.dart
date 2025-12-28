import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/firestore_user_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import 'auth_provider.dart';

// Firestore user data source provider
final firestoreUserDataSourceProvider =
    Provider<FirestoreUserDataSource>((ref) => FirestoreUserDataSource());

// User repository provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    dataSource: ref.watch(firestoreUserDataSourceProvider),
  );
});

// Stream of Firestore user document (includes familyIds, settings, etc.)
final firestoreUserProvider = StreamProvider<AppUser?>((ref) {
  final authUser = ref.watch(authStateProvider).valueOrNull;
  if (authUser == null) return Stream.value(null);

  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.watchUser(authUser.id);
});

// Check if user needs onboarding (has no family)
final needsOnboardingProvider = Provider<bool>((ref) {
  final authUser = ref.watch(authStateProvider).valueOrNull;
  final firestoreUser = ref.watch(firestoreUserProvider).valueOrNull;

  // User is logged in but has no families
  if (authUser != null) {
    // If Firestore user doesn't exist yet, they need onboarding
    if (firestoreUser == null) return true;
    // If they have no families, they need onboarding
    return firestoreUser.familyIds.isEmpty;
  }

  return false;
});

// Loading state for Firestore user
final firestoreUserLoadingProvider = Provider<bool>((ref) {
  return ref.watch(firestoreUserProvider).isLoading;
});
