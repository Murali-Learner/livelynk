import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/services/hive_service.dart';
import 'package:livelynk/utils/enums/contact_status_enum.dart';
import 'package:livelynk/utils/toast.dart';
import 'package:livelynk/views/contacts/api/contact_api_service.dart';

class ContactProvider extends ChangeNotifier {
  ContactProvider();
  List<Contact> _allUsers = [];
  List<Contact> _chatUsers = [];
  List<Contact> _invitedUsers = [];
  List<Contact> _requestedUsers = [];
  List<Contact> _acceptedUsers = [];
  List<Contact> _filteredUsers = [];
  List<Contact> get filteredUsers => _filteredUsers;
  List<Contact> get allUsers => _allUsers;
  List<Contact> get requestedUsers => _requestedUsers;
  List<Contact> get acceptedUsers => _acceptedUsers;
  List<Contact> get chatUsers => _chatUsers;
  List<Contact> get invitedUsers => _invitedUsers;

  Contact? _user;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Contact? get user => _user;
  //
  Future<void> fetchUsers(
    ContactStatus status,
    bool isSendContact,
  ) async {
    _setLoading(true);
    try {
      if (status == ContactStatus.ACCEPTED) {
        _acceptedUsers.clear();
        _acceptedUsers = await ContactApiService.fetchContacts(
            HiveService.currentUser!.userId!,
            ContactStatus.ACCEPTED,
            isSendContact);
      } else if (isSendContact) {
        _invitedUsers.clear();
        _invitedUsers = await ContactApiService.fetchContacts(
            HiveService.currentUser!.userId!,
            ContactStatus.INVITED,
            isSendContact);
      } else {
        _requestedUsers.clear();
        _requestedUsers = await ContactApiService.fetchContacts(
            HiveService.currentUser!.userId!,
            ContactStatus.INVITED,
            isSendContact);
      }

      notifyListeners();
      _setLoading(false);
    } catch (e) {
      // _setErrorMessage(e.toString());
    }
    _setLoading(false);
  }

  Future<void> acceptContactRequest(String contactUserId) async {
    _setLoading(true);
    try {
      final response = await ContactApiService.acceptContactRequest(
          contactUserId, int.parse(HiveService.currentUser!.userId!));
      final Map<String, dynamic> responseData = json.decode(response.first);

      if (responseData['data']) {
        requestedUsers
            .removeWhere((element) => element.contactId == contactUserId);
        showSuccessToast(message: "Contact Added");
        notifyListeners();
        // _setErrorMessage(null);
      } else {
        // _setErrorMessage("Unable to add contact at this moment. ");
        showErrorToast(message: 'Unable to add contact at this moment.');
      }
    } catch (e) {
      log(e.toString());
      // _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
    _setLoading(false);
  }

  Future<void> addContact(String requestedMail) async {
    try {
      final response = await ContactApiService.addContact(
          int.parse(HiveService.currentUser!.userId!), requestedMail);
      final Map<String, dynamic> responseData = json.decode(response.first);
      log(responseData.toString());
      if (responseData['data']) {
        // invitedUsers.removeWhere((element) => element.email == requestedMail);

        acceptedUsers.removeWhere((element) => element.email == requestedMail);
        filteredUsers.removeWhere((element) => element.email == requestedMail);
        allUsers.removeWhere((element) => element.email == requestedMail);

        await fetchUsers(ContactStatus.INVITED, true);
        showSuccessToast(message: "Contact Invited");
        notifyListeners();
      } else {
        showErrorToast(message: "Send invite failed!");
      }
    } catch (e) {
      log(e.toString());
      // _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
    _setLoading(false);
  }

  Future<void> deleteContact(String contactUserId) async {
    _setLoading(true);

    try {
      final response = await ContactApiService.deleteContact(contactUserId);
      final Map<String, dynamic> responseData = json.decode(response.first);

      if (responseData['data']) {
        invitedUsers
            .removeWhere((element) => element.contactId == contactUserId);
        acceptedUsers
            .removeWhere((element) => element.contactId == contactUserId);

        showSuccessToast(message: "Contact deleted");
        notifyListeners();
        // _setErrorMessage(null);
      } else {
        // _setErrorMessage("Unable to delete contact at this moment. ");
        showErrorToast(message: 'Unable to delete contact at this moment.');
      }
    } catch (e) {
      // _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
    _setLoading(false);
  }

  Future<void> fetchAllUsers() async {
    try {
      _allUsers.clear();
      _allUsers = await ContactApiService.fetchTotalContacts(
          HiveService.currentUser!.userId!);
      _filteredUsers.clear();
      _filteredUsers.addAll(_allUsers);

      notifyListeners();
    } catch (e) {
      // _setErrorMessage(e.toString());
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
      _chatUsers = await ContactApiService.fetchChatContacts(
          HiveService.currentUser!.userId!);

      notifyListeners();
    } catch (e) {
      // _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
  }

  Future<void> inviteRoom(
      String currentUserId, String contactUserId, String roomId) async {
    _setLoading(true);
    try {
      final response = await ContactApiService.inviteRoom(
          currentUserId, contactUserId, roomId);
      if (response.lastOrNull == 200) {
        final Map<String, dynamic> responseData = json.decode(response.first);
        debugPrint("invite room res $responseData");
        final contacts = json.decode(response.first)['remainingContacts'];

        _invitedUsers.clear();
        _invitedUsers =
            (contacts as List).map((data) => Contact.fromJson(data)).toList();
      } else {
        showErrorToast(message: json.decode(response.first)['message']);
      }
    } catch (e) {
      // _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
