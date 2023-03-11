class ReportScrapbookModel {
  final String scrapbookId;
  final String reporterUid;
  final String? reportReason;

  ReportScrapbookModel({
    required this.scrapbookId,
    required this.reporterUid,
    this.reportReason,
  });

  Map<String, dynamic> toJson() => {
        'scrapbookId': scrapbookId,
        'reporterUid': reporterUid,
        'reportReason': reportReason,
      };
}
