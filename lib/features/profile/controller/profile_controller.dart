import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/backend/authentication.dart';
import 'package:damgerepoert/core/controller/user_controller.dart';
import 'package:damgerepoert/features/profile/model/profile_button_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileController extends GetxController {
  List<ProfileButton> profileList = [
    ProfileButton(
        title: 'My chats',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () =>
            Get.to(const Scaffold(), transition: Transition.rightToLeft)),
    ProfileButton(
        title: 'my schulde',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () =>
            Get.to(const Scaffold(), transition: Transition.rightToLeft)),
    ProfileButton(
        title: 'About',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () {}),
    ProfileButton(
      title: 'Logout',
      icon: SvgPicture.asset(
        'assets/arrow.svg',
        matchTextDirection: true,
        width: 15,
        height: 15,
      ),
      onTap: () => {
        AuthenticationRepository().logout(),
        UserController.instance.clearUserInfo()
      },
    ),
  ];
}

void showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: CircleAvatar(
          backgroundColor: AppColor.buttonColor,
          radius: 30,
          child: Icon(
            Icons.logout_rounded,
            size: 30,
            color: AppColor.subappcolor,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Are you sure to log out of your account?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: AppColor.buttonColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => {print("object"), Get.back()},
                    child: const Text('cancel')),
                ElevatedButton(
                    onPressed: () =>
                        {print("object"), AuthenticationRepository().logout()},
                    child: const Text('logout'))
              ],
            ),
          ],
        ),
      );
    },
  );
}
