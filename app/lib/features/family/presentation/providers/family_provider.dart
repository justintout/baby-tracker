import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/providers/user_provider.dart';
import '../../data/datasources/firestore_child_datasource.dart';
import '../../data/datasources/firestore_family_datasource.dart';
import '../../data/repositories/child_repository_impl.dart';
import '../../data/repositories/family_repository_impl.dart';
import '../../domain/entities/child.dart';
import '../../domain/entities/family.dart' as domain;
import '../../domain/repositories/child_repository.dart';
import '../../domain/repositories/family_repository.dart';

// Datasource providers
final firestoreFamilyDataSourceProvider =
    Provider<FirestoreFamilyDataSource>((ref) => FirestoreFamilyDataSource());

final firestoreChildDataSourceProvider =
    Provider<FirestoreChildDataSource>((ref) => FirestoreChildDataSource());

// Repository providers
final familyRepositoryProvider = Provider<FamilyRepository>((ref) {
  return FamilyRepositoryImpl(
    dataSource: ref.watch(firestoreFamilyDataSourceProvider),
  );
});

final childRepositoryProvider = Provider<ChildRepository>((ref) {
  return ChildRepositoryImpl(
    dataSource: ref.watch(firestoreChildDataSourceProvider),
  );
});

// Stream of user's families
final familiesProvider = StreamProvider<List<domain.Family>>((ref) {
  final user = ref.watch(firestoreUserProvider).valueOrNull;
  if (user == null || user.familyIds.isEmpty) {
    return Stream.value([]);
  }

  final familyRepository = ref.watch(familyRepositoryProvider);
  return familyRepository.watchFamilies(user.familyIds);
});

// Current/active family (first one for now, could be expanded later)
final currentFamilyProvider = Provider<domain.Family?>((ref) {
  final families = ref.watch(familiesProvider).valueOrNull;
  return families?.isNotEmpty == true ? families!.first : null;
});

// Stream of children for current family
final childrenProvider = StreamProvider<List<Child>>((ref) {
  final family = ref.watch(currentFamilyProvider);
  if (family == null) return Stream.value([]);

  final childRepository = ref.watch(childRepositoryProvider);
  return childRepository.watchChildren(family.id);
});

// Selected/current child for tracking
final selectedChildProvider = Provider<Child?>((ref) {
  final user = ref.watch(firestoreUserProvider).valueOrNull;
  final children = ref.watch(childrenProvider).valueOrNull ?? [];

  if (children.isEmpty) return null;

  // Try to find the default child from user settings
  if (user?.settings.defaultChildId != null) {
    final defaultChild = children.cast<Child?>().firstWhere(
          (c) => c?.id == user!.settings.defaultChildId,
          orElse: () => null,
        );
    if (defaultChild != null) return defaultChild;
  }

  // Fall back to first child
  return children.first;
});

// Family controller for mutations
final familyControllerProvider =
    StateNotifierProvider<FamilyController, AsyncValue<void>>((ref) {
  return FamilyController(ref);
});

class FamilyController extends StateNotifier<AsyncValue<void>> {
  FamilyController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  FamilyRepository get _familyRepo => _ref.read(familyRepositoryProvider);
  ChildRepository get _childRepo => _ref.read(childRepositoryProvider);

  /// Create a new family and add first child
  Future<void> createFamilyWithChild({
    required String familyName,
    required String childName,
    required DateTime birthDate,
    String? photoURL,
  }) async {
    state = const AsyncValue.loading();

    try {
      final authUser = _ref.read(currentUserProvider);
      if (authUser == null) throw Exception('Not authenticated');

      // Create family
      final family = await _familyRepo.createFamily(
        name: familyName,
        userId: authUser.id,
        displayName: authUser.displayName ?? authUser.email,
      );

      // Add family to user's familyIds (creates user doc if needed)
      final userRepo = _ref.read(userRepositoryProvider);
      await userRepo.addFamilyToUser(authUser.id, family.id, email: authUser.email);

      // Create first child
      final child = await _childRepo.createChild(
        familyId: family.id,
        name: childName,
        birthDate: birthDate,
        photoURL: photoURL,
      );

      // Set as default child
      await userRepo.updateSettings(
        userId: authUser.id,
        defaultChildId: child.id,
      );

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Add a child to existing family
  Future<void> addChild({
    required String familyId,
    required String name,
    required DateTime birthDate,
    String? photoURL,
  }) async {
    state = const AsyncValue.loading();

    try {
      await _childRepo.createChild(
        familyId: familyId,
        name: name,
        birthDate: birthDate,
        photoURL: photoURL,
      );

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Update child details
  Future<void> updateChild({
    required String familyId,
    required String childId,
    String? name,
    DateTime? birthDate,
    String? photoURL,
  }) async {
    state = const AsyncValue.loading();

    try {
      await _childRepo.updateChild(
        familyId: familyId,
        childId: childId,
        name: name,
        birthDate: birthDate,
        photoURL: photoURL,
      );

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Set selected child
  Future<void> selectChild(String childId) async {
    final authUser = _ref.read(currentUserProvider);
    if (authUser == null) return;

    final userRepo = _ref.read(userRepositoryProvider);
    await userRepo.updateSettings(
      userId: authUser.id,
      defaultChildId: childId,
    );
  }

  /// Delete a child
  Future<void> deleteChild({
    required String familyId,
    required String childId,
  }) async {
    state = const AsyncValue.loading();

    try {
      await _childRepo.deleteChild(familyId, childId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
