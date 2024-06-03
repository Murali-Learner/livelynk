import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/services/hive_service.dart';
import 'package:livelynk/utils/toast.dart';
import 'package:livelynk/views/auth/api/auth_api_service.dart';

class AuthProvider with ChangeNotifier {
  bool _obscureText = true;
  bool get obscureText => _obscureText;
  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  Future<bool> register(String username, String email, String password) async {
    _setLoading(true);
    bool success = false;
    try {
      final response = await AuthApiService.register(username, email, password);

      if (response.lastOrNull == 200) {
        final Map<String, dynamic> responseData = json.decode(response.first);
        final User newUser = User(
          userId: responseData['user']['userId'],
          username: username,
          email: email,
          roomId: responseData["user"]["roomId"].toString(),
        );
        _user = newUser;
        await HiveService.saveUser(newUser);
        _setErrorMessage(null);
        success = true;
      } else {
        _setErrorMessage(json.decode(response.first)['message'] ?? '');
      }
    } catch (e) {
      _setErrorMessage(e.toString());
    }
    _setLoading(false);
    return success;
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    bool success = false;
    try {
      final response = await AuthApiService.login(email, password);
      if (response.lastOrNull == 200) {
        final Map<String, dynamic> responseData = json.decode(response.first);

        final User loggedInUser = User(
          userId: responseData['user']['userId'],
          email: responseData['user']['email'].toString(),
          username: responseData['user']['username'].toString(),
          roomId: responseData["user"]["roomId"].toString(),
        );
        _user = loggedInUser;
        await HiveService.saveUser(loggedInUser);
        _setErrorMessage(null);
        success = true;
      } else {
        _setErrorMessage(json.decode(response.first)['message'] ?? '');
        showErrorToast(message: json.decode(response.first)['message']);
      }
    } catch (e) {
      _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
    _setLoading(false);
    return success;
  }

  Future<void> fetchUserFromHive() async {
    await HiveService.init();
    _user = HiveService.currentUser!;
    notifyListeners();
  }

  void logout() {
    _user = null;
    HiveService.clearDB();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void togglePassword() {
    _obscureText = !_obscureText;

    notifyListeners();
  }
}
