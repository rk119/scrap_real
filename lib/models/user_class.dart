class UserModel {
  String uid;
  final String email;
  final String name;
  final String username;
  final String bio;
  final String photoUrl;
  final List followers;
  final List following;
  final List savedPosts;
  final List blockedUsers;
  final List reportUsers;
  final List reportPosts;

  UserModel({
    this.uid = '',
    required this.email,
    required this.name,
    required this.username,
    required this.bio,
    required this.photoUrl,
    required this.followers,
    required this.following,
    required this.savedPosts,
    required this.blockedUsers,
    required this.reportUsers,
    required this.reportPosts,
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
        'savedPosts': [],
        'blockedUsers': [],
        'reportUsers': [],
        'reportPosts': [],
      };
}
