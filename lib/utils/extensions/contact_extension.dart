import 'package:livelynk/utils/enums/contact_status_enum.dart';

extension ContactStatusExtension on ContactStatus {
  static ContactStatus fromString(String status) {
    switch (status.toUpperCase()) {
      case 'INVITED':
        return ContactStatus.INVITED;
      case 'ACCEPTED':
        return ContactStatus.ACCEPTED;
      case 'NONE':
      default:
        return ContactStatus.NONE;
    }
  }

  String toShortString() {
    return toString().split('.').last;
  }
}
