import 'dart:convert';

import 'package:frontend/api/models.dart';
import 'package:frontend/auth/token_store.dart';
import 'package:frontend/config.dart';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class ApiClient {
  final http.Client _http;
  final TokenStore _tokens;

  ApiClient({http.Client? httpClient, TokenStore? tokenStore})
    : _http = httpClient ?? http.Client(),
      _tokens = tokenStore ?? TokenStore();

  Uri _uri(String path, [Map<String, String>? query]) {
    final base = AppConfig.apiBaseUrl;
    return Uri.parse('$base$path').replace(queryParameters: query);
  }

  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (auth) {
      final token = await _tokens.getToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  Exception _errorFrom(http.Response res) {
    try {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final msg = body['message'] as String?;
      if (msg != null && msg.isNotEmpty) {
        return ApiException(msg);
      }
    } catch (_) {}
    return ApiException('Error HTTP ${res.statusCode}');
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final res = await _http.post(
      _uri('/api/auth/login'),
      headers: await _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (res.statusCode >= 400) throw _errorFrom(res);
    return AuthResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<AuthResponse> register({
    required String email,
    required String displayName,
    required String password,
  }) async {
    final res = await _http.post(
      _uri('/api/auth/register'),
      headers: await _headers(),
      body: jsonEncode({
        'email': email,
        'displayName': displayName,
        'password': password,
      }),
    );
    if (res.statusCode >= 400) throw _errorFrom(res);
    return AuthResponse.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<List<GameSummary>> listGames({String? q}) async {
    final query = <String, String>{};
    if (q != null && q.trim().isNotEmpty) query['q'] = q.trim();
    final res = await _http.get(
      _uri('/api/store/games', query),
      headers: await _headers(),
    );
    if (res.statusCode >= 400) throw _errorFrom(res);
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => GameSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<GameDetails> getGameDetails(String slug) async {
    final res = await _http.get(
      _uri('/api/store/games/$slug'),
      headers: await _headers(),
    );
    if (res.statusCode >= 400) throw _errorFrom(res);
    return GameDetails.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<List<LibraryItem>> getLibrary() async {
    final res = await _http.get(
      _uri('/api/library'),
      headers: await _headers(auth: true),
    );
    if (res.statusCode >= 400) throw _errorFrom(res);
    final list = jsonDecode(res.body) as List<dynamic>;
    return list
        .map((e) => LibraryItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> purchase(List<String> gameIds) async {
    final res = await _http.post(
      _uri('/api/purchase'),
      headers: await _headers(auth: true),
      body: jsonEncode({'gameIds': gameIds}),
    );
    if (res.statusCode >= 400) throw _errorFrom(res);
  }
}
