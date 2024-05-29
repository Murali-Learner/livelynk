import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:livelynk/models/contact_model.dart';
import 'package:livelynk/services/hive_service.dart';
import 'package:livelynk/utils/enums/contact_status_enum.dart';
import 'package:livelynk/utils/toast.dart';
import 'package:livelynk/views/contacts/api/contact_api_service.dart';

class ContactProvider extends ChangeNotifier {
  ContactProvider();
  Map<int, Contact> _unRequestedUsers = {};
  final Map<int, Contact> _chatUsers = {};
  Map<int, Contact> _invitedUsers = {};
  Map<int, Contact> _requestedUsers = {};
  Map<int, Contact> _acceptedUsers = {};
  Map<int, Contact> get unRequestedUsers => _unRequestedUsers;
  Map<int, Contact> get requestedUsers => _requestedUsers;
  Map<int, Contact> get acceptedUsers => _acceptedUsers;
  Map<int, Contact> get invitedUsers => _invitedUsers;

  Contact? _user;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Contact? get user => _user;
  //
  Future<void> fetchUsers({
    required ContactStatus status,
    required bool isSendContact,
  }) async {
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

  Future<void> acceptContactRequest(Contact contact) async {
    _setLoading(true);
    try {
      final response = await ContactApiService.acceptContactRequest(
        contact.contactId ?? "",
        (HiveService.currentUser!.userId!),
      );
      final Map<String, dynamic> responseData = json.decode(response.first);

      if (responseData['data']) {
        requestedUsers.remove(contact.userId);
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

  Future<void> addContact(int requestUserId) async {
    try {
      final response = await ContactApiService.addContact(
        (HiveService.currentUser!.userId!),
        requestUserId,
      );
      final Map<String, dynamic> responseData = json.decode(response.first);
      if (responseData['data']) {
        acceptedUsers.remove(requestUserId);
        unRequestedUsers.remove(requestUserId);

        await fetchUsers(
          status: ContactStatus.INVITED,
          isSendContact: true,
        );
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
  }

  Future<void> deleteContact(
    Contact contact, {
    bool isRequestedContact = false,
  }) async {
    try {
      final response = await ContactApiService.deleteContact(
        contact.contactId ?? "",
      );
      final Map<String, dynamic> responseData = json.decode(response.first);

      if (responseData['data']) {
        invitedUsers.remove(contact.userId);
        acceptedUsers.remove(contact.userId);
        if (isRequestedContact) {
          requestedUsers.remove(contact.userId);
        }

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
  }

  Future<void> fetchAllUsers() async {
    try {
      _unRequestedUsers.clear();
      _unRequestedUsers = await ContactApiService.fetchTotalContacts(
          HiveService.currentUser!.userId!);

      notifyListeners();
    } catch (e) {
      // _setErrorMessage(e.toString());
      showErrorToast(message: e.toString());
    }
  }

  void filterUsers(String query) {
    query = query.toLowerCase();
    // TODO: implement in future
    // _allUsers = _allUsers.where((user) {
    //   return user.username.toLowerCase().contains(query) ||
    //       user.email!.toLowerCase().contains(query);
    // }).toList();
    // notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
