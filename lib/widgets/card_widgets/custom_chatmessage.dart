import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      required this.profileImg});

  final String text;
  final String sender;
  final String profileImg;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sender == "user")
          CircleAvatar(
            backgroundImage: NetworkImage(profileImg),
          ).pOnly(right: 10)
        else
          Container(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (sender == "user")
                "You".text.make()
              else
                "Chatbot".text.make(),
              5.heightBox,
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: sender == "user" ? Colors.blue[100] : Colors.blue[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: text.text.make(),
              ),
            ],
          ),
        ),
        if (sender == "bot")
          CircleAvatar(
            backgroundImage: AssetImage(profileImg),
          ).pOnly(left: 10)
        else
          Container(),
      ],
    ).py8();
  }
}
