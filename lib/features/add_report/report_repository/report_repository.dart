import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damgerepoert/core/model/report_model.dart';

class ReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = "reports";

  Future<void> createReport(ReportModel report) async {
    try {
      await _firestore.collection(_collectionPath).add(report.tojason());
    } catch (e) {
      throw Exception("meeran Failed to create report: $e");
    }
  }

  Future<List<ReportModel>> fetchReports() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionPath).get();
      return querySnapshot.docs
          .map((doc) => ReportModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch reports: $e");
    }
  }

  Future<void> updateReport(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).update(data);
    } catch (e) {
      throw Exception("Failed to update report: $e");
    }
  }

  Future<void> deleteReport(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception("Failed to delete report: $e");
    }
  }
}
