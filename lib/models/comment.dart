class CommentModel {
  String creatorUid;
  String commentId;
  final String uid;
  final String comment;
  final int commentNum;

  CommentModel({
    this.creatorUid = '',
    this.commentId = '',
    required this.uid,
    required this.comment,
    required this.commentNum,
  });

  Map<String, dynamic> toJson() => {
        'creatorUid': creatorUid,
        'commentId': commentId,
        'uid': uid,
        'comment': comment,
        'commentNum': commentNum,
      };
}
