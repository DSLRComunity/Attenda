import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper{
  static late SharedPreferences sharedPref;

  static Future init()async{
    sharedPref=await SharedPreferences.getInstance();
  }

  static Future putData({required String key,required dynamic value})async{
    if(value is bool )  return await sharedPref.setBool(key, value);
    if(value is int )    return await sharedPref.setInt(key, value);
    if(value is String )    return await sharedPref.setString(key, value);
    return await sharedPref.setDouble(key, value);
  }

  static dynamic getData({required key}){
   return  sharedPref.get(key);
  }

  static Future  clearCache()async {
   await sharedPref.clear();
  }
  static Future removeValue({required String key})async{
   return await sharedPref.remove(key);
  }


}
