import 'dart:async';
import 'dart:convert';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/card_widgets/custom_chatmessage.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_subheader.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../widgets/profile_widgets/threedots.dart';

class ChatGPTPage extends StatefulWidget {
  final String? uid;
  const ChatGPTPage({Key? key, this.uid}) : super(key: key);

  @override
  State<ChatGPTPage> createState() => _ChatGPTPageState();
}

class _ChatGPTPageState extends State<ChatGPTPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> messages = [];
  late OpenAI? chatGPT;
  ChatCTResponse? mResponse;
  var userData = {};
  bool isTyping = false;
  bool isLoading = true;

  @override
  void initState() {
    chatGPT = OpenAI.instance.build(
        token: "Your Token",
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 8)),
        isLog: true);
    getData();
    setState(() {
      isLoading = false;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getData() async {
    final userSnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.uid)
        .get();

    setState(() {
      userData = userSnap.data()!;
      isLoading = false;
    });
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
      profileImg: userData["photoUrl"],
    );

    setState(() {
      messages.insert(0, message);
      isTyping = true;
    });

    _controller.clear();
    _chatGpt3();
  }

  void _chatGpt3() async {
    try {
      final request = ChatCompleteText(messages: [
        Map.of({"role": "user", "content": messages[0].text}),
      ], maxToken: 400, model: kChatGptTurbo0301Model);

      final raw = await chatGPT!.onChatCompletion(request: request);

      setState(() {
        mResponse = raw;
        print("${mResponse?.toJson()}");
        insertNewData(
            mResponse?.toJson()["choices"][0]["message"]["content"].toString());
      });
    } catch (e) {
      setState(() {
        isTyping = false;
      });
      print(e);
    }
  }

  void insertNewData(String? response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(
      text: response.toString(),
      sender: "bot",
      profileImg: "assets/images/openAi.jpg",
    );

    setState(() {
      isTyping = false;
      messages.insert(0, botMessage);
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration:
                const InputDecoration.collapsed(hintText: "Send a message"),
            cursorColor: const Color(0xff918ef4),
          ),
        ),
        ButtonBar(
          children: [
            IconButton(
              icon: const Icon(Icons.send, color: Color(0xff918ef4)),
              onPressed: () {
                _sendMessage();
              },
            ),
          ],
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              toolbarHeight: 90,
              leadingWidth: 60,
              title: CustomHeader(headerText: "Chat"),
              centerTitle: true,
              elevation: 0.0,
              backgroundColor: context.cardColor,
              leading: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: CustomBackButton(
                  buttonFunction: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Flexible(
                      child: ListView.builder(
                    reverse: true,
                    padding: Vx.m8,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return messages[index];
                    },
                  )),
                  if (isTyping) const ThreeDots(),
                  const Divider(
                    height: 1.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: context.cardColor,
                    ),
                    child: _buildTextComposer(),
                  )
                ],
              ),
            ));
  }
}
