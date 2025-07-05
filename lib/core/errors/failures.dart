// lib/core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
  });
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required super.message,
    super.code,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

class InstrumentNotFoundFailure extends Failure {
  const InstrumentNotFoundFailure({
    required super.message,
    super.code,
  });
}

class PortfolioFailure extends Failure {
  const PortfolioFailure({
    required super.message,
    super.code,
  });
}

class RealTimeFailure extends Failure {
  const RealTimeFailure({
    required super.message,
    super.code,
  });
}