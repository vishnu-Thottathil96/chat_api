import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lamie/model/login_result_model.dart';

class SignupProvider with ChangeNotifier {
  final String _endPint = 'https://backendrealchat.molla.cloud/signup/';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<LoginResult> signup({
    required String email,
    required String username,
    required String password,
    required String password2,
  }) async {
    setLoading(true);
    var url = Uri.parse(_endPint);
    try {
      var response = await http.post(
        url,
        body: {
          "email": email,
          "username": username,
          "password": password,
          "password2": password2,
          "is_google": false.toString(),
        },
      );

      var responseData = json.decode(response.body);
      int responseStatus = responseData['status'];

      switch (responseStatus) {
        case 201:
          // Successfully registered
          return LoginResult(isSuccess: true, message: responseData['Text']);
        case 404:
          // Errors related to existing user details
          String errorMessage = '';
          if (responseData['Text']['email'] != null &&
              responseData['Text']['username'] != null) {
            errorMessage = "Email And Username Already Exists";
          } else if (responseData['Text']['email'] != null) {
            errorMessage += responseData['Text']['email'][0] + ' ';
          } else if (responseData['Text']['username'] != null) {
            errorMessage += responseData['Text']['username'][0];
          }
          return LoginResult(isSuccess: false, message: errorMessage.trim());
        default:
          // Any other status
          return LoginResult(
              isSuccess: false, message: "Signup failed due to unknown error");
      }
    } catch (e) {
      return LoginResult(
          isSuccess: false,
          message: "Signup failed. Network error: ${e.toString()}");
    } finally {
      setLoading(false);
    }
  }
}
  // Future<LoginResult> signup({
  //   required String email,
  //   required String username,
  //   required String password,
  //   required String password2,
  // }) async {
  //   setLoading(true);
  //   var url = Uri.parse(_endPint);
  //   try {
  //     var response = await http.post(
  //       url,
  //       body: {
  //         "email": email,
  //         "username": username,
  //         "password": password,
  //         "password2": password2,
  //         "is_google": false.toString(),
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       return LoginResult(
  //           isSuccess: true,
  //           message:
  //               "Signup Successful. Please check your email to activate your account.");
  //     } else {
  //       var responseData = json.decode(response.body);
  //       return LoginResult(
  //           isSuccess: false,
  //           message:
  //               responseData['Text'] ?? 'Signup failed due to unknown error');
  //     }
  //   } catch (e) {
  //     return LoginResult(isSuccess: false, message: 'An error occurred: $e');
  //   } finally {
  //     setLoading(false);
  //   }
  // }
