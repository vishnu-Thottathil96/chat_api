import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamie/controller/tokens/token_manager.dart';
import 'dart:convert';
import 'package:lamie/model/login_result_model.dart';

class LoginProvider with ChangeNotifier {
  String endPoint = 'https://backendrealchat.molla.cloud/token/';
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<LoginResult> login(
      {required String email, required String password}) async {
    setLoading(true);
    var url = Uri.parse(endPoint);
    try {
      var response = await http.post(url, body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        await TokenManager.storeTokens(
            refreshToken: responseData['refresh'],
            accessToken: responseData['access']);
        return LoginResult(isSuccess: true, message: "Login Successful");
      } else {
        var responseData = json.decode(response.body);
        return LoginResult(
            isSuccess: false,
            message:
                'Failed to login: ${responseData['detail'] ?? 'Unknown error'}');
      }
    } catch (e) {
      log(e.toString());
      return LoginResult(isSuccess: false, message: 'An error occurred: $e');
    } finally {
      setLoading(false);
    }
  }
}


// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:lamie/model/login_result_model.dart';

// class LoginProvider with ChangeNotifier {
//   String endPoint = 'https://backendrealchat.molla.cloud/token/';
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   void setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   Future<LoginResult> login(
//       {required String email, required String password}) async {
//     setLoading(true);
//     var url = Uri.parse(endPoint);
//     try {
//       var response = await http.post(url, body: {
//         'email': email,
//         'password': password,
//       });

//       if (response.statusCode == 200) {
//         return LoginResult(isSuccess: true, message: "Login Successful");
//       } else {
//         var responseData = json.decode(response.body);
//         return LoginResult(
//             isSuccess: false,
//             message:
//                 'Failed to login: ${responseData['detail'] ?? 'Unknown error'}');
//       }
//     } catch (e) {
//       return LoginResult(isSuccess: false, message: 'An error occurred: $e');
//     } finally {
//       setLoading(false);
//     }
//   }
// }
