import 'dart:convert';

import 'package:livelynk/models/contact_model.dart';
import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/services/hive_service.dart';
import 'package:livelynk/services/http_service.dart';
import 'package:livelynk/services/api_routes.dart';
import 'package:livelynk/utils/enums/contact_status_enum.dart';
import 'package:livelynk/utils/extensions/contact_extension.dart';
import 'package:livelynk/utils/toast.dart';

class ContactApiService {
  static Future<Map<int, Contact>> fetchContacts(
    int? userId,
    ContactStatus status,
    bool isSendContact,
  ) async {
    final response = await HttpService.send(
      'GET',
      '${APIRoutes.getContacts}contactId=$userId&status=${status.toShortString()}&isSendContact=$isSendContact',
    );

    if (response.last == 200) {
      final body = json.decode(response.first);
      final contacts = body['data'] as List<dynamic>;

      return getContactMap(contacts);
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  static Map<int, Contact> getContactMap(List<dynamic> contacts) {
    Map<int, Contact> contactsMap = Map.fromEntries(
      contacts.map((data) {
        final contact = Contact.fromJson(data);
        return MapEntry(contact.userId ?? 0, contact);
      }),
    );
    return contactsMap;
  }

  static Future<Set> acceptContactRequest(
      String contactId, int currentUserId) async {
    return await HttpService.send(
      'POST',
      APIRoutes.acceptContactRequest,
      {'contactId': contactId, 'currentUserId': currentUserId},
    );
  }

  static Future<Set> deleteContact(String contactUserId) async {
    return await HttpService.send(
      'DELETE',
      APIRoutes.deleteContact,
      {
        'contactId': contactUserId,
        "currentUserId": HiveService.currentUser!.userId!
      },
    );
  }

  static Future<Set> addContact(int currentUserId, int requestUserId) async {
    return await HttpService.send(
      'POST',
      APIRoutes.addContact,
      {'requestUserId': requestUserId, 'currentUserId': currentUserId},
    );
  }

  static Future<Map<int, Contact>> fetchTotalContacts(int? userId) async {
    final response = await HttpService.send(
      'GET',
      '${APIRoutes.getAllContacts}userId=$userId',
    );

    if (response.last == 200) {
      final contacts = json.decode(response.first)['data'] as List<dynamic>;
      return getContactMap(contacts);
    } else {
      showErrorToast();
      throw Exception('Failed to fetch users');
    }
  }

  static Future<Map<int, Contact>> fetchChatContacts(int? userId) async {
    final response = await HttpService.send(
      'GET',
      '${APIRoutes.getChatContacts}currentUserId=$userId',
    );

    if (response.last == 200) {
      final contacts = json.decode(response.first)['data'] as List<dynamic>;
      return getContactMap(contacts);
    } else {
      showErrorToast();
      throw Exception('Failed to fetch users');
    }
  }

  static Future<Set> inviteRoom(
      String currentUserId, String contactUserId, String roomId) async {
    return await HttpService.send(
      'POST',
      '${APIRoutes.baseUrl}/invite_to_room',
      {
        'inviterId': currentUserId,
        'inviteeId': contactUserId,
        'roomId': roomId
      },
    );
  }
}
