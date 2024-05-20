import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:whatsapp_chat_clone/models/user_model.dart';

class HttpService {
  static const String baseUrl = 'http://192.168.24.159:3000';

  Future<http.Response> register(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: json
          .encode({'username': username, 'email': email, 'password': password}),
    );

    return response;
  }

  Future<http.Response> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    return response;
  }

  Future<http.Response> addContact(
      String currentUserId, String contactId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_contact/$currentUserId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"contactUserId": contactId}),
    );

    return response;
  }

  Future<http.Response> deleteContact(
      String currentUserId, String contactUserId) async {
    final url =
        Uri.parse('$baseUrl/delete_contact/$currentUserId/$contactUserId');

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    return response;
  }

  Future<List<User>> fetchTotalContacts(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/all_contacts/$userId'),
    );

    if (response.statusCode == 200) {
      final contacts = json.decode(response.body)['contacts'];

      return (contacts as List).map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<List<User>> fetchMyUsers(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user_contacts/$userId'),
    );

    if (response.statusCode == 200) {
      final contacts = json.decode(response.body)['contacts'];

      return (contacts as List).map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<List<User>> fetchChatContacts(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chat_users/$userId'),
    );
    if (response.statusCode == 200) {
      final contacts = json.decode(response.body)['chatUsers'];

      return (contacts as List).map((data) => User.fromJson(data)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }
}
