import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:livelynk/models/user_model.dart';
import 'package:livelynk/services/routes.dart';
import 'package:livelynk/utils/enums/contact_status_enum.dart';
import 'package:livelynk/utils/extensions/contact_extension.dart';
import 'package:livelynk/utils/toast.dart';

class HttpService {
  static Future<http.Response> register(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse(APIRoutes.register),
      headers: {'Content-Type': 'application/json'},
      body: json
          .encode({'username': username, 'email': email, 'password': password}),
    );
    debugPrint("response ${response.body}");
    return response;
  }

  static Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(APIRoutes.login),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    return response;
  }

  static Future<List<Contact>> fetchContacts(
    String userId,
    ContactStatus status,
    bool isSendContact,
  ) async {
    final response = await http.get(
      Uri.parse(
          '${APIRoutes.getContacts}contactId=$userId&status=${status.toShortString()}&isSendContact=$isSendContact'),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      final contacts = body['data'] as List;

      List<Contact> users =
          (contacts).map((data) => Contact.fromJson(data)).toList();
      return users;
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  static Future<http.Response> acceptContactRequest(
      String contactId, int currentUserId) async {
    final response = await http.post(
      Uri.parse(APIRoutes.acceptContactRequest),
      headers: {'Content-Type': 'application/json'},
      body:
          json.encode({"contactId": contactId, "currentUserId": currentUserId}),
    );

    return response;
  }

  static Future<http.Response> deleteContact(String contactUserId) async {
    final url = Uri.parse(APIRoutes.deleteContact);

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {"contactId": contactUserId},
      ),
    );

    return response;
  }

  static Future<http.Response> addContact(
      int currentUserId, String requestedMail) async {
    final url = Uri.parse(APIRoutes.addContact);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "requestedMail": requestedMail.trim(),
        "currentUserId": currentUserId
      }),
    );

    return response;
  }

  static Future<List<Contact>> fetchTotalContacts(String userId) async {
    final response = await http.get(
      Uri.parse('${APIRoutes.getAllContacts}userId=$userId'),
    );

    if (response.statusCode == 200) {
      final contacts = json.decode(response.body)['data'] as List;
      final users = (contacts).map((data) => Contact.fromJson(data)).toList();

      return users;
    } else {
      showErrorToast();
      throw Exception('Failed to fetch users');
    }
  }

  static Future<List<Contact>> fetchChatContacts(String userId) async {
    return [];
    // final response = await http.get(
    //   Uri.parse('${APIRoutes.baseUrl}/chat_users/$userId'),
    // );
    // if (response.statusCode == 200) {
    //   final contacts = json.decode(response.body)['chatUsers'];

    //   return (contacts as List).map((data) => User.fromJson(data)).toList();
    // } else {
    //   throw Exception('Failed to fetch users');
    // }
  }

  static Future<http.Response> inviteRoom(
      String currentUserId, String contactUserId, String roomId) async {
    final response = await http.post(
      Uri.parse('${APIRoutes.baseUrl}/invite_to_room'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "inviterId": currentUserId,
        "inviteeId": contactUserId,
        "roomId": roomId
      }),
    );

    return response;
  }
}
