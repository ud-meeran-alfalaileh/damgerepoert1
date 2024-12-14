import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String? id;
  late String userEmail;
  late String reportName;
  late String date;
  late String reportImage;

  ReportModel({
    this.id,
    required this.userEmail,
    required this.reportName,
    required this.date,
    required this.reportImage,
  });

  tojason() {
    return {
      "UserEmail": userEmail,
      "ReportName": reportName,
      "Date": date,
      "ReportImage": reportImage,
    };
  }

  factory ReportModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    final data = documentSnapshot.data()!;
    return ReportModel(
      id: documentSnapshot.id,
      userEmail: data["UserEmail"],
      reportName: data["ReportName"],
      date: data["Date"],
      reportImage: data["ReportImage"],
    );
  }
}
