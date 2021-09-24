import 'package:email_validator/email_validator.dart';

class Validator {
  static password(String password) {
    // Pattern pattern = r'^(?=.*[0-9]+.*)(?=.*[a-zA-Z]+.*)[0-9a-zA-Z]{6,}$';
    Pattern pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
    RegExp regex = new RegExp(pattern);

    if (password.isEmpty) {
      return "Password is Required";
    } else if (password.length < 6) {
      return "Password length must be minimum of 6 characters";
    } else if (!regex.hasMatch(password)) {
      return "Password must at least have one uppercase letter, one lowercase letter and one number with a minimum length of 6!";
    }
    return null;
  }

  static username(String username, String label) {
    Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(username))
      return label;
    else
      return null;
  }

  static email(String email) {
    return EmailValidator.validate(email) ? null : "Invalid email address";
  }

  static phone(String value, String s) {
    return null;
  }

  static required(String value, int minLength, String s) {
    return value.isEmpty || value == null
        ? s
        : value.length > minLength
            ? null
            : 'length must be more than $minLength';
  }
}
