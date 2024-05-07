import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lamie/controller/tokens/token_manager.dart';
import 'package:lamie/model/login_result_model.dart';

class GoogleLoginProvider with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<LoginResult> signInWithGoogle() async {
    setLoading(true);
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setLoading(false);
        return LoginResult(
            isSuccess: false, message: "Google Sign-In aborted by user.");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      var url = Uri.parse('https://backendrealchat.molla.cloud/google_login/');
      var response = await http.post(url, body: {
        'email': googleUser.email,
        'access_token': googleAuth.accessToken!,
      });

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 200) {
          await TokenManager.storeTokens(
              refreshToken: responseData['token']['refresh'],
              accessToken: responseData['token']['access']);
          return LoginResult(
              isSuccess: true, message: "Your Login successfully!");
        } else {
          return LoginResult(
              isSuccess: false, message: responseData['message']);
        }
      } else {
        return LoginResult(
            isSuccess: false,
            message: 'Server error with status code: ${response.statusCode}');
      }
    } catch (e) {
      return LoginResult(
          isSuccess: false,
          message: 'An error occurred during Google Sign-In: $e');
    } finally {
      setLoading(false);
    }
  }
}

///
class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();
  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
}
