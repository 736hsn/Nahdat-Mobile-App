import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../di/dependency_injection.dart';
import 'notifications_service.dart';

@singleton
class AuthService {
  static const String _tokenKey = 'token';

  // Check if user is authenticated
  bool get isAuthenticated {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  // Get the stored token
  String? getToken() {
    return sharedPreferences?.getString(_tokenKey);
  }

  // Save token after successful login
  Future<bool> saveToken(String token) async {
    try {
      return await sharedPreferences?.setString(_tokenKey, token) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Logout - clear all auth data
  Future<bool> logout() async {
    try {
      bool success = true;
      success &= await sharedPreferences?.remove(_tokenKey) ?? false;

      // Clear OneSignal external ID
      await NotificationsService.removeExternalUserId();

      return success;
    } catch (e) {
      return false;
    }
  }

  // Clear only token (for token refresh scenarios)
  Future<bool> clearToken() async {
    try {
      return await sharedPreferences?.remove(_tokenKey) ?? false;
    } catch (e) {
      return false;
    }
  }
}
