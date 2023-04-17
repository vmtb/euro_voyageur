import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HelperPreferences {

   static getSharedPreferences () async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs;
  }

  static saveStringValue (String parameterName, String value) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(parameterName, value);
  }

  static saveIntValue (String parameterName, int value) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt( parameterName, value);
  }

   static saveDoubleValue (String parameterName, double value) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(parameterName, value);
  }

   static saveBoolValue (String parameterName, bool value) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool( parameterName, value);
  }

   static saveStringListValue (String parameterName, List<String> value) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList( parameterName, value);
  }

   static retrieveStringValue (String parameterName) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? value = prefs.getString(parameterName);
    return value;
  }

   static saveDynamicValue (String parameterName, dynamic value) async
   {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.setString( parameterName, jsonEncode(value));
   }

   static retrieveDynamicValue (String parameterName) async
   {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String? value = prefs.getString(parameterName);
     return value;
   }

   static retrieveIntValue (String parameterName) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? value = prefs.getInt(parameterName);
    return value;
  }

   static retrieveDoubleValue (String parameterName) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? value = prefs.getDouble(parameterName);
    return value;
  }

   static retrieveBooleanValue (String parameterName) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool(parameterName);
    return value;
  }

   static retrieveStringListValue (String parameterName) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? foodList = prefs.getStringList(parameterName);
    return foodList;
  }

   static deleteValue (String parameterName) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(parameterName);
  }
   static clear () async
   {
     SharedPreferences prefs = await SharedPreferences.getInstance();
     prefs.clear();
   }

   static Future<bool> checkKey (String parameterName) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasKey = prefs.containsKey(parameterName);
    return hasKey;
  }



}