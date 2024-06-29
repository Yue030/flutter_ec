import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static SharedPreferences? _preferences;

  static Future<void> initSharePrefs() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static String? getJwt() {
    return _preferences!.getString("jwt");
  }

  static setJwt(String? token) {
    if (token == null) {
      _preferences!.remove("jwt");
      return;
    }
    _preferences!.setString("jwt", token);
  }
}