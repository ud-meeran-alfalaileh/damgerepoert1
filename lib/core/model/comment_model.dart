import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? id;
  late String userEmail;
  late String reportName;
  late String date;
  late String reportImage;
  late String reportDescription;
  late String reportLocation;
  late String status;
  late String comment;

  CommentModel({
    this.id,
    required this.userEmail,
    required this.reportName,
    required this.date,
    required this.reportImage,
    required this.reportDescription,
    required this.reportLocation,
    required this.status,
    required this.comment,
  });

  tojason() {
    return {
      "UserEmail": userEmail,
      "ReportName": reportName,
      "Date": date,
      "ReportImage": reportImage,
      "reportDescription": reportDescription,
      "reportLocation": reportLocation,
      "status": status,
      "comment": comment
    };
  }

  factory CommentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return CommentModel(
        id: documentSnapshot.id,
        userEmail: data["UserEmail"],
        reportName: data["ReportName"],
        status: data["status"],
        reportLocation: data["reportLocation"] ?? '',
        date: data["Date"],
        reportImage: data["ReportImage"],
        reportDescription: data['reportDescription'] ?? '',
        comment: data['comment'] ?? '');
  }
}
