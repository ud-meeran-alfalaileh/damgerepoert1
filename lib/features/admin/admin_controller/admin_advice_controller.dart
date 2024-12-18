import 'package:damgerepoert/features/admin/admin_model.dart/advice_model.dart';
import 'package:damgerepoert/features/admin/admin_repository/advice_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdviceController extends GetxController {
  final reportRepository = Get.put(AdviceRepository());
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController();
  RxList<AdviceModel> advices = <AdviceModel>[].obs;
  RxBool isloading = true.obs;
  Future<void> createAdvice(AdviceModel advice) async {
    if (formKey.currentState!.validate()) {
      try {
        await reportRepository.createReport(advice);
        Get.snackbar(
          "Success",
          "Advice created successfully",
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

  Future<void> getAdvices() async {
    isloading.value = true;
    try {
      advices.value = await reportRepository.fetchAdvice();
      isloading.value = false;
    } catch (e) {
      print(e);
    }
  }

  String? validateAdvicetName(String? name) {
    if (name != null && name.isNotEmpty) {
      return null;
    }
    return 'Report advice is required';
  }
}
