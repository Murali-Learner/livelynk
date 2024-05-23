import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/services/hive_service.dart';
import 'package:livelynk/utils/enums/contact_status_enum.dart';
import 'package:livelynk/utils/toast.dart';
import '../services/http_service.dart';

class AuthProvider with ChangeNotifier {
  final HttpService httpService;

  AuthProvider({required this.httpService}) : _filteredUsers = List.from([]);

  bool _obscureText = true;
  bool get obscureText => _obscureText;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  List<User> _allUsers = [];
  List<User> _chatUsers = [];
  List<User> _invitedUsers = [];
  List<User> _requestedUsers = [];
  List<User> _acceptedUsers = [];
  List<User> _filteredUsers = [];

  List<User> get filteredUsers => _filteredUsers;
  List<User> get allUsers => _allUsers;
  List<User> get requestedUsers => _requestedUsers;
  List<User> get acceptedUsers => _acceptedUsers;
  List<User> get chatUsers => _chatUsers;
  List<User> get invitedUsers => _invitedUsers;
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
          userId: responseData['user']['userId'].toString(),
          username: username,
          email: email,
        );
        _user = newUser;
        await HiveService.saveUser(newUser);
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

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    bool success = false;
    try {
      final response = await httpService.login(email, password);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        final User loggedInUser = User(
          userId: responseData['user']['userId'].toString(),
          email: responseData['user']['email'].toString(),
          username: responseData['user']['username'].toString(),
        );
        _user = loggedInUser;
        await HiveService.saveUser(loggedInUser);
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

  Future<void> fetchUsers(
    ContactStatus status,
    bool isSendContact,
  ) async {
    _setLoading(true);
    try {
      if (status == ContactStatus.ACCEPTED) {
        _acceptedUsers.clear();
        _acceptedUsers = await httpService.fetchContacts(
            HiveService.currentUser!.userId!,
            ContactStatus.ACCEPTED,
            isSendContact);
      } else if (isSendContact) {
        _invitedUsers.clear();
        _invitedUsers = await httpService.fetchContacts(
            HiveService.currentUser!.userId!,
            ContactStatus.INVITED,
            isSendContact);
      } else {
        _requestedUsers.clear();
        _requestedUsers = await httpService.fetchContacts(
            HiveService.currentUser!.userId!,
            ContactStatus.INVITED,
            isSendContact);
      }

      notifyListeners();
      _setLoading(false);
    } catch (e) {
      _setErrorMessage(e.toString());
    }
    _setLoading(false);
  }

  Future<void> acceptContactRequest(String contactUserId) async {
    _setLoading(true);
    try {
      final response = await httpService.acceptContactRequest(
          contactUserId, int.parse(HiveService.currentUser!.userId!));
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['data']) {
        requestedUsers
            .removeWhere((element) => element.contactId == contactUserId);
        showSuccessToast(message: "Contact Added");
        notifyListeners();
        _setErrorMessage(null);
      } else {
        _setErrorMessage("Unable to add contact at this moment. ");
        showErrorToast(message: 'Unable to add contact at this moment.');
      }
    } catch (e) {
      _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
    _setLoading(false);
  }

  Future<void> addContact(String requestedMail) async {
    _setLoading(true);
    try {
      final response = await httpService.addContact(
          int.parse(HiveService.currentUser!.userId!), requestedMail);
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['data']) {
        // invitedUsers.removeWhere((element) => element.email == requestedMail);

        acceptedUsers.removeWhere((element) => element.email == requestedMail);
        filteredUsers.removeWhere((element) => element.email == requestedMail);
        allUsers.removeWhere((element) => element.email == requestedMail);

        await fetchUsers(ContactStatus.INVITED, true);
        showSuccessToast(message: "Contact Invited");
        notifyListeners();
        _setErrorMessage(null);
      } else {
        _setErrorMessage("Unable to deelte contact at this moment. ");
        showErrorToast(message: 'Unable to delete contact at this moment.');
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
      final response = await httpService.deleteContact(contactUserId);
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['data']) {
        invitedUsers
            .removeWhere((element) => element.contactId == contactUserId);
        acceptedUsers
            .removeWhere((element) => element.contactId == contactUserId);

        showSuccessToast(message: "Contact deleted");
        notifyListeners();
        _setErrorMessage(null);
      } else {
        _setErrorMessage("Unable to deelte contact at this moment. ");
        showErrorToast(message: 'Unable to delete contact at this moment.');
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
      _filteredUsers.clear();
      _filteredUsers.addAll(_allUsers);

      notifyListeners();
    } catch (e) {
      _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
  }

  void filterUsers(String query) {
    query = query.toLowerCase();
    _filteredUsers.clear();
    _filteredUsers = _allUsers.where((user) {
      return user.username.toLowerCase().contains(query) ||
          user.email!.toLowerCase().contains(query);
    }).toList();
    notifyListeners();
  }

//not working
  Future<void> fetchChatUsers() async {
    try {
      _chatUsers.clear();
      _chatUsers =
          await httpService.fetchChatContacts(HiveService.currentUser!.userId!);

      notifyListeners();
    } catch (e) {
      _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
  }

  Future<void> inviteRoom(
      String currentUserId, String contactUserId, String roomId) async {
    _setLoading(true);
    try {
      final response =
          await httpService.inviteRoom(currentUserId, contactUserId, roomId);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        debugPrint("invite room res $responseData");
        final contacts = json.decode(response.body)['remainingContacts'];

        _invitedUsers.clear();
        _invitedUsers =
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

  void togglePassword() {
    _obscureText = !_obscureText;

    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
}
