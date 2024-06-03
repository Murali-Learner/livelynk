class APIRoutes {
  static const baseUrl = 'https://ae40-157-10-167-49.ngrok-free.app';

  //auth Routes
  static const login = '$baseUrl/auth/login';
  static const register = '$baseUrl/auth/register';

  //contact
  static const addContact = '$baseUrl/contact/addContact/';
  static const acceptContactRequest = '$baseUrl/contact/acceptContactRequest';
  static const deleteContact = '$baseUrl/contact/deleteContact';
  static const getContacts = '$baseUrl/contact/getContacts?';
  static const getAllContacts = '$baseUrl/contact/getAllContacts?';
  static const getChatContacts = '$baseUrl/contact/getChatContacts?';

  // CHAT
  static const getChatHistory = '$baseUrl/chat/getChatHistory?';
}
