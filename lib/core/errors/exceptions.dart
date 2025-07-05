// lib/core/errors/exceptions.dart
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  const AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class InstrumentNotFoundException extends AppException {
  const InstrumentNotFoundException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class PortfolioException extends AppException {
  const PortfolioException({
    required super.message,
    super.code,
    super.originalException,
  });
}

class RealTimeException extends AppException {
  const RealTimeException({
    required super.message,
    super.code,
    super.originalException,
  });
}