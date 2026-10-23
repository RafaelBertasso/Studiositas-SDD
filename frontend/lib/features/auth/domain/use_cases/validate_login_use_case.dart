class LoginData {
  const LoginData({required this.email, required this.password});

  final String email;
  final String password;
}

class ValidateLoginUseCase {
  const ValidateLoginUseCase();

  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  Map<String, String> call(LoginData data) {
    final errors = <String, String>{};
    if (data.email.trim().isEmpty) {
      errors['email'] = 'Informe seu e-mail.';
    } else if (!_emailPattern.hasMatch(data.email.trim())) {
      errors['email'] = 'Informe um e-mail válido.';
    }
    if (data.password.isEmpty) {
      errors['password'] = 'Informe sua senha.';
    }
    return errors;
  }
}
