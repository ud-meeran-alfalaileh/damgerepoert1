import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/model/comment_model.dart';
import 'package:get/get.dart';

class CommenttRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = "comments";

  Future<void> createComment(CommentModel report) async {
    try {
      await _firestore.collection(_collectionPath).add(report.tojason());
      Get.snackbar("Success", " Account  Created Successfullly",
            snackPosition: SnackPosition.BOTTOM,
            colorText: AppColor.subappcolor,
            backgroundColor: AppColor.success);
            
    } catch (e) {
      throw Exception(" Failed to create report: $e");
    }
  }

  Future<List<CommentModel>> fetchComment() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionPath).get();
      return querySnapshot.docs
          .map((doc) => CommentModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw Exception("Failed to fetch reports: $e");
    }
  }

  Future<void> updateComment(String id, Map<String, dynamic> data) async {
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