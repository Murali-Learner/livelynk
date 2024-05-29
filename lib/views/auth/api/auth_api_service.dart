import 'package:livelynk/services/http_service.dart';
import 'package:livelynk/services/api_routes.dart';

class AuthApiService {
  static Future<Set> register(
      String username, String email, String password) async {
    return await HttpService.send(
      'POST',
      APIRoutes.register,
      {
        'username': username,
        'email': email,
        'password': password,
      },
    );
  }

  static Future<Set> login(String email, String password) async {
    return await HttpService.send(
      'POST',
      APIRoutes.login,
      {
        'email': email,
        'password': password,
      },
    );
  }
}
