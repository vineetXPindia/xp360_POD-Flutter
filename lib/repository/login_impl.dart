import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/Api_Constants.dart';

class LoginImpl{
  Future<bool> requestOtp(String? phoneNumber) async{
    bool result = false;
    try{
      final response = await http.get(Uri.parse(ApiConstants.send_otp_for_login).replace(queryParameters: {"phoneNumber" : phoneNumber}));
      final jsonData = jsonDecode(response.body);
      if(response.statusCode == 200 && jsonData['Success'] == true){
        Fluttertoast.showToast(msg: jsonData['Message'], backgroundColor: Colors.green.shade700, textColor: Colors.white);
        result = true;
      }
      else{
        Fluttertoast.showToast(msg: 'Unable to send OTP', backgroundColor: Colors.red.shade800, textColor: Colors.white);
      }
      return result;
    }
    catch(e){
      throw Exception(e);
    }
  }

  Future<bool> validateOtp(String? phoneNumber, String? otp) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = false;
    final body = jsonEncode({
      "phoneNumber": "",
      "otp" : ""
    });
    try{
      final response = await http.post(Uri.parse(ApiConstants.validate_otp).replace(queryParameters: {"phoneNumber" : phoneNumber, "otp" : otp}), body: body);
      final jsonData = jsonDecode(response.body);
      if(response.statusCode == 200 && jsonData['Success'] == true){
        prefs.setBool('loggedIn', true);
        result = true;
        Fluttertoast.showToast(msg: jsonData['Message'], backgroundColor: Colors.green.shade700, textColor: Colors.white);
      }
      else if(response.statusCode == 200 && jsonData['Success'] == false){
        prefs.setBool('loggedIn', false);
        Fluttertoast.showToast(msg: jsonData['Message'], backgroundColor: Colors.red.shade800, textColor: Colors.white);
      }
      else{
        Fluttertoast.showToast(msg: 'Unknown Error Occurred', backgroundColor: Colors.grey.shade800, textColor: Colors.white);
      }
      return result;
    }
    catch(e){
      throw Exception(e);
    }
  }
}