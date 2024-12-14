import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/model/form_model.dart';
import 'package:damgerepoert/core/model/user_model.dart';
import 'package:damgerepoert/core/widget/buttons.dart';
import 'package:damgerepoert/core/widget/form_model.dart';
import 'package:damgerepoert/core/widget/text.dart';
import 'package:damgerepoert/features/login/view/login_page.dart';
import 'package:damgerepoert/features/signup/controller/register_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppColor.mainAppColor,
            )),
        title: TextApp.appBarText('Register page'),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Gap(20),
              Form(
                key: controller.formkey,
                child: SizedBox(
                  height: 550,
                  width: double.infinity,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    children: [
                      FormWidget(
                          textForm: FormModel(
                              controller: controller.userName,
                              enableText: false,
                              hintText: 'User name',
                              icon: const Icon(Icons.person),
                              invisible: false,
                              validator: (username) =>
                                  controller.vaildateUserName(username),
                              type: TextInputType.name,
                              onChange: null,
                              inputFormat: [],
                              onTap: null)),
                      const Gap(15),
                      FormWidget(
                          textForm: FormModel(
                              controller: controller.email,
                              enableText: false,
                              hintText: 'Email',
                              icon: const Icon(Icons.email),
                              invisible: false,
                              validator: (email) =>
                                  controller.validateEmail(email),
                              type: TextInputType.emailAddress,
                              onChange: null,
                              inputFormat: [],
                              onTap: null)),
                      const Gap(15),
                      FormWidget(
                          textForm: FormModel(
                              controller: controller.phone,
                              enableText: false,
                              hintText: 'phone',
                              icon: const Icon(Icons.phone),
                              invisible: false,
                              validator: (phone) =>
                                  controller.vaildPhoneNumber(phone),
                              type: TextInputType.number,
                              onChange: null,
                              inputFormat: [controller.maskFormatterPhone],
                              onTap: null)),
                      const Gap(15),
                      FormWidget(
                          textForm: FormModel(
                              controller: controller.password,
                              enableText: false,
                              hintText: 'Password',
                              icon: const Icon(Icons.password),
                              invisible: true,
                              validator: (password) =>
                                  controller.vaildatePassword(password),
                              type: TextInputType.visiblePassword,
                              onChange: null,
                              inputFormat: [],
                              onTap: null)),
                      const Gap(30),
                      Buttons.formscontainer(
                          title: 'Sign In',
                          onTap: () => {
                                controller.onSignup(UserModel(
                                  email: controller.email.text,
                                  name: controller.userName.text,
                                  password: controller.password.text,
                                  phone: controller.phone.text,
                                  userType: 'User',
                                ))
                              })
                    ],
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Already have an account? ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(const LoginScreen());
                        },
                      text: 'login',
                      style: TextStyle(
                        color: AppColor.mainAppColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
