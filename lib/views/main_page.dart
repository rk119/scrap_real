import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scrap_real/views/navigation.dart';
import 'package:scrap_real/views/auth_views/send_verification.dart';
import 'package:scrap_real/views/auth_views/welcome.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var user = FirebaseAuth.instance.currentUser!;
            if (user.email != null && user.emailVerified) {
              return NavBar();
            }
            return const SendVerificationPage();
          } else {
            return const WelcomePage();
          }
        },
      ),
    );
  }
}
