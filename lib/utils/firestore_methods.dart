import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrap_real/utils/storage_methods.dart';
import 'package:scrap_real/views/navigation.dart';
// import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  void updateProfile(
    String docId,
    String username,
    String name,
    String bio,
    Uint8List? file,
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
      if (file != null) {
        photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        docUser.update({'photoUrl': photoUrl});
      }
      if (!mounted) {
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NavBar(),
        ),
      );
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
