import 'package:flutter/material.dart';
import 'package:frontend/api/api_client.dart';
import 'package:frontend/api/models.dart';
import 'package:frontend/auth/token_store.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _api;
  final TokenStore _tokens;

  bool _initializing = false;
  UserDto? _user;

  AuthProvider({ApiClient? apiClient, TokenStore? tokenStore})
    : _api = apiClient ?? ApiClient(),
      _tokens = tokenStore ?? TokenStore();

  bool get isLoggedIn => _user != null;
  bool get isInitializing => _initializing;
  UserDto? get user => _user;

  String? get username => _user?.displayName;
  String? get userRole => _user?.role;

  Future<void> init() async {
    if (_initializing) return;
    _initializing = true;
    notifyListeners();
    try {
      final token = await _tokens.getToken();
      if (token == null || token.trim().isEmpty) {
        _user = null;
        return;
      }
      _user = await _api.me();
    } catch (_) {
      _user = null;
      await _tokens.clear();
    } finally {
      _initializing = false;
      notifyListeners();
    }
  }

  Future<void> login({required String email, required String password}) async {
    final res = await _api.login(email: email, password: password);
    await _tokens.setToken(res.accessToken);
    _user = res.user;
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String displayName,
    required String password,
  }) async {
    final res = await _api.register(email: email, displayName: displayName, password: password);
    await _tokens.setToken(res.accessToken);
    _user = res.user;
    notifyListeners();
  }

  Future<void> logout() async {
    await _tokens.clear();
    _user = null;
    notifyListeners();
  }
}
