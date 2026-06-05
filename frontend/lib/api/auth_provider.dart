import 'package:flutter/material.dart';
import 'package:frontend/api/api_client.dart';
import 'package:frontend/api/models.dart';
import 'package:frontend/api/repository_provider.dart';
import 'package:frontend/auth/token_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final ApiClient _api;
  final TokenStore _tokens;

  static const _mockCurrentUserKey = 'mock_current_user_v1';
  static const _mockUsersKey = 'mock_users_v1';

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

  bool get _useMockAuth => RepositoryProvider.mode != RepositoryMode.api;

  Future<void> init() async {
    if (_initializing) return;
    _initializing = true;
    notifyListeners();
    try {
      if (_useMockAuth) {
        await _ensureMockSeed();
        _user = await _getMockCurrentUser();
        return;
      }
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
    if (_useMockAuth) {
      await _ensureMockSeed();
      final users = await _getMockUsers();
      final normalizedEmail = email.trim().toLowerCase();
      final match = users.where((u) => u.email == normalizedEmail).toList();
      if (match.isEmpty || match.first.password != password) {
        throw ApiException('Credenciales inválidas');
      }
      final u = match.first;
      _user = UserDto(id: u.id, email: u.email, displayName: u.displayName, role: u.role);
      await _setMockCurrentUser(_user!);
      await _tokens.setToken('mock');
      notifyListeners();
      return;
    }
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
    if (_useMockAuth) {
      await _ensureMockSeed();
      final normalizedEmail = email.trim().toLowerCase();
      final users = await _getMockUsers();
      if (users.any((u) => u.email == normalizedEmail)) {
        throw ApiException('El email ya está registrado');
      }
      final record = _MockUserRecord(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        email: normalizedEmail,
        displayName: displayName.trim(),
        password: password,
        role: 'USER',
      );
      users.add(record);
      await _setMockUsers(users);
      _user = UserDto(
        id: record.id,
        email: record.email,
        displayName: record.displayName,
        role: record.role,
      );
      await _setMockCurrentUser(_user!);
      await _tokens.setToken('mock');
      notifyListeners();
      return;
    }
    final res = await _api.register(email: email, displayName: displayName, password: password);
    await _tokens.setToken(res.accessToken);
    _user = res.user;
    notifyListeners();
  }

  Future<void> logout() async {
    await _tokens.clear();
    _user = null;
    if (_useMockAuth) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_mockCurrentUserKey);
    }
    notifyListeners();
  }

  Future<void> _ensureMockSeed() async {
    final users = await _getMockUsers();
    if (users.any((u) => u.email == 'admin@local')) return;
    users.add(
      _MockUserRecord(
        id: 'admin',
        email: 'admin@local',
        displayName: 'Admin',
        password: 'adminadmin',
        role: 'ADMIN',
      ),
    );
    await _setMockUsers(users);
  }

  Future<UserDto?> _getMockCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('$_mockCurrentUserKey.id');
    final email = prefs.getString('$_mockCurrentUserKey.email');
    final displayName = prefs.getString('$_mockCurrentUserKey.displayName');
    final role = prefs.getString('$_mockCurrentUserKey.role');
    if (id == null || email == null || displayName == null || role == null) return null;
    return UserDto(id: id, email: email, displayName: displayName, role: role);
  }

  Future<void> _setMockCurrentUser(UserDto u) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_mockCurrentUserKey.id', u.id);
    await prefs.setString('$_mockCurrentUserKey.email', u.email);
    await prefs.setString('$_mockCurrentUserKey.displayName', u.displayName);
    await prefs.setString('$_mockCurrentUserKey.role', u.role);
  }

  Future<List<_MockUserRecord>> _getMockUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final n = prefs.getInt('$_mockUsersKey.count') ?? 0;
    final users = <_MockUserRecord>[];
    for (int i = 0; i < n; i++) {
      final base = '$_mockUsersKey.$i';
      final id = prefs.getString('$base.id');
      final email = prefs.getString('$base.email');
      final displayName = prefs.getString('$base.displayName');
      final password = prefs.getString('$base.password');
      final role = prefs.getString('$base.role');
      if (id == null || email == null || displayName == null || password == null || role == null) {
        continue;
      }
      users.add(_MockUserRecord(id: id, email: email, displayName: displayName, password: password, role: role));
    }
    return users;
  }

  Future<void> _setMockUsers(List<_MockUserRecord> users) async {
    final prefs = await SharedPreferences.getInstance();
    final prev = prefs.getInt('$_mockUsersKey.count') ?? 0;
    for (int i = 0; i < prev; i++) {
      final base = '$_mockUsersKey.$i';
      await prefs.remove('$base.id');
      await prefs.remove('$base.email');
      await prefs.remove('$base.displayName');
      await prefs.remove('$base.password');
      await prefs.remove('$base.role');
    }
    await prefs.setInt('$_mockUsersKey.count', users.length);
    for (int i = 0; i < users.length; i++) {
      final u = users[i];
      final base = '$_mockUsersKey.$i';
      await prefs.setString('$base.id', u.id);
      await prefs.setString('$base.email', u.email);
      await prefs.setString('$base.displayName', u.displayName);
      await prefs.setString('$base.password', u.password);
      await prefs.setString('$base.role', u.role);
    }
  }
}

class _MockUserRecord {
  final String id;
  final String email;
  final String displayName;
  final String password;
  final String role;

  _MockUserRecord({
    required this.id,
    required this.email,
    required this.displayName,
    required this.password,
    required this.role,
  });
}
