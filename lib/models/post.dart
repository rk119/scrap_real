class PostModel {
  String posterId;
  String scrapbookId;
  String postId;
  final String photoUrl;
  final DateTime datePosted;

  PostModel({
    this.posterId = '',
    this.scrapbookId = '',
    this.postId = '',
    required this.photoUrl,
    required this.datePosted,
  });

  Map<String, dynamic> toJson() => {
        'posterId': posterId,
        'scrapbookId': scrapbookId,
        'postId': postId,
        "photoUrl": "",
        "datePosted": datePosted,
      };
}
