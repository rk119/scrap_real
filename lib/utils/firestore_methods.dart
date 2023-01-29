import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrap_real/models/scrapbook.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/utils/storage_methods.dart';
import 'package:scrap_real/views/navigation.dart';
// import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createScrapbook(
    File? image,
    String title,
    String caption,
    bool tag,
    bool type,
    bool visibility,
    List<dynamic> _collaborators,
    BuildContext context,
    bool mounted,
    // GlobalKey<FormState> formKey,
    // GlobalKey<NavigatorState> navigatorKey,
  ) async {
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
      final docScrapbook = _firestore.collection('scrapbooks').doc();
      print(_collaborators);
      String photoUrl = "";
      if (image != null) {
        photoUrl = await StorageMethods().uploadScrapbookCover(image);
      }
      final scrapbookModel = ScrapbookModel(
        creatorUid: _auth.currentUser!.uid,
        scrapbookId: docScrapbook.id,
        title: title,
        caption: caption,
        tag: tag ? "Factual" : "Personal",
        type: type ? "Normal" : "Challenge",
        visibility: visibility ? "Public" : "Private",
        collaborators: _collaborators,
        coverUrl: photoUrl,
        posts: [],
      );
      final json = scrapbookModel.toJson();
      await docScrapbook.set(json);

      // if (_collaborators.isNotEmpty) {
      // await docScrapbook.update({
      // 'collaborators': FieldValue.arrayUnion(_collaborators),
      // });
      // }

      if (!mounted) return;
      CustomSnackBar.snackBarAlert(
        context,
        "Scrapbook Created!",
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
      final regex = RegExp(r'^\[(.)\]\s(.)$');
      final match = regex.firstMatch(e.toString());
      if (!mounted) {
        return;
      }
      CustomSnackBar.showSnackBar(context, match?.group(2));
      Navigator.of(context).pop();
    }
    // navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  // Future<String> likePost(String postId, String uid, List likes) async {
  //   String res = "Some error occurred";
  //   try {
  //     if (likes.contains(uid)) {
  //       // if the likes list contains the user uid, we need to remove it
  //       _firestore.collection('posts').doc(postId).update({
  //         'likes': FieldValue.arrayRemove([uid])
  //       });
  //     } else {
  //       // else we need to add uid to the likes array
  //       _firestore.collection('posts').doc(postId).update({
  //         'likes': FieldValue.arrayUnion([uid])
  //       });
  //     }
  //     res = 'success';
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  // Future<String> postComment(String postId, String text, String uid,
  //     String name, String profilePic) async {
  //   String res = "Some error occurred";
  //   try {
  //     if (text.isNotEmpty) {
  //       // if the likes list contains the user uid, we need to remove it
  //       String commentId = const Uuid().v1();
  //       _firestore
  //           .collection('posts')
  //           .doc(postId)
  //           .collection('comments')
  //           .doc(commentId)
  //           .set({
  //         'profilePic': profilePic,
  //         'name': name,
  //         'uid': uid,
  //         'text': text,
  //         'commentId': commentId,
  //         'datePublished': DateTime.now(),
  //       });
  //       res = 'success';
  //     } else {
  //       res = "Please enter text";
  //     }
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  // Future<String> deletePost(String postId) async {
  //   String res = "Some error occurred";
  //   try {
  //     await _firestore.collection('posts').doc(postId).delete();
  //     res = 'success';
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  void setProfile(
    String uid,
    BuildContext context,
    String name,
    String bio,
    PlatformFile? pickedFile,
    String? photoUrl,
    List<bool> interests,
    bool mounted,
  ) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
    if (name.isNotEmpty) {
      docUser.update({'name': name});
    } else {
      CustomSnackBar.showSnackBar(
        context,
        "Please enter a name",
      );
      return;
    }
    if (bio.isNotEmpty) {
      docUser.update({'bio': bio});
    }
    if (pickedFile != null) {
      photoUrl = await StorageMethods().uploadProfilePic(pickedFile);
      docUser.update({'photoUrl': photoUrl});
    }

    docUser.update({'interests': interests});

    if (!mounted) {
      return;
    }
    CustomSnackBar.snackBarAlert(
      context,
      "Profile Created!",
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NavBar(),
      ),
    );
  }

  void updateProfile(
    String docId,
    String username,
    String name,
    String bio,
    PlatformFile? pickedFile,
    String? photoUrl,
    bool mounted,
    BuildContext context,
  ) async {
    try {
      final docUser = FirebaseFirestore.instance.collection('users').doc(docId);
      if (username.isNotEmpty) {
        docUser.update({'username': username});
      }
      if (name.isNotEmpty) {
        docUser.update({'name': name});
      }
      if (bio.isNotEmpty) {
        docUser.update({'bio': bio});
      }
      if (pickedFile != null) {
        photoUrl = await StorageMethods().uploadProfilePic(pickedFile);
        docUser.update({'photoUrl': photoUrl});
      }
      if (!mounted) {
        return;
      }
      CustomSnackBar.snackBarAlert(
        context,
        "Profile Updated!",
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NavBar(),
        ),
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
