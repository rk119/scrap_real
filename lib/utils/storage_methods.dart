import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // this was the old method of uploading images
  // the "if statement" technique can be used to
  // modify the uploadProfilePic method to be doubly
  // used for uploading posts
  // -------------------------------------------
  // Future<String> uploadImageToStorage(
  //   String childName,
  //   Uint8List file,
  //   bool isPost,
  // ) async {
  //   // creating location to our firebase storage
  //   Reference ref =
  //       _storage.ref().child(childName).child(_auth.currentUser!.uid);
  //   if (isPost) {
  //     String id = const Uuid().v1();
  //     ref = ref.child(id);
  //   }
  //   // putting in uint8list format -> Upload task like a future but not future
  //   UploadTask uploadTask = ref.putData(file);

  //   TaskSnapshot snapshot = await uploadTask;
  //   String downloadUrl = await snapshot.ref.getDownloadURL();
  //   return downloadUrl;
  // }

  Future<String> uploadProfilePic(PlatformFile pickedFile) async {
    const path = 'profilePics';
    final file = File(pickedFile.path!);

    final ref = _storage.ref().child(path).child(_auth.currentUser!.uid);
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  selectImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    // ignore: avoid_print
    print('No Image Selected');
  }

  selectTempImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return File(file.path);
    }
    // ignore: avoid_print
    print('No Image Selected');
  }

  Future<String> uploadScrapbookCover(File pickedFile) async {
    const path = 'scrapbookCover';
    final file = File(pickedFile.path);

    final ref = _storage
        .ref()
        .child(path)
        .child(_firestore.collection('scrapbook').doc().id);
    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Future<String> uploadPost(String description, Uint8List file, String uid,
  //     String username, String profImage) async {
  //   // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
  //   String res = "Some error occurred";
  //   try {
  //     String photoUrl =
  //         await StorageMethods().uploadImageToStorage('posts', file, true);
  //     String postId = const Uuid().v1(); // creates unique id based on time
  //     Post post = Post(
  //       description: description,
  //       uid: uid,
  //       username: username,
  //       likes: [],
  //       postId: postId,
  //       datePublished: DateTime.now(),
  //       postUrl: photoUrl,
  //       profImage: profImage,
  //     );
  //     _firestore.collection('posts').doc(postId).set(post.toJson());
  //     res = "success";
  //   } catch (err) {
  //     res = err.toString();
  //   }
  //   return res;
  // }
}
