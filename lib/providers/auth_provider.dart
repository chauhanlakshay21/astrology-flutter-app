import 'package:flutter/foundation.dart';

class User {
  final String name;
  final String email;
  final String phone;
  final String password;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });
}

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  // In-memory mock users
  final List<User> _users = [];

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      final user = _users.firstWhere(
              (u) => u.email == email && u.password == password,
          orElse: () => throw Exception('Invalid email or password'));
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Signup with details
  Future<bool> signupWithDetails({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    try {
      // Check if email already exists
      final exists = _users.any((u) => u.email == email);
      if (exists) throw Exception('Email already exists');

      // Add user to mock database
      _users.add(User(
        name: name,
        email: email,
        password: password,
        phone: phone,
      ));

      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
