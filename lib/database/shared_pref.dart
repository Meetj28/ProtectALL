
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreference{
  static SharedPreferences? _preferences;
  static const String mkey = 'userType';
  static init() async{
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  static Future saveUserType(String type)async {
    return await _preferences!.setString(mkey, type);
  }

  static Future<String>? getUserType() async=>await _preferences!.getString(mkey) ?? "";
}