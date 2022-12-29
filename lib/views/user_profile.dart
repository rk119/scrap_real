import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
        child: const Text('Logout'),
      ),
    );
  }
}
