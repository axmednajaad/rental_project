import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_service.dart';

class AuthService {
  static const String _userKey = 'current_user';

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(json.decode(userJson));
    }
    return null;
  }

  static Future<void> saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<User?> login(String email, String password) async {
    try {
      final user = await ApiService.loginUser(email, password);
      print('Logged in user: $user');
      await saveCurrentUser(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  static Future<User?> register(
    String name,
    String email,
    String phone,
    String password, {
    String role = 'user',
  }) async {
    try {
      final user = await ApiService.registerUser(
        name: name,
        email: email,
        phone: phone,
        password: password,
        role: role,
      );
      await saveCurrentUser(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  static Future<bool> changePassword(
    int userId,
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await ApiService.changePassword(
        userId: userId,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
}
