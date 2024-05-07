class ChatMessage {
  final int id;
  final String senderEmail;
  final String message;
  final String threadName;
  final DateTime timestamp;
  final bool senderDelete;
  final bool receiverDelete;
  final int sender;
  final int receiver;

  ChatMessage({
    required this.id,
    required this.senderEmail,
    required this.message,
    required this.threadName,
    required this.timestamp,
    required this.senderDelete,
    required this.receiverDelete,
    required this.sender,
    required this.receiver,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      senderEmail: json['sender_email'],
      message: json['message'],
      threadName: json['thread_name'],
      timestamp: DateTime.parse(json['timestamp']),
      senderDelete: json['sender_delete'],
      receiverDelete: json['receiver_delete'],
      sender: json['sender'],
      receiver: json['receiver'],
    );
  }
}
