import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract final class ApiConfig {
  static const keyApiBaseUrl = 'MOGUSYNC_API_BASE_URL';
  static const defaultBaseUrl = 'http://localhost:8080';
  static const _dartDefineBaseUrl = String.fromEnvironment(
    'MOGUSYNC_API_BASE_URL',
    defaultValue: '',
  );

  static String get baseUrl {
    if (_dartDefineBaseUrl.isNotEmpty) {
      return _dartDefineBaseUrl;
    }

    if (dotenv.isInitialized) {
      return dotenv.maybeGet(keyApiBaseUrl, fallback: defaultBaseUrl)!;
    }

    return defaultBaseUrl;
  }
}
