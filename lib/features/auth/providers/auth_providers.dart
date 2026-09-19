import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:rainbow_app/core/enums/user_role.dart';
import 'package:rainbow_app/core/providers/core_providers.dart';
import 'package:rainbow_app/features/auth/data/auth_repository.dart';
import 'package:rainbow_app/features/auth/models/auth_user.dart';

/// Whether anyone is signed in, and who.
sealed class AuthState {
  const AuthState();

  /// The signed-in account, or `null`.
  AuthUser? get user => switch (this) {
    AuthSignedIn(:final AuthUser user) => user,
    AuthSignedOut() => null,
  };

  bool get isSignedIn => this is AuthSignedIn;
}

final class AuthSignedOut extends AuthState {
  const AuthSignedOut({this.becauseSessionExpired = false});

  /// True when the user was signed out by a rejected token rather than by
  /// tapping sign out — the login screen then explains why.
  final bool becauseSessionExpired;
}

final class AuthSignedIn extends AuthState {
  const AuthSignedIn(this.user);

  @override
  final AuthUser user;
}

final Provider<AuthRepository> authRepositoryProvider =
    Provider<AuthRepository>(
      (Ref ref) => AuthRepository(
        ref.watch(apiClientProvider),
        ref.watch(secureStorageServiceProvider),
      ),
      name: 'authRepository',
    );

/// Owns the session for the lifetime of the app.
///
/// `build` restores a persisted session, so the first read of this provider
/// is what decides whether the user lands on sign-in or on the dashboard.
class AuthController extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final AuthRepository repository = ref.watch(authRepositoryProvider);

    // A 401 from any endpoint ends the session exactly once, wherever the
    // user happens to be.
    final SessionExpiryNotifier expiry = ref.watch(sessionExpiryProvider);
    void onExpired() {
      if (state.value is AuthSignedIn) {
        state = const AsyncValue<AuthState>.data(
          AuthSignedOut(becauseSessionExpired: true),
        );
        // Fire-and-forget: the token is already invalid server-side.
        unawaited(repository.clearSession());
      }
    }

    expiry.addListener(onExpired);
    ref.onDispose(() => expiry.removeListener(onExpired));

    final AuthUser? user = await repository.restoreSession();
    return user == null ? const AuthSignedOut() : AuthSignedIn(user);
  }

  /// Signs in and moves to [AuthSignedIn] on success.
  ///
  /// Rethrows the `ApiFailure` so the form can show it inline; the state is
  /// left untouched on failure so the user stays on the login screen.
  Future<void> signIn({required String email, required String password}) async {
    final AuthUser user = await ref
        .read(authRepositoryProvider)
        .signIn(email: email, password: password);
    state = AsyncValue<AuthState>.data(AuthSignedIn(user));
  }

  Future<void> signOut() async {
    state = const AsyncValue<AuthState>.data(AuthSignedOut());
    await ref.read(authRepositoryProvider).signOut();
  }
}

final AsyncNotifierProvider<AuthController, AuthState> authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthState>(
      AuthController.new,
      name: 'authController',
    );

/// The signed-in account, or `null` while loading or signed out.
final Provider<AuthUser?> currentUserProvider = Provider<AuthUser?>(
  (Ref ref) => ref.watch(authControllerProvider).value?.user,
  name: 'currentUser',
);

/// The operational role, defaulting to the least-privileged value so a
/// widget can never accidentally show gate actions to a sales account.
final Provider<UserRole> currentRoleProvider = Provider<UserRole>(
  (Ref ref) => ref.watch(currentUserProvider)?.role ?? UserRole.member,
  name: 'currentRole',
);
