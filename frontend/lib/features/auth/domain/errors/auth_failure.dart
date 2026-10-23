sealed class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;
}

final class InvalidCredentialsFailure extends AuthFailure {
  const InvalidCredentialsFailure() : super('E-mail ou senha inválidos.');
}

final class EmailAlreadyInUseFailure extends AuthFailure {
  const EmailAlreadyInUseFailure() : super('Este e-mail já está em uso.');
}

final class ServiceUnavailableFailure extends AuthFailure {
  const ServiceUnavailableFailure()
    : super(
        'Servidor Indisponível, tente novamente mais tarde ou contate o suporte.',
      );
}

final class AuthUnknownFailure extends AuthFailure {
  const AuthUnknownFailure()
    : super('Não foi possível concluir a operação de autenticação.');
}
