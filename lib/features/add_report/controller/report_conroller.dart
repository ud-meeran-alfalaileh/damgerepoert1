import 'package:damgerepoert/core/model/report_model.dart';
import 'package:damgerepoert/features/add_report/report_repository/report_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
  static ReportController get instance => Get.find();

  final TextEditingController userEmail = TextEditingController();
  final TextEditingController reportName = TextEditingController();
  final TextEditingController reportDescription = TextEditingController();
  final TextEditingController reportImage = TextEditingController();
  final TextEditingController reportDate = TextEditingController();
  final TextEditingController location = TextEditingController();
  RxBool showMap = false.obs;
  final formKey = GlobalKey<FormState>();
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  RxList<ReportModel> reports = <ReportModel>[].obs;
  RxBool isloading = true.obs;
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

  Future<void> updateReport(ReportModel reportModel) async {
    print(reportModel.tojason());
    try {
      await reportRepository.updateReport(
          reportModel.id!, reportModel.tojason()); // Convert to Map
      Get.snackbar(
        "Success",
        "Report Updated successfully",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      getReport();
    } catch (e) {
      print(e);
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> getReport() async {
    isloading.value = true;
    try {
      reports.value = await reportRepository.fetchReports();
      isloading.value = false;
    } catch (e) {
      print(e);
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

  String? validateReportDescription(String? name) {
    if (name != null && name.isNotEmpty) {
      return null;
    }
    return 'Report Description is required';
  }

  String? validateReportLocation(String? name) {
    if (name != null && name.isNotEmpty) {
      return null;
    }
    return 'Report Location is required';
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
