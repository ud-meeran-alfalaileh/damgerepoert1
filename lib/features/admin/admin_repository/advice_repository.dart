import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damgerepoert/features/admin/admin_model.dart/advice_model.dart';

class AdviceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = "advices";

  Future<void> createReport(AdviceModel report) async {
    try {
      await _firestore.collection(_collectionPath).add(report.tojason());
    } catch (e) {
      throw Exception(" Failed to create report: $e");
    }
  }

  Future<List<AdviceModel>> fetchAdvice() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionPath).get();
      return querySnapshot.docs
          .map((doc) => AdviceModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch Advice: $e");
    }
  }

  Future<void> updateAdvice(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).update(data);
    } catch (e) {
      throw Exception("Failed to update Advice: $e");
    }
  }

  Future<void> deleteAdvice(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      throw Exception("Failed to delete Advice: $e");
    }
  }
}
