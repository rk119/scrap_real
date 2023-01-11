class UserModel {
  String uid;
  final String email;
  final String name;
  final String userName;
  final String bio;
  final List followers;
  final List following;

  UserModel({
    this.uid = '',
    required this.email,
    required this.name,
    required this.userName,
    required this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'userName': userName,
        "bio": "",
        'followers': [],
        'following': [],
      };
}
