class CommentModel {
  String creatorUid;
  String commentId;
  final String username;
  final String comment;
  final String photoUrl;
  final int commentNum;

  CommentModel({
    this.creatorUid = '',
    this.commentId = '',
    required this.username,
    required this.comment,
    required this.photoUrl,
    required this.commentNum,
  });

  Map<String, dynamic> toJson() => {
        'creatorUid': creatorUid,
        'commentId': commentId,
        'username': username,
        'comment': comment,
        'photoUrl': photoUrl,
        'commentNum': commentNum,
      };
}
