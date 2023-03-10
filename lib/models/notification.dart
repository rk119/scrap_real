class NotificationModel {
  String uid;
  String feedId;
  final String type;
  final String username;
  final String photoUrl;
  final String scrapbookId;
  final String coverUrl;
  final int feedNum;

  NotificationModel({
    this.uid = '',
    this.feedId = '',
    required this.type,
    required this.username,
    required this.photoUrl,
    required this.scrapbookId,
    required this.coverUrl,
    required this.feedNum,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'feedId': feedId,
        'type': type,
        'username': username,
        'photoUrl': photoUrl,
        'scrapbookId': scrapbookId,
        'coverUrl': coverUrl,
        'feedNum': feedNum,
      };
}
