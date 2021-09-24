import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {
  static SharedPreferences _preferences;
  static const _question = "_passwordTextEditingController";
  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();
  static Future setQuestion(String _passwordTextEditingController) async =>
      await _preferences.setString(_question, _passwordTextEditingController);

  static String getQuestion() =>
      _preferences.getString(_question);
}
