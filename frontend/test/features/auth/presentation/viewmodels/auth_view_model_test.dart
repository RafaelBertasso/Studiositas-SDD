import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:studiositas/features/auth/domain/entities/auth_session.dart';
import 'package:studiositas/features/auth/domain/entities/user_profile.dart';
import 'package:studiositas/features/auth/domain/errors/auth_failure.dart';
import 'package:studiositas/features/auth/domain/repositories/auth_repository.dart';
import 'package:studiositas/features/auth/domain/use_cases/register_use_case.dart';
import 'package:studiositas/features/auth/domain/use_cases/restore_session_use_case.dart';
import 'package:studiositas/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:studiositas/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:studiositas/features/auth/presentation/viewmodels/auth_state.dart';
import 'package:studiositas/features/auth/presentation/viewmodels/auth_view_model.dart';

void main() {
  late FakeAuthRepository repository;
  late AuthViewModel viewModel;

  setUp(() async {
    repository = FakeAuthRepository();
    viewModel = AuthViewModel(
      register: RegisterUseCase(repository),
      signIn: SignInUseCase(repository),
      restoreSession: RestoreSessionUseCase(repository),
      signOut: SignOutUseCase(repository),
    );
    await viewModel.restoreSession();
  });

  tearDown(() => viewModel.dispose());

  test('restores an authenticated session', () async {
    repository.session = sampleSession;

    await viewModel.restoreSession();

    expect(viewModel.state.status, AuthStatus.authenticated);
    expect(viewModel.session, sampleSession);
  });

  test('keeps an unauthenticated state when there is no session', () async {
    await viewModel.restoreSession();

    expect(viewModel.state.status, AuthStatus.unauthenticated);
  });

  test('does not call the repository when registration is invalid', () async {
    final result = await viewModel.register(
      name: '',
      email: 'invalid',
      password: 'weak',
      passwordConfirmation: 'different',
    );

    expect(result, isFalse);
    expect(repository.registerCalls, 0);
    expect(viewModel.state.fieldErrors.keys, containsAll(['name', 'email']));
  });

  test('registers and authenticates with valid data', () async {
    repository.session = sampleSession;

    final result = await viewModel.register(
      name: 'Rafael',
      email: 'rafael@example.com',
      password: 'SenhaSegura1!',
      passwordConfirmation: 'SenhaSegura1!',
    );

    expect(result, isTrue);
    expect(repository.registerCalls, 1);
    expect(viewModel.state.status, AuthStatus.authenticated);
  });

  test('maps authentication failures to the view state', () async {
    repository.signInFailure = const InvalidCredentialsFailure();

    final result = await viewModel.signIn(
      email: 'rafael@example.com',
      password: 'SenhaSegura1!',
    );

    expect(result, isFalse);
    expect(viewModel.state.status, AuthStatus.error);
    expect(viewModel.state.errorMessage, 'E-mail ou senha inválidos.');
  });

  test('logs out and becomes unauthenticated', () async {
    repository.session = sampleSession;
    await viewModel.restoreSession();

    final result = await viewModel.signOut();

    expect(result, isTrue);
    expect(repository.signOutCalls, 1);
    expect(viewModel.state.status, AuthStatus.unauthenticated);
  });

  test('ignores a second submission while the first is pending', () async {
    repository.session = sampleSession;
    repository.registerCompleter = Completer<AuthSession>();

    final first = viewModel.register(
      name: 'Rafael',
      email: 'rafael@example.com',
      password: 'SenhaSegura1!',
      passwordConfirmation: 'SenhaSegura1!',
    );
    final second = await viewModel.register(
      name: 'Rafael',
      email: 'rafael@example.com',
      password: 'SenhaSegura1!',
      passwordConfirmation: 'SenhaSegura1!',
    );

    expect(second, isFalse);
    expect(repository.registerCalls, 1);
    repository.registerCompleter!.complete(sampleSession);
    expect(await first, isTrue);
  });
}

final sampleSession = AuthSession(
  user: UserProfile(
    id: 'user-1',
    name: 'Rafael',
    email: 'rafael@example.com',
    createdAt: DateTime(2026),
  ),
);

class FakeAuthRepository implements AuthRepository {
  AuthSession? session;
  AuthFailure? signInFailure;
  Completer<AuthSession>? registerCompleter;
  int registerCalls = 0;
  int signOutCalls = 0;

  @override
  Future<AuthSession> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    registerCalls++;
    if (registerCompleter != null) return registerCompleter!.future;
    return session!;
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    if (signInFailure != null) throw signInFailure!;
    return session!;
  }

  @override
  Future<AuthSession?> restoreSession() async => session;

  @override
  Future<void> signOut() async {
    signOutCalls++;
    session = null;
  }
}
