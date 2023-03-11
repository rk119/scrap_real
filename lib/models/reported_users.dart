class ReportUserModel {
  final String userReportedUid;
  final String reporterUid;
  String? reportReason;

  ReportUserModel({
    required this.userReportedUid,
    required this.reporterUid,
    this.reportReason,
  });

  Map<String, dynamic> toJson() => {
        'userReportedUid': userReportedUid,
        'reporterUid': reporterUid,
        'reportReason': reportReason,
      };
}
