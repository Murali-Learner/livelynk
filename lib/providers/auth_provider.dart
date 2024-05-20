import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/services/hive_service.dart';
import 'package:livelynk/views/utils/toast.dart';
import '../services/http_service.dart';

class AuthProvider with ChangeNotifier {
  final HttpService httpService;

  AuthProvider({required this.httpService});

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  List<User> _allUsers = [];
  List<User> _chatUsers = [];
  List<User> _myUsers = [];

  List<User> get allUsers => _allUsers;
  List<User> get chatUsers => _allUsers;
  List<User> get myUsers => _myUsers;
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> register(String username, String email, String password) async {
    _setLoading(true);
    bool success = false;
    try {
      final response = await httpService.register(username, email, password);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final User newUser = User(
          userId: responseData['user']['userId'],
          username: username,
          email: email,
        );
        _user = newUser;
        await HiveService.saveUsername(newUser);
        _setErrorMessage(null);
        success = true;
      } else {
        _setErrorMessage(json.decode(response.body)['message'] ?? '');
      }
    } catch (e) {
      _setErrorMessage(e.toString());
    }
    _setLoading(false);
    return success;
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    bool success = false;
    try {
      final response = await httpService.login(username, password);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        final User loggedInUser = User(
          userId: responseData['user']['userId'],
          username: username,

          email: '', // Placeholder email
        );
        _user = loggedInUser;
        await HiveService.saveUsername(loggedInUser);
        _setErrorMessage(null);
        success = true;
      } else {
        _setErrorMessage(json.decode(response.body)['message'] ?? '');
        showErrorToast(message: json.decode(response.body)['message']);
      }
    } catch (e) {
      _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
    _setLoading(false);
    return success;
  }

  Future<void> addContact(String contactUserId) async {
    _setLoading(true);

    try {
      final response = await httpService.addContact(
          HiveService.currentUser!.userId!, contactUserId);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        await fetchAllUsers();

        final contacts = responseData['user']['contacts'];
        _myUsers.clear();
        _myUsers =
            (contacts as List).map((data) => User.fromJson(data)).toList();

        // final User user = User(username: HiveService.currentUser!.username)
        //     .copyWith(contacts: _myUsers);
        // HiveService.clearDB();
        // await HiveService.saveUsername(user);

        _setErrorMessage(null);
      } else {
        _setErrorMessage(json.decode(response.body)['message'] ?? '');
        showErrorToast(message: json.decode(response.body)['message']);
      }
    } catch (e) {
      _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
    _setLoading(false);
  }

  Future<void> deleteContact(String contactUserId) async {
    _setLoading(true);

    try {
      final response = await httpService.deleteContact(
          HiveService.currentUser!.userId!, contactUserId);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        await fetchAllUsers();

        final contacts = responseData['user']['contacts'];
        _myUsers.clear();
        _myUsers =
            (contacts as List).map((data) => User.fromJson(data)).toList();

        _setErrorMessage(null);
      } else {
        _setErrorMessage(json.decode(response.body)['message'] ?? '');
        showErrorToast(message: json.decode(response.body)['message']);
      }
    } catch (e) {
      _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
    _setLoading(false);
  }

  Future<void> fetchAllUsers() async {
    try {
      _allUsers.clear();
      _allUsers = await httpService
          .fetchTotalContacts(HiveService.currentUser!.userId!);
      notifyListeners();
    } catch (e) {
      _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
  }

  Future<void> fetchChatUsers() async {
    try {
      _chatUsers.clear();
      _chatUsers =
          await httpService.fetchChatContacts(HiveService.currentUser!.userId!);
      log("chat users ${_chatUsers.length} ");
      notifyListeners();
    } catch (e) {
      _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
  }

  Future<void> fetchMyUsers() async {
    try {
      _myUsers.clear();
      _myUsers =
          await httpService.fetchMyUsers(HiveService.currentUser!.userId!);
      notifyListeners();
    } catch (e) {
      _setErrorMessage(e.toString());
    }
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
}
