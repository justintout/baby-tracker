import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/auth/presentation/providers/user_provider.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/family/presentation/screens/baby_form_screen.dart';
import '../features/family/presentation/screens/baby_list_screen.dart';
import '../features/family/presentation/screens/onboarding_screen.dart';
import '../features/tracking/presentation/screens/dashboard_screen.dart';
import '../features/tracking/presentation/screens/diaper_form_screen.dart';
import '../features/tracking/presentation/screens/feeding_form_screen.dart';
import '../features/tracking/presentation/screens/measurement_form_screen.dart';
import '../features/tracking/presentation/screens/sleep_form_screen.dart';
import '../features/tracking/presentation/screens/stats_screen.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final firestoreUser = ref.watch(firestoreUserProvider);
  final firestoreUserLoading = ref.watch(firestoreUserLoadingProvider);

  return GoRouter(
    initialLocation: RouteNames.dashboard,
    refreshListenable: RouterRefreshNotifier(ref),
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isLoggingIn = state.matchedLocation == RouteNames.login;
      final isOnboarding = state.matchedLocation == RouteNames.onboarding;

      // If not logged in and not on login page, redirect to login
      if (!isLoggedIn && !isLoggingIn) {
        return RouteNames.login;
      }

      // If logged in, check if user needs onboarding
      if (isLoggedIn && !isLoggingIn) {
        // Wait for Firestore user data to load
        if (firestoreUserLoading) {
          return null; // Stay on current page while loading
        }

        final user = firestoreUser.valueOrNull;
        final needsOnboarding = user == null || user.familyIds.isEmpty;

        // Redirect to onboarding if needed
        if (needsOnboarding && !isOnboarding) {
          return RouteNames.onboarding;
        }

        // If onboarding complete, redirect away from onboarding
        if (!needsOnboarding && isOnboarding) {
          return RouteNames.dashboard;
        }
      }

      // If logged in and on login page, redirect to dashboard
      if (isLoggedIn && isLoggingIn) {
        return RouteNames.dashboard;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: RouteNames.babyList,
        name: 'babyList',
        builder: (context, state) => const BabyListScreen(),
      ),
      GoRoute(
        path: RouteNames.addBaby,
        name: 'addBaby',
        builder: (context, state) => const BabyFormScreen(),
      ),
      GoRoute(
        path: RouteNames.editBaby,
        name: 'editBaby',
        builder: (context, state) {
          final childId = state.pathParameters['id'];
          return BabyFormScreen(childId: childId);
        },
      ),
      GoRoute(
        path: RouteNames.feedingForm,
        name: 'feedingForm',
        builder: (context, state) => const FeedingFormScreen(),
      ),
      GoRoute(
        path: RouteNames.diaperForm,
        name: 'diaperForm',
        builder: (context, state) => const DiaperFormScreen(),
      ),
      GoRoute(
        path: RouteNames.sleepForm,
        name: 'sleepForm',
        builder: (context, state) => const SleepFormScreen(),
      ),
      GoRoute(
        path: RouteNames.measurementForm,
        name: 'measurementForm',
        builder: (context, state) => const MeasurementFormScreen(),
      ),
      GoRoute(
        path: RouteNames.stats,
        name: 'stats',
        builder: (context, state) => const StatsScreen(),
      ),
      // TODO: Add media routes
      // TODO: Add settings routes
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri}'),
      ),
    ),
  );
});

/// Notifies GoRouter to refresh when auth state or user data changes
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this._ref) {
    _ref.listen(authStateProvider, (_, __) {
      notifyListeners();
    });
    _ref.listen(firestoreUserProvider, (_, __) {
      notifyListeners();
    });
  }

  final Ref _ref;
}
