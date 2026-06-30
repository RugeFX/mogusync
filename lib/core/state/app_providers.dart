import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api/api_config.dart';
import '../api/mogusync_api_client.dart';
import '../api/token_store.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main().');
});

final apiBaseUrlProvider = Provider<String>((ref) => ApiConfig.baseUrl);

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();
  ref.onDispose(client.close);
  return client;
});

final mogusyncApiClientProvider = Provider<MogusyncApiClient>((ref) {
  return MogusyncApiClient(
    baseUrl: ref.watch(apiBaseUrlProvider),
    httpClient: ref.watch(httpClientProvider),
  );
});

final tokenStoreProvider = Provider<TokenStore>((ref) {
  return SharedPreferencesTokenStore(ref.watch(sharedPreferencesProvider));
});
