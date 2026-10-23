import 'package:flutter_test/flutter_test.dart';
import 'package:studiositas/features/auth/domain/use_cases/validate_registration.dart';

void main() {
  const validator = ValidateRegistration();

  RegistrationData validData({
    String? name,
    String? email,
    String? password,
    String? passwordConfirmation,
  }) {
    return RegistrationData(
      name: name ?? 'Rafael',
      email: email ?? 'rafael@example.com',
      password: password ?? 'SenhaSegura1!',
      passwordConfirmation: passwordConfirmation ?? 'SenhaSegura1!',
    );
  }

  test('accepts valid registration data', () {
    final result = validator(validData());

    expect(result.isValid, isTrue);
    expect(result.errors, isEmpty);
  });

  test('requires a name', () {
    final result = validator(validData(name: ''));

    expect(result.errors['name'], 'Informe seu nome.');
  });

  test('requires a valid email', () {
    final result = validator(validData(email: 'invalid-email'));

    expect(result.errors['email'], 'Informe um e-mail válido.');
  });

  test('requires a password', () {
    final result = validator(validData(password: ''));

    expect(result.errors['password'], 'Informe uma senha.');
  });

  test('requires password complexity', () {
    final result = validator(validData(password: 'senha123'));

    expect(result.errors['password'], contains('pelo menos 8 caracteres'));
  });

  test('requires matching password confirmation', () {
    final result = validator(
      validData(passwordConfirmation: 'SenhaDiferente1!'),
    );

    expect(result.errors['passwordConfirmation'], 'As senhas não coincidem.');
  });

  test('allows an empty phone because it is optional', () {
    final result = validator(validData());

    expect(result.isValid, isTrue);
  });
}
