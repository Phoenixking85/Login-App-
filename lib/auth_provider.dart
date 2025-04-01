import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_model.dart';
import 'api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  List<Product> _products = [];

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  List<Product> get products => _products;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await ApiService().login(email, password);

      if (user != null) {
        _currentUser = user;
        await _saveUserToPrefs(user);
        _products = await ApiService().fetchProducts();
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Login error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> _saveUserToPrefs(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', user.id);
      await prefs.setString('email', user.email);
      await prefs.setString('username', user.username);
      await prefs.setString('firstName', user.firstName);
      await prefs.setString('lastName', user.lastName);
      await prefs.setString('token', user.token ?? '');
      await prefs.setBool('isLoggedIn', true);
    } catch (e) {
      print('Error saving user to prefs: $e');
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _currentUser = null;
      _products = [];
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  Future<bool> checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null && token.isNotEmpty) {
        _currentUser = User(
          id: prefs.getInt('userId') ?? 0,
          email: prefs.getString('email') ?? '',
          username: prefs.getString('username') ?? '',
          firstName: prefs.getString('firstName') ?? '',
          lastName: prefs.getString('lastName') ?? '',
          token: token,
        );

        _products = await ApiService().fetchProducts();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }
}
