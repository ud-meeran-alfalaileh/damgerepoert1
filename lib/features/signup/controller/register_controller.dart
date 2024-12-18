import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/backend/authentication.dart';
import 'package:damgerepoert/core/backend/user_repository.dart';
import 'package:damgerepoert/core/model/user_model.dart';
import 'package:damgerepoert/features/dashboard/user_check_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController major = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();

  final formkey = GlobalKey<FormState>();
  final updateKey = GlobalKey<FormState>();

  final userRepository = Get.put(UserRepository);
  RxString selectedItem = "".obs;

  void registerUser(String email, String password) {
    AuthenticationRepository().createUserWithEmailAndPassword(email, password);
  }

  var maskFormatterPhone = MaskTextInputFormatter(
      mask: '### ### ####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  Future<void> createUser(UserModel user) async {
    await UserRepository().createUser(user);
    Get.to(const UserTypeCheck());
  }

  validateEmail(String? email) {
    if (GetUtils.isEmail(email!)) {
      return null;
    }
    return 'Email is not vaild';
  }

  vaildPhoneNumber(String? phoneNumber) {
    if (GetUtils.isPhoneNumber(phoneNumber!)) {
      return null;
    }
    return 'Phone Number is not vaild';
  }

  vaildatePassword(String? password) {
    if (!GetUtils.isLengthGreaterOrEqual(password, 6)) {
      return 'Password is not vaild';
    }
    return null;
  }

  vaildFiled(dynamic text) {
    if (!GetUtils.isBlank(text!)!) {
      return null;
    }

    return 'The Major is not vild';
  }

  vaildateUserName(String? userName) {
    if (GetUtils.isUsername(userName!)) {
      return null;
    }
    return 'UserName is not vaild';
  }

  Future<void> onSignup(UserModel userModel) async {
    if (formkey.currentState!.validate()) {
      Future<bool> code = AuthenticationRepository()
          .createUserWithEmailAndPassword(userModel.email, userModel.password);
      if (await code) {
        await createUser(userModel);
        Get.snackbar("Success", " Account  Created Successfullly",
            snackPosition: SnackPosition.BOTTOM,
            colorText: AppColor.subappcolor,
            backgroundColor: AppColor.success);
      } else {
        Get.snackbar("ERROR", "Invalid data",
            snackPosition: SnackPosition.BOTTOM,
            colorText: AppColor.subappcolor,
            backgroundColor: AppColor.error);
      }
    }
  }
}
