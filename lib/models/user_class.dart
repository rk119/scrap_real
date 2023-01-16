class UserModel {
  String uid;
  final String email;
  final String name;
  final String username;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;

  UserModel({
    this.uid = '',
    required this.email,
    required this.name,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'username': username,
        "bio": "",
        "photoUrl": "",
        'followers': [],
        'following': [],
      };
}