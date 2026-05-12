class ServerException implements Exception {
  final String message;
  final int? statusCode;
  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException({required this.message});

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;
  CacheException({required this.message});
}
