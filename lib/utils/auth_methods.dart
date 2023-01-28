import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrap_real/models/user_class.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/views/auth_views/send_verification.dart';
import 'package:scrap_real/views/navigation.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future registerUser(
    String username,
    String email,
    String password,
    BuildContext context,
    bool mounted,
    GlobalKey<FormState> formKey,
    GlobalKey<NavigatorState> navigatorKey,
  ) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    // username exists
    final docUser = _firestore
        .collection('users')
        .where('username', isEqualTo: username.trim());
    final docUserSnapshot = await docUser.get();
    if (docUserSnapshot.docs.isNotEmpty) {
      if (!mounted) {
        return;
      }
      CustomSnackBar.showSnackBar(context, "Username already exists");
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          color: Color(0xff918ef4),
        ),
      ),
    );

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      final uid = _auth.currentUser!.uid;
      final docUser = _firestore.collection('users').doc(uid);

      final userModel = UserModel(
        uid: docUser.id,
        email: email.trim(),
        username: username.trim(),
        name: "",
        bio: "",
        photoUrl: "",
        followers: [],
        following: [],
        savedPosts: [],
        blockedUsers: [],
        reportUsers: [],
        reportPosts: [],
      );
      final json = userModel.toJson();
      await docUser.set(json);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SendVerificationPage()),
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
      final regex = RegExp(r'^\[(.*)\]\s(.*)$');
      final match = regex.firstMatch(e.toString())?.group(2);
      if (!mounted) {
        return;
      }
      CustomSnackBar.showSnackBar(context, match);
      Navigator.of(context).pop();
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future loginUser(
    String email,
    String password,
    BuildContext context,
    bool mounted,
    GlobalKey<FormState> formKey,
  ) async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
      );
    } catch (e) {
      final regex = RegExp(r'^\[(.*)\]\s(.*)$');
      final match = regex.firstMatch(e.toString())?.group(2);
      CustomSnackBar.showSnackBar(context, match);
    }
  }
}
