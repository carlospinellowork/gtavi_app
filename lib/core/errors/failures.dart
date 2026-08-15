abstract class Failure {
  final String message;
  final int? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Erro no servidor. Tente novamente mais tarde.', int? code])
      : super(message, code: code);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Sem conexão com a internet.', int? code])
      : super(message, code: code);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Falha ao acessar armazenamento local.', int? code])
      : super(message, code: code);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Recurso não encontrado.', int? code])
      : super(message, code: code);
}
