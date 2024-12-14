import 'package:damgerepoert/features/add_report/report_repository/report_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:damgerepoert/core/model/report_model.dart';

class ReportController extends GetxController {
  static ReportController get instance => Get.find();

  final TextEditingController userEmail = TextEditingController();
  final TextEditingController reportName = TextEditingController();
  final TextEditingController reportImage = TextEditingController();
  final TextEditingController reportDate = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final reportRepository = Get.put(ReportRepository());
  Future<void> createReport(ReportModel reportModel) async {
    if (formKey.currentState!.validate()) {
      try {
        await reportRepository.createReport(reportModel);
        Get.snackbar(
          "Success",
          "Report created successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          "Error",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  String? validateEmail(String? email) {
    if (GetUtils.isEmail(email!)) {
      return null;
    }
    return 'Invalid email address';
  }

  String? validateReportName(String? name) {
    if (name != null && name.isNotEmpty) {
      return null;
    }
    return 'Report name is required';
  }

  String? validateImageUrl(String? url) {
    if (url != null && Uri.tryParse(url)?.hasAbsolutePath == true) {
      return null;
    }
    return 'Invalid image URL';
  }

  String? validateReportDate(String? date) {
    if (date != null && date.isNotEmpty) {
      return null;
    }
    return 'Report date is required';
  }

  Future<void> onSubmit(ReportModel reportModel) async {
    if (formKey.currentState!.validate()) {
      await createReport(reportModel);
    }
  }
}
