class ScrapbookModel {
  String creatorUid;
  String scrapbookId;
  final String title;
  final String caption;
  final String tag;
  final String type;
  final String visibility;
  final List likes;
  final Map collaborators;
  final String coverUrl;
  final List posts;
  final bool group;
  final String riddle;
  final String answer;
  final double latitude;
  final double longitude;
  final double altitude;

  ScrapbookModel({
    this.creatorUid = '',
    this.scrapbookId = '',
    required this.title,
    required this.caption,
    required this.tag,
    required this.type,
    required this.visibility,
    required this.likes,
    required this.collaborators,
    required this.coverUrl,
    required this.posts,
    required this.group,
    required this.riddle,
    required this.answer,
    required this.latitude,
    required this.longitude,
    required this.altitude,
  });

  Map<String, dynamic> toJson() => {
        'creatorUid': creatorUid,
        'scrapbookId': scrapbookId,
        'title': title,
        'caption': caption,
        'tag': tag,
        'type': type,
        'visibility': visibility,
        'likes': likes,
        'collaborators': collaborators,
        "coverUrl": coverUrl,
        'posts': posts,
        'group': group,
        'riddle': riddle,
        'answer': answer,
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
      };
}
