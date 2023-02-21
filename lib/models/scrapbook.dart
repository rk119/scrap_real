class ScrapbookModel {
  String creatorUid;
  String scrapbookId;
  final String title;
  final String caption;
  final String tag;
  final String type;
  final String visibility;
  final List likes;
  final List collaborators;
  final String coverUrl;
  final List posts;
  final bool group;
  final double latitude;
  final double longitude;

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
    required this.latitude,
    required this.longitude,
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
        'latitude': latitude,
        'longitude': longitude,
      };
}
