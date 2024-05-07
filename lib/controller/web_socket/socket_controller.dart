// import 'dart:async';
// import 'dart:convert'; // For json encoding
// import 'package:flutter/foundation.dart';
// import 'package:web_socket_channel/io.dart';

// class WebSocketClient {
//   IOWebSocketChannel? channel;
//   final _controller = StreamController<dynamic>(); // For incoming messages

//   // Constructor with dynamic URL parameters
//   WebSocketClient(String senderId, String receiverId) {
//     var url = 'wss://backendrealchat.molla.cloud/chat/$senderId/?$receiverId';
//     connect(url);
//   }

//   Stream get stream => _controller.stream;

//   void connect(String url) {
//     if (channel != null && channel!.closeCode == null) {
//       debugPrint("Already Connected");
//       return;
//     }
//     debugPrint("Connecting to $url");
//     channel = IOWebSocketChannel.connect(url);

//     channel!.stream.listen(
//       (event) {
//         debugPrint('Received: $event');
//         _controller.add(event); // Forward the event to the stream
//       },
//       onDone: () {
//         debugPrint('Connection closed');
//         _controller.close(); // Close the controller when connection is done
//       },
//       onError: (error) {
//         debugPrint('Error $error');
//         _controller.addError(error); // Add error to the stream
//       },
//     );
//   }

//   void send(String message, String senderMail, String receiverMail) {
//     if (channel == null || channel!.closeCode != null) {
//       debugPrint('Not connected');
//       return;
//     }
//     var data = json.encode({
//       "message": message,
//       "senderUsername": senderMail,
//       "recieverUsername": receiverMail,
//     });
//     debugPrint('Sending: $data');
//     channel!.sink.add(data);
//   }

//   void dispose() {
//     channel?.sink.close();
//     _controller.close();
//   }
// }
/////
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  IOWebSocketChannel? channel;
  final StreamController<dynamic> _controller =
      StreamController<dynamic>.broadcast();

  WebSocketClient(String senderId, String receiverId) {
    var url = 'wss://backendrealchat.molla.cloud/chat/$senderId/?$receiverId';
    connect(url);
  }

  Stream get stream => _controller.stream;

  void connect(String url) {
    if (channel != null && channel!.closeCode == null) {
      debugPrint("Already Connected");
      return;
    }
    debugPrint("Connecting to $url");
    channel = IOWebSocketChannel.connect(url);

    channel!.stream.listen(
      (event) {
        debugPrint('Received: $event');
        _controller.add(event); // Forward the event to the stream
      },
      onDone: () {
        debugPrint('Connection closed');
        _controller.close();
      },
      onError: (error) {
        debugPrint('Error $error');
        _controller.addError(error);
      },
    );
  }

  void send(String message, String senderMail, String receiverMail) {
    if (channel == null || channel!.closeCode != null) {
      debugPrint('Not connected');
      return;
    }
    var data = json.encode({
      "message": message,
      "senderUsername": senderMail,
      "recieverUsername": receiverMail,
    });
    debugPrint('Sending: $data');
    channel!.sink.add(data);
  }

  void dispose() {
    channel?.sink.close();
    _controller.close();
  }
}
