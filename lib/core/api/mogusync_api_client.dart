import 'dart:convert';

import 'package:http/http.dart' as http;

import 'api_exception.dart';

class MogusyncApiClient {
  const MogusyncApiClient({required this.baseUrl, required this.httpClient});

  final String baseUrl;
  final http.Client httpClient;

  Future<Map<String, Object?>> getJson(
    String path, {
    String? accessToken,
  }) async {
    final response = await httpClient.get(
      _uri(path),
      headers: _headers(accessToken: accessToken),
    );

    return _decodeResponse(response);
  }

  Future<Map<String, Object?>> postJson(
    String path, {
    Map<String, Object?> body = const {},
    String? accessToken,
  }) async {
    final response = await httpClient.post(
      _uri(path),
      headers: _headers(accessToken: accessToken),
      body: jsonEncode(body),
    );

    return _decodeResponse(response);
  }

  Future<Map<String, Object?>> patchJson(
    String path, {
    required Map<String, Object?> body,
    String? accessToken,
  }) async {
    final response = await httpClient.patch(
      _uri(path),
      headers: _headers(accessToken: accessToken),
      body: jsonEncode(body),
    );

    return _decodeResponse(response);
  }

  Future<Map<String, Object?>> deleteJson(
    String path, {
    String? accessToken,
  }) async {
    final response = await httpClient.delete(
      _uri(path),
      headers: _headers(accessToken: accessToken),
    );

    return _decodeResponse(response);
  }

  Uri _uri(String path) {
    final normalizedBaseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;

    return Uri.parse(normalizedBaseUrl).resolve(normalizedPath);
  }

  Map<String, String> _headers({String? accessToken}) {
    return {
      'accept': 'application/json',
      'content-type': 'application/json',
      if (accessToken != null) 'authorization': 'Bearer $accessToken',
    };
  }

  Map<String, Object?> _decodeResponse(http.Response response) {
    final decoded = response.body.isEmpty
        ? <String, Object?>{}
        : jsonDecode(response.body) as Map<String, Object?>;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    throw ApiException(
      statusCode: response.statusCode,
      code: decoded['code'] as String?,
      message:
          decoded['message'] as String? ??
          'Request failed with status ${response.statusCode}.',
    );
  }
}
