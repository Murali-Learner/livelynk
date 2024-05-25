class APIRoutes {
  static const baseUrl = 'https://51d1-103-149-59-162.ngrok-free.app';

  //auth Routes
  static const login = '$baseUrl/auth/login';
  static const register = '$baseUrl/auth/register';

  //contact
  static const addContact = '$baseUrl/contact/addContact/';
  static const acceptContactRequest = '$baseUrl/contact/acceptContactRequest';
  static const deleteContact = '$baseUrl/contact/deleteContact';
  static const getContacts = '$baseUrl/contact/getContacts?';
  static const getAllContacts = '$baseUrl/contact/getAllContacts?';
}
