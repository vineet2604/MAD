import 'package:shared_preferences/shared_preferences.dart';

class Prefrences {
  static late SharedPreferences _prefs;

  static Future init() async => _prefs = await SharedPreferences.getInstance();

  static Future saveHighScore(int value) async =>
      _prefs.setInt('high score', value);

  static int getHighScore() => _prefs.getInt('high score') ?? 0;
}
