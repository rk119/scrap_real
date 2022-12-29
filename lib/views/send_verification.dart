import 'package:flutter/material.dart';

class SendVerificationPage extends StatefulWidget {
  const SendVerificationPage({Key? key}) : super(key: key);

  @override
  State<SendVerificationPage> createState() => _SendVerificationPageState();
}

class _SendVerificationPageState extends State<SendVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text('Verification Page'),
          TextButton(
            onPressed: () {},
            child: Text('Resend'),
          ),
        ],
      ),
    );
  }
}
