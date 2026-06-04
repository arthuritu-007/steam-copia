import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _username;
  String? _userRole;

  bool get isLoggedIn => _isLoggedIn;
  String? get username => _username;
  String? get userRole => _userRole;

  void login(String username, [String role = 'USER']) {
    _isLoggedIn = true;
    _username = username;
    _userRole = role;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _username = null;
    _userRole = null;
    notifyListeners();
  }
}
