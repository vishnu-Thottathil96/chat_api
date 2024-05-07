import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lamie/constants/colors.dart';
import 'package:lamie/constants/custom_text.dart';
import 'package:lamie/constants/enumes.dart';
import 'package:lamie/view/pages/chat/chat_ui.dart';

class CustomChatTile extends StatelessWidget {
  final double height;
  final double width;
  final String userName;
  final Color backgroundColor;
  final Color textColor;
  final int senderId;
  final int? receiverId;
  final String senderEmail;
  final String receiverEmail;

  const CustomChatTile({
    Key? key,
    required this.height,
    required this.width,
    required this.userName,
    required this.senderId,
    required this.receiverId,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    required this.senderEmail,
    required this.receiverEmail,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log(senderId.toString());
        log(receiverId.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                senderId: senderId,
                receiverId: receiverId ?? 0,
                receiverMail: receiverEmail,
                senderMail: senderEmail,
              ),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 50),
          color: backgroundColor,
        ),
        width: width,
        padding: EdgeInsets.symmetric(vertical: height / 100),
        child: Row(
          children: [
            SizedBox(width: width / 30),
            CircleAvatar(
              radius: height / 20,
              backgroundColor: ProjectColors.blackColor,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    userName[0],
                    style: TextStyle(
                      color: ProjectColors.whiteColor,
                      fontSize: height / 30,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: width / 20),
            Expanded(
              child: CustomText.createCustomText(
                context: context,
                text: userName,
                textType: TextType.subheading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
