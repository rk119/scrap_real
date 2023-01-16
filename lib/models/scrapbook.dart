class ScrapbookModel {
  String creatorUid;
  String scrapbookId;
  final String title;
  final String caption;
  final String tag;
  final String type;
  final String visibility;
  final String collaborators;
  final String coverUrl;
  final String posts;

  ScrapbookModel({
    this.creatorUid = '',
    this.scrapbookId = '',
    required this.title,
    required this.caption,
    required this.tag,
    required this.type,
    required this.visibility,
    required this.collaborators,
    required this.coverUrl,
    required this.posts,
  });

  Map<String, dynamic> toJson() => {
        'creatorUid': creatorUid,
        'scrapbookId': scrapbookId,
        'title': title,
        'caption': caption,
        'tag': tag,
        'type': type,
        'visibility': visibility,
        'collaborators': [],
        "coverUrl": "",
        'posts': [],
      };
}
