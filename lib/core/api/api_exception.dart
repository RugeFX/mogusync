class ApiException implements Exception {
  const ApiException({
    required this.statusCode,
    required this.message,
    this.code,
  });

  final int statusCode;
  final String message;
  final String? code;

  bool get isUnauthorized => statusCode == 401;

  @override
  String toString() {
    final label = code == null ? '$statusCode' : '$statusCode $code';
    return 'ApiException($label): $message';
  }
}
