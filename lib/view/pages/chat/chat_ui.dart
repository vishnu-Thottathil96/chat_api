// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:lamie/controller/web_socket/socket_controller.dart';
// import 'package:lamie/model/message_model.dart';
// import 'package:lamie/providers/chat_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// class ChatPage extends StatefulWidget {
//   final int senderId;
//   final int receiverId;
//   final String senderMail;
//   final String receiverMail;

//   const ChatPage(
//       {Key? key,
//       required this.senderId,
//       required this.receiverId,
//       required this.senderMail,
//       required this.receiverMail})
//       : super(key: key);

//   @override
//   _ChatPageState createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   late TextEditingController _messageController;
//   WebSocketClient? client;

//   @override
//   void initState() {
//     super.initState();

//     _messageController = TextEditingController();
//     final provider = Provider.of<ChatProvider>(context, listen: false);
//     provider.fetchChats(widget.senderId, widget.receiverId);
//     // provider.connectToWebSocket(widget.senderId, widget.receiverId);
//     client = WebSocketClient(
//         widget.senderId.toString(), widget.receiverId.toString());
//   }

//   @override
//   void dispose() {
//     _messageController.dispose();
//     client?.dispose();
//     // Provider.of<ChatProvider>(context, listen: false).closeConnection();
//     super.dispose();
//   }

//   void sendMessage() {
//     if (_messageController.text.isNotEmpty) {
//       client?.send(
//         _messageController.text,
//         widget.senderMail,
//         widget.receiverMail,
//       );
//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var provider = Provider.of<ChatProvider>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.receiverMail),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: provider.isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : ListView.builder(
//                     //reverse: true,
//                     itemCount: provider.messages.length,
//                     itemBuilder: (context, index) {
//                       return MessageTile(
//                           message: provider.messages[index],
//                           isMine: provider.messages[index].sender ==
//                               widget.senderId);
//                     },
//                   ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: "Type a message",
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     if (_messageController.text.isNotEmpty) {
//                       sendMessage();
//                     }
//                     log(widget.senderMail);
//                     log(widget.receiverMail);
//                     log(widget.senderId.toString());
//                     log(widget.receiverId.toString());
//                     // _messageController.clear();
//                   },
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ////////
// class MessageTile extends StatelessWidget {
//   final ChatMessage message;
//   final bool isMine;

//   const MessageTile({Key? key, required this.message, required this.isMine})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
//       margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//       child: Column(
//         crossAxisAlignment:
//             isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: [
//           Material(
//             borderRadius: BorderRadius.circular(10),
//             color: isMine ? Colors.blue : Colors.grey[300],
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               child: Text(
//                 message.message,
//                 style: TextStyle(color: isMine ? Colors.white : Colors.black),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 5),
//             child: Text(
//               DateFormat('yyyy-MM-dd - kk:mm').format(message.timestamp),
//               style: const TextStyle(fontSize: 10, color: Colors.grey),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//////
import 'package:flutter/material.dart';
import 'package:lamie/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import 'package:lamie/model/message_model.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final int senderId;
  final int receiverId;
  final String senderMail;
  final String receiverMail;

  const ChatPage({
    Key? key,
    required this.senderId,
    required this.receiverId,
    required this.senderMail,
    required this.receiverMail,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController _messageController;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController();
    Provider.of<ChatProvider>(context, listen: false)
        .fetchChats(widget.senderId, widget.receiverId);
    Provider.of<ChatProvider>(context, listen: false).connectToWebSocket(
        widget.senderId.toString(), widget.receiverId.toString());
  }

  @override
  void dispose() {
    _messageController.dispose();
    Provider.of<ChatProvider>(context, listen: false).disposeClient();
    super.dispose();
  }

  void sendMessage() {
    if (_messageController.text.isNotEmpty) {
      Provider.of<ChatProvider>(context, listen: false).sendMessage(
        _messageController.text,
        widget.senderMail,
        widget.receiverMail,
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverMail),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: provider.messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return MessageTile(
                        message: snapshot.data![index],
                        isMine: snapshot.data![index].sender == widget.senderId,
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final ChatMessage message;
  final bool isMine;

  const MessageTile({Key? key, required this.message, required this.isMine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: BorderRadius.circular(10),
            color: isMine ? Colors.blue : Colors.grey[300],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                message.message,
                style: TextStyle(color: isMine ? Colors.white : Colors.black),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              DateFormat('yyyy-MM-dd - kk:mm').format(message.timestamp),
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
