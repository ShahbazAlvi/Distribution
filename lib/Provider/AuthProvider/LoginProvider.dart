import 'dart:convert';

import 'package:distribution/ApiLink/ApiEndpoint.dart';
import 'package:distribution/Screen/DashBoardScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;

import 'package:shared_preferences/shared_preferences.dart';



class LoginProvider with ChangeNotifier{

  bool isLoading = false;
  String message="";


//gets
  bool get _isLoading=>isLoading;
  String get _message=>message;
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  Future<void>login(BuildContext context)async{
    final email= emailController.text.trim();
    final password=passwordController.text.trim();
    if(email.isEmpty||password.isEmpty) {
      message = "Please enter email and password";
      notifyListeners();
      return;
    }
    isLoading= true;
    message="";
    notifyListeners();

    try{
      final response=await http.post(Uri.parse('${ApiEndpoints.baseUrl}/auth/login'),
          headers: {"Content-Type": "application/json"},

          body: jsonEncode({
            'email':email,
            'password':password
          }));
      final data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200 && data["token"] != null) {
        message = "Login successful!";
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('token', data["token"]);
        await prefs.setString('username', data['user']['username'] ?? '');
        await prefs.setString('user', jsonEncode(data["user"]));

        // ✅ Optional: Only save role if it exists
        if (data['user']['role'] != null) {
          await prefs.setString('role', data['user']['role']);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Dashboardscreen()),
        );
      }

      else{
        message = data["message"] ?? "Invalid credentials";
      }

    }catch(e){
      print(e);
      message = "Something went wrong: $e";

    }
    isLoading=false;
    notifyListeners();



  }
}