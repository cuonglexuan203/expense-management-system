import 'package:expense_management_system/feature/schedule/model/event.dart';
import 'package:expense_management_system/shared/util/email_validator.dart';

class Validator {
  static bool isValidEmail(String? value) {
    if (value == null) {
      return false;
    }
    if (value.isEmpty) {
      return false;
    }
    if (value.length < 4) {
      return false;
    }

    return EmailValidator.validate(value);
  }

  static bool isValidPassWord(String? value) {
    if (value == null) {
      return false;
    }
    if (value.isEmpty) {
      return false;
    }
    if (value.length < 5) {
      return false;
    }
    // bool passValid = RegExp(
    //         "^(?=.{8,32}\$)(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?:{}|<>]).*")
    //     .hasMatch(value);
    //return passValid;

    return true;
  }

  static bool isEventInPast(Event event) {
    // Compare event date with current date
    // Use UTC comparison since event dates are stored in UTC
    final now = DateTime.now().toUtc();
    return event.initialTriggerDateTime.isBefore(now);
  }
}
