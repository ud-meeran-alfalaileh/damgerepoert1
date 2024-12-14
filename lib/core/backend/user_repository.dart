// ignore_for_file: unnecessary_null_comparison, body_might_complete_normally_catch_error, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/controller/user_controller.dart';
import 'package:damgerepoert/core/model/user_model.dart';
import 'package:get/get.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final userController = Get.put(UserController());

  final _db = FirebaseFirestore.instance;

  late UserModel userModel;

  void setUserModel(UserModel userModel) {
    this.userModel = userModel;
  }

  createUser(UserModel user) {
    _db
        .collection("User")
        .add(user.tojason())
        .whenComplete(() => Get.snackbar(
            "Success", "Your account has been created",
            snackPosition: SnackPosition.BOTTOM,
            colorText: AppColor.subappcolor,
            backgroundColor: AppColor.success))
        .catchError((error) {
      Get.snackbar(error.toString(), "Something went wrong , try agin",
          snackPosition: SnackPosition.BOTTOM,
          colorText: AppColor.subappcolor,
          backgroundColor: AppColor.error);
    });
  }

  Future<void> updateUserRecord(UserModel user) async {
    await _db.collection("User").doc(user.id).update(user.tojason());
  }

  Future<UserModel> getUserDetails(String email) async {
    final snapshot =
        await _db.collection("User").where("Email", isEqualTo: email).get();
    final userdata = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    userModel = userdata;
    userController.saveUserInfo(userdata);
    return userdata;
  }
}
