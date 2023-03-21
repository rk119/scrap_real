import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrap_real/models/comment.dart';
import 'package:scrap_real/models/notification.dart';
import 'package:scrap_real/models/reported_scrapbooks.dart';
import 'package:scrap_real/models/reported_users.dart';
import 'package:scrap_real/models/scrapbook.dart';
import 'package:scrap_real/utils/custom_snackbar.dart';
import 'package:scrap_real/utils/storage_methods.dart';
import 'package:scrap_real/views/navigation.dart';

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
    List<dynamic> likes,
    Map<dynamic, dynamic> collaborators,
    List<dynamic> posts,
    bool group,
    int interestIndex,
    String riddle,
    String answer,
    double latitude,
    double longitude,
    double altitude,
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
      // ignore: avoid_print
      print(collaborators);
      String photoUrl = "";
      if (image != null) {
        photoUrl = await StorageMethods().uploadScrapbookCover(image);
      }

      List<String> postsUrls = [];
      for (var i = 0; i < posts.length; i++) {
        if (posts[i] != null) {
          postsUrls.add(
              await StorageMethods().uploadPost(posts[i], docScrapbook.id));
        } else {
          postsUrls.add("");
        }
      }
      final scrapbookModel = ScrapbookModel(
        creatorUid: _auth.currentUser!.uid,
        scrapbookId: docScrapbook.id,
        title: title,
        caption: caption,
        tag: tag ? "Factual" : "Personal",
        type: type ? "Normal" : "Secret",
        visibility: visibility ? "Public" : "Private",
        collaborators: collaborators,
        likes: likes,
        coverUrl: photoUrl,
        posts: postsUrls,
        group: group,
        interestIndex: interestIndex,
        riddle: riddle,
        answer: answer,
        latitude: latitude,
        longitude: longitude,
        altitude: altitude,
      );
      final json = scrapbookModel.toJson();
      await docScrapbook.set(json);

      // if (collaborators.isNotEmpty) {
      // await docScrapbook.update({
      // 'collaborators': FieldValue.arrayUnion(collaborators),
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

  Future<String> likeScrapbook(
    String scrapbookId,
    String uid,
    BuildContext context,
    bool mounted,
  ) async {
    String res = "Some error occurred";
    try {
      DocumentSnapshot snap =
          await _firestore.collection('scrapbooks').doc(scrapbookId).get();
      List likes = (snap.data()! as dynamic)['likes'];

      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('scrapbooks').doc(scrapbookId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
        // ignore: use_build_context_synchronously
        removeNotification((snap.data()! as dynamic)['creatorUid'], scrapbookId,
            _auth.currentUser!.uid, 'like', context, mounted);
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('scrapbooks').doc(scrapbookId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
        // ignore: use_build_context_synchronously
        createNotification((snap.data()! as dynamic)['creatorUid'], scrapbookId,
            (snap.data()! as dynamic)['coverUrl'], 'like', context, mounted);
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

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

  Future<void> followUser(
    String uid,
    String followId,
    BuildContext context,
    bool mounted,
  ) async {
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
        // ignore: use_build_context_synchronously
        removeNotification(
          followId,
          '',
          _auth.currentUser!.uid,
          'follow',
          context,
          mounted,
        );
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
        // ignore: use_build_context_synchronously
        createNotification(followId, '', '', 'follow', context, mounted);
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
    String oldUsername,
    bool mounted,
    BuildContext context,
  ) async {
    try {
      final docUser = FirebaseFirestore.instance.collection('users').doc(docId);
      if (username.isNotEmpty && username != oldUsername) {
        final user = _firestore
            .collection('users')
            .where('username', isEqualTo: username.trim());
        final docUserSnapshot = await user.get();
        if (docUserSnapshot.docs.isNotEmpty) {
          if (!mounted) {
            return;
          }
          CustomSnackBar.showSnackBar(context, "Username already exists");
          return;
        }
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

  Future<String> getCurrentUserPfp() async {
    String res = "Some error occurred";
    try {
      DocumentSnapshot snap = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      res = (snap.data()! as dynamic)['photoUrl'];
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future createComment(
    String comment,
    String scrapbookId,
    BuildContext context,
    bool mounted,
  ) async {
    try {
      int commentNum = 0;
      DocumentSnapshot snapUser = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();
      DocumentSnapshot snapPost =
          await _firestore.collection('scrapbooks').doc(scrapbookId).get();

      CollectionReference collectionReference = _firestore
          .collection('comment')
          .doc(scrapbookId)
          .collection('comments');

      final docComment = collectionReference.doc();

      collectionReference.get().then((QuerySnapshot snapshot) async {
        commentNum = snapshot.size;
        final commentModel = CommentModel(
          creatorUid: _auth.currentUser!.uid,
          commentId: docComment.id,
          uid: (snapUser.data()! as dynamic)['uid'],
          comment: comment,
          commentNum: commentNum + 1,
        );
        final json = commentModel.toJson();
        await docComment.set(json);

        if (!mounted) return;
      });
      // ignore: use_build_context_synchronously
      createNotification(
          (snapPost.data()! as dynamic)['creatorUid'],
          scrapbookId,
          (snapPost.data()! as dynamic)['coverUrl'],
          'comment',
          context,
          mounted);
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
  }

  void saveScrapbook(String scrapbookId, BuildContext context) async {
    if (await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) => value.data()!['savedPosts'].contains(scrapbookId))) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({
        'savedPosts': FieldValue.arrayRemove([scrapbookId])
      });
      // ignore: use_build_context_synchronously
      CustomSnackBar.snackBarAlert(context, "Removed from saved!");
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({
        'savedPosts': FieldValue.arrayUnion([scrapbookId])
      });
      // ignore: use_build_context_synchronously
      CustomSnackBar.snackBarAlert(context, "Saved!");
    }
  }

  void deleteScrapbook(String scrapbookId, BuildContext context) async {
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => const Center(
    //     child: CircularProgressIndicator(
    //       color: Color(0xff918ef4),
    //     ),
    //   ),
    // );
    final scrapbookData = await FirebaseFirestore.instance
        .collection('scrapbooks')
        .doc(scrapbookId)
        .get()
        .then((value) => value.data()!);

    await FirebaseFirestore.instance
        .collection('scrapbooks')
        .doc(scrapbookId)
        .delete();

    await FirebaseFirestore.instance
        .collection('comment')
        .doc(scrapbookId)
        .collection('comments')
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });

    final cover = scrapbookData['coverUrl'];
    cover != "" ? StorageMethods().deleteFromScrapbook(cover) : null;

    await StorageMethods().deleteScrapbook(scrapbookId);

    await FirebaseFirestore.instance
        .collection('reportedScrapbooks')
        .doc(scrapbookId)
        .delete();

    // ignore: use_build_context_synchronously
    CustomSnackBar.snackBarAlert(context, "Scrapbook deleted!");
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  editScrapbook(
    String scrapbookId,
    File? cover,
    String? title,
    String? caption,
    bool? tag,
    bool? type,
    bool? visibility,
    int? interestIndex,
    bool locationDisabled,
    List<dynamic> posts,
    BuildContext context,
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

    final docScrapbook =
        FirebaseFirestore.instance.collection('scrapbooks').doc(scrapbookId);

    docScrapbook.update({
      'title': title,
      'caption': caption,
      'tag': tag! ? 'Factual' : 'Personal',
      'type': type! ? 'Normal' : 'Secret',
      'visibility': visibility! ? 'Public' : 'Private',
      'interest': interestIndex,
    });

    if (locationDisabled) {
      docScrapbook.update({'latitude': 0, 'longitude': 0});
    }

    if (cover != null) {
      String oldCover = "";
      await docScrapbook.get().then((value) {
        oldCover = value.data()!['coverUrl'];
      });
      await docScrapbook.update(
          {'coverUrl': await StorageMethods().uploadScrapbookCover(cover)});
      StorageMethods().deleteFromScrapbook(oldCover);
    }

    List<dynamic> postsList = [];
    await docScrapbook.get().then((value) {
      postsList = List.from(value.data()!['posts']);
    });

    for (int i = 0; i < posts.length; i++) {
      if (posts[i] == "" && postsList[i] != "") {
        await StorageMethods().deleteFromScrapbook(postsList[i]);
        postsList[i] = "";
      } else if (posts[i] is File && postsList[i] == "") {
        postsList[i] = await StorageMethods().uploadPost(posts[i], scrapbookId);
      } else if (posts[i] is File && postsList[i] != "") {
        await StorageMethods().deleteFromScrapbook(postsList[i]);
        postsList[i] = await StorageMethods().uploadPost(posts[i], scrapbookId);
      }
    }

    docScrapbook.update({'posts': postsList});
  }

  Future createNotification(
    String creatorId,
    String scrapbookId,
    String coverUrl,
    String type,
    BuildContext context,
    bool mounted,
  ) async {
    try {
      bool isNotCurrentUser = _auth.currentUser!.uid != creatorId;
      if (isNotCurrentUser) {
        int feedNum = 0;
        DocumentSnapshot snap = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .get();

        String title = "";
        if (scrapbookId != "") {
          DocumentSnapshot snapPost =
              await _firestore.collection('scrapbooks').doc(scrapbookId).get();
          title = (snapPost.data()! as dynamic)['title'];
        }

        CollectionReference collectionReference = _firestore
            .collection('feed')
            .doc(creatorId)
            .collection('feedItems');

        final docFeed = collectionReference.doc();

        collectionReference.get().then((QuerySnapshot snapshot) async {
          feedNum = snapshot.size;
          final notificationModel = NotificationModel(
            uid: _auth.currentUser!.uid,
            feedId: docFeed.id,
            type: type,
            username: (snap.data()! as dynamic)['username'],
            photoUrl: (snap.data()! as dynamic)['photoUrl'],
            scrapbookId: scrapbookId,
            title: title,
            coverUrl: coverUrl,
            feedNum: feedNum + 1,
          );
          final json = notificationModel.toJson();
          await docFeed.set(json);

          if (!mounted) return;
        });
      }
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
  }

  removeNotification(
    String creatorId,
    String scrapbookId,
    String uid,
    String type,
    BuildContext context,
    bool mounted,
  ) {
    try {
      CollectionReference collectionReference =
          _firestore.collection('feed').doc(creatorId).collection('feedItems');
      collectionReference
          .where('uid', isEqualTo: uid)
          .where('scrapbookId', isEqualTo: scrapbookId)
          .where('type', isEqualTo: type)
          .get()
          .then((QuerySnapshot snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          QueryDocumentSnapshot documentSnapshot = snapshot.docs[0];
          documentSnapshot.reference.delete();
        }
        if (!mounted) return;
      });
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
  }

  Future reportScrapbook(
    String scrapbookId,
    String reason,
    BuildContext context,
  ) async {
    DocumentSnapshot snapUser =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

    CollectionReference collectionReference =
        _firestore.collection('reportedScrapbooks');

    DocumentReference documentReference = collectionReference.doc(scrapbookId);

    final reportModel = ReportScrapbookModel(
      reporterUid: snapUser.id,
      scrapbookId: scrapbookId,
      reportReason: reason,
    );

    final json = reportModel.toJson();

    await documentReference.set(json);

    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'reportedPosts': FieldValue.arrayUnion([scrapbookId])
    });
    // ignore: use_build_context_synchronously
    CustomSnackBar.showSnackBar(context, 'Scrapbook reported');
  }

  Future reportUser(
    String userId,
    String reason,
    BuildContext context,
  ) async {
    DocumentSnapshot snapUser =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

    CollectionReference collectionReference =
        _firestore.collection('reportedUsers');

    DocumentReference documentReference = collectionReference.doc(userId);

    final reportModel = ReportUserModel(
      userReportedUid: userId,
      reporterUid: snapUser.id,
      reportReason: reason,
    );

    final json = reportModel.toJson();

    await documentReference.set(json);

    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'reportedUsers': FieldValue.arrayUnion([userId])
    });
  }

  addCollaborator(
    String uid,
    String scrapbookId,
    BuildContext context,
    bool mounted,
  ) async {
    try {
      DocumentSnapshot userSnap =
          await _firestore.collection('users').doc(uid).get();
      DocumentSnapshot postSnap =
          await _firestore.collection('scrapbooks').doc(scrapbookId).get();
      var collaborators = {};
      collaborators = await _firestore
          .collection('scrapbooks')
          .doc(scrapbookId)
          .get()
          .then((value) => value['collaborators']);
      if ((postSnap.data()! as dynamic)['group'] == false) {
        await _firestore
            .collection('scrapbooks')
            .doc(scrapbookId)
            .update({'group': true});
      }
      if (!collaborators
          .containsKey((userSnap.data()! as dynamic)['username'])) {
        collaborators[(userSnap.data()! as dynamic)['username']] = false;
        _firestore
            .collection("scrapbooks")
            .doc(scrapbookId)
            .update({"collaborators": collaborators});
      }
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
  }
}
