// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:lamie/controller/tokens/token_manager.dart';
// import 'package:lamie/model/message_model.dart';
// import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/web_socket_channel.dart';

// class ChatProvider with ChangeNotifier {
//   List<ChatMessage> _messages = [];
//   bool _isLoading = false;

//   List<ChatMessage> get messages => _messages;
//   bool get isLoading => _isLoading;

//   Future<void> fetchChats(int sender, int receiver) async {
//     _isLoading = true;
//     notifyListeners();
//     final url =
//         'https://backendrealchat.molla.cloud/chat/user-previous-chats/$sender/$receiver/';
//     String? token = await TokenManager.getAccessToken();

//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'Authorization': 'Bearer $token',
//         },
//       );
//       if (response.statusCode == 200) {
//         List<dynamic> chatData = json.decode(response.body);
//         _messages = chatData.map((data) => ChatMessage.fromJson(data)).toList();
//       } else {
//         print('Failed to load chats: ${response.statusCode} ${response.body}');
//         throw Exception('Failed to load chats');
//       }
//     } catch (e) {
//       print('Error fetching chats: $e');
//       throw Exception('Error fetching chats');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
// }
////
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lamie/controller/web_socket/socket_controller.dart';
import 'package:lamie/model/message_model.dart';
import 'package:lamie/controller/tokens/token_manager.dart';

class ChatProvider with ChangeNotifier {
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  WebSocketClient? _client;
  final StreamController<List<ChatMessage>> _messagesController =
      StreamController.broadcast();

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  // Stream to be used by StreamBuilder
  Stream<List<ChatMessage>> get messagesStream => _messagesController.stream;

  void connectToWebSocket(String senderId, String receiverId) {
    _client = WebSocketClient(senderId, receiverId);
    _client!.stream.listen((data) {
      var jsonData = json.decode(data);
      _messages.add(ChatMessage.fromJson(jsonData));
      _messagesController.add(_messages); // Broadcast the updated list
      notifyListeners();
    });
  }

  Future<void> fetchChats(int sender, int receiver) async {
    _isLoading = true;
    notifyListeners();
    final url =
        'https://backendrealchat.molla.cloud/chat/user-previous-chats/$sender/$receiver/';
    String? token = await TokenManager.getAccessToken();

    try {
      final response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        List<dynamic> chatData = json.decode(response.body);
        _messages = chatData.map((data) => ChatMessage.fromJson(data)).toList();
        _messagesController.add(_messages); // Broadcast the loaded list
        notifyListeners();
      } else {
        throw Exception('Failed to load chats');
      }
    } catch (e) {
      throw Exception('Error fetching chats');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void sendMessage(String message, String senderMail, String receiverMail) {
    _client?.send(message, senderMail, receiverMail);
  }

  void disposeClient() {
    _client?.dispose();
  }

  @override
  void dispose() {
    _client?.dispose();
    _messagesController.close();
    super.dispose();
  }
}
