import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/views/auth_views/set_profile.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';
import 'package:scrap_real/views/auth_views/welcome.dart';
import 'dart:async';

class SendVerificationPage extends StatefulWidget {
  const SendVerificationPage({Key? key}) : super(key: key);

  @override
  State<SendVerificationPage> createState() => _SendVerificationPageState();
}

class _SendVerificationPageState extends State<SendVerificationPage> {
  bool isEmailVerified = false;
  bool canResend = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
    }
  }

  @override
  void dispose() {
    super.dispose();

    timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResend = false);
      await Future.delayed(const Duration(seconds: 60));
      setState(() => canResend = true);
    } catch (e) {
      final regex = RegExp(r'^\[(.*)\]\s(.*)$');
      final match = regex.firstMatch(e.toString())?.group(2);
      CustomSnackBar.showSnackBar(context, match);

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const SetProfilePage()
      : Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: GestureDetector(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 50,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        CustomBackButton(
                          buttonFunction: () async {
                            await FirebaseAuth.instance.signOut();
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WelcomePage()),
                            );
                          },
                        ),
                        CustomHeader(headerText: "Verification"),
                        const SizedBox(height: 150),
                        CustomText(
                            text:
                                "A link has been sent to your email to verify your account",
                            textSize: 20),
                        const SizedBox(height: 50),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xffbc2d21),
                          ),
                          onPressed: canResend
                              ? () {
                                  sendVerificationEmail();
                                }
                              : null,
                          child: const Text('Resend',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
}
