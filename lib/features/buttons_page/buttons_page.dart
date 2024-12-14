import 'package:damgerepoert/core/widget/buttons.dart';
import 'package:damgerepoert/features/login/view/login_page.dart';
import 'package:damgerepoert/features/signup/view/register_page.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart'; // Corrected import statement
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import '../../../config/theme/theme.dart';

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.subappcolor,
        body: Center(
          child: Container(
            margin: const EdgeInsets.only(top: 100), // Adjust top margin here
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Gap(40),
                Text(
                  "Damge Report",
                  style: GoogleFonts.caesarDressing(
                    // Apply Caesar Dressing font
                    textStyle: TextStyle(
                      color: AppColor.buttonColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 64,
                    ),
                  ),
                ),
                const Gap(50),
                Text(
                  'Let’s get started!',
                  style: TextStyle(
                    color: AppColor.buttonColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Gap(20),
                Text(
                  'Login to explore the features our Damge Report ,\n and enhance your Envroiment',
                  style: TextStyle(
                    color: AppColor.buttonColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(80),
                Buttons.selectedButton(
                    "login",
                    () => Get.to(const LoginScreen()),
                    AppColor.error,
                    AppColor.subappcolor),
                const Gap(20),
                Buttons.selectedButton(
                    "sign up",
                    () => Get.to(const RegisterScreen()),
                    AppColor.buttonColor, // color or container
                    AppColor.subappcolor // color of text

                    ),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
