import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode_full/jwt_decode_full.dart';
import 'package:lamie/controller/tokens/token_manager.dart';
import 'dart:convert';
import 'package:lamie/model/user_connections.dart';

class ChatListProvider with ChangeNotifier {
  String getConnectionsUrl =
      'https://backendrealchat.molla.cloud/chat/connections/';
  String searchUserUrl =
      'https://backendrealchat.molla.cloud/chat/search/?search=';
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchUserChats() async {
    _setLoading(true);
    _setErrorMessage(null);
    String? accessToken = await TokenManager.getAccessToken();
    final jwtData = jwtDecode(accessToken ?? '');
    log('payload: ${jwtData.payload}');
    int userId = jwtData.payload['user_id'];

    log(userId.toString());

    if (accessToken == null) {
      _setErrorMessage("No access token found, please log in.");
      _setLoading(false);
      return;
    }

    final url = Uri.parse('$getConnectionsUrl$userId/');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _user = UserModel.fromJson(data);
      } else if (response.statusCode == 401) {
        _setErrorMessage("Session expired. Please log in again.");
      } else {
        _setErrorMessage(
            "Failed to load chats. Status Code: ${response.statusCode}. Please try again later.");
      }
    } catch (e) {
      _setErrorMessage("Error fetching chats: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<void> searchUserChats(String query) async {
    if (query.isEmpty) {
      _setErrorMessage("Search query cannot be empty.");
      return;
    }
    _setLoading(true);
    _setErrorMessage(null);
    String? accessToken = await TokenManager.getAccessToken();

    if (accessToken == null) {
      _setErrorMessage("No access token found, please log in.");
      _setLoading(false);
      return;
    }

    final url = Uri.parse('$searchUserUrl$query');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        UsersList usersList = UsersList.fromJson(data);
        _user = UserModel(
            id: _user!.id,
            username: _user!.username,
            email: _user!.email,
            phoneNumber: _user!.phoneNumber,
            isGoogle: _user!.isGoogle,
            connections: usersList.users
                .map((u) => Connection(
                      id: u.id,
                      username: u.username,
                      email: u.email,
                      profileImage: u.profileImage,
                      profileCoverImage: u.profileCoverImage,
                      phoneNumber: u.phoneNumber,
                      isGoogle: u.isGoogle,
                    ))
                .toList());
        notifyListeners();
      } else {
        _setErrorMessage(
            "Failed to search. Status Code: ${response.statusCode}. Please try again later.");
      }
    } catch (e) {
      _setErrorMessage("Error searching chats: $e");
    } finally {
      _setLoading(false);
    }
  }

  void clearData() {
    _user = null;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}




// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:lamie/controller/tokens/token_manager.dart';
// import 'package:lamie/model/user_connections.dart';
// import 'dart:convert';

// class ChatListProvider with ChangeNotifier {
//   User? _user;
//   bool _isLoading = false;
//   String? _errorMessage;

//   User? get user => _user;
//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   void setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void setErrorMessage(String? message) {
//     _errorMessage = message;
//     notifyListeners();
//   }

//   Future<void> fetchUserChats(int userId) async {
//     setLoading(true);
//     setErrorMessage(null);
//     String? accessToken = await TokenManager.getAccessToken();

//     if (accessToken == null) {
//       setErrorMessage("No access token found, please log in.");
//       setLoading(false);
//       return;
//     }

//     const String baseUrl =
//         'https://backendrealchat.molla.cloud/chat/connections/';
//     final url = Uri.parse('$baseUrl$userId/');
//     try {
//       final response = await http.get(
//         url,
//         headers: {
//           'Authorization': 'Bearer $accessToken',
//           'Content-Type': 'application/json',
//         },
//       );
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         _user = User.fromJson(data);
//       } else if (response.statusCode == 401) {
//         setErrorMessage("Session expired. Please log in again.");
//       } else {
//         setErrorMessage("Failed to load chats. Please try again later.");
//       }
//     } catch (e) {
//       setErrorMessage("Error fetching chats: $e");
//     }
//     setLoading(false);
//   }
// }
