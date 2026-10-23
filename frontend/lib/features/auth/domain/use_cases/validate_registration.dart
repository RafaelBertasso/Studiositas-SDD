class RegistrationData {
  const RegistrationData({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.phone,
  });

  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? phone;
}

class RegistrationValidationResult {
  const RegistrationValidationResult(this.errors);

  final Map<String, String> errors;

  bool get isValid => errors.isEmpty;
}

class ValidateRegistration {
  const ValidateRegistration();

  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final _uppercasePattern = RegExp(r'[A-Z]');
  static final _lowercasePattern = RegExp(r'[a-z]');
  static final _numberPattern = RegExp(r'\d');
  static final _specialCharacterPattern = RegExp(r'[^A-Za-z0-9]');

  RegistrationValidationResult call(RegistrationData data) {
    final errors = <String, String>{};

    if (data.name.trim().isEmpty) {
      errors['name'] = 'Informe seu nome.';
    }

    if (data.email.trim().isEmpty) {
      errors['email'] = 'Informe seu e-mail.';
    } else if (!_emailPattern.hasMatch(data.email.trim())) {
      errors['email'] = 'Informe um e-mail válido.';
    }

    if (data.password.isEmpty) {
      errors['password'] = 'Informe uma senha.';
    } else if (!_hasRequiredPasswordComplexity(data.password)) {
      errors['password'] =
          'A senha deve ter pelo menos 8 caracteres, letra maiúscula, '
          'letra minúscula, número e caractere especial.';
    }

    if (data.passwordConfirmation.isEmpty) {
      errors['passwordConfirmation'] = 'Confirme sua senha.';
    } else if (data.password != data.passwordConfirmation) {
      errors['passwordConfirmation'] = 'As senhas não coincidem.';
    }

    return RegistrationValidationResult(errors);
  }

  bool _hasRequiredPasswordComplexity(String password) {
    return password.length >= 8 &&
        _uppercasePattern.hasMatch(password) &&
        _lowercasePattern.hasMatch(password) &&
        _numberPattern.hasMatch(password) &&
        _specialCharacterPattern.hasMatch(password);
  }
}
