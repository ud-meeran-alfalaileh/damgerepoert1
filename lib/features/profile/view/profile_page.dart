import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/backend/user_repository.dart';
import 'package:damgerepoert/core/model/user_model.dart';
import 'package:damgerepoert/core/widget/text.dart';
import 'package:damgerepoert/features/profile/controller/profile_controller.dart';
import 'package:damgerepoert/features/profile/model/profile_button_model.dart';
import 'package:damgerepoert/features/profile/repository/profile_repository.dart';
import 'package:damgerepoert/features/profile/widget/profile_container.dart';
import 'package:damgerepoert/features/update_profile/update_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final userController = Get.put(UserRepository());
  @override
  void initState() {
    super.initState();
    // Call this method on initState to ensure the status bar is removed when the widget is first loaded
    removeStatusBar();
  }

  void removeStatusBar() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor:
          Colors.transparent, // Change the status bar color if needed
      statusBarBrightness:
          Brightness.dark, // Change the status bar brightness if needed
    ));
  }

  @override
  Widget build(BuildContext context) {
    List<ProfileButton> profileList = [
      ProfileButton(
        title: 'My Reports',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () =>
            Get.to(const Scaffold(), transition: Transition.rightToLeft),
      ),
      ProfileButton(
        title: 'My Schedule',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () =>
            Get.to(const Scaffold(), transition: Transition.rightToLeft),
      ),
      ProfileButton(
        title: 'About',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () {},
      ),
      ProfileButton(
        title: 'Logout',
        icon: SvgPicture.asset(
          'assets/arrow.svg',
          matchTextDirection: true,
          width: 15,
          height: 15,
        ),
        onTap: () {
          showLogoutDialog(context);
        },
      ),
    ];

    Get.put(ProfileController());
    final profileController = Get.put(ProfileRepository());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: TextApp.appBarText('profile'),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const Gap(30),
            FutureBuilder(
              future: Future.delayed(
                const Duration(milliseconds: 500),
                () => profileController.getUserData(),
              ),
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.done) {
                  if (snapShot.hasData) {
                    UserModel userData = snapShot.data as UserModel;
                    final userName = TextEditingController(text: userData.name);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                const Gap(20),
                                Text(userName.text,
                                    style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                            color: AppColor.buttonColor))),
                                const Gap(20),
                                Divider(
                                  thickness: 2,
                                  color: AppColor.subappcolor,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.to(const UpdateUserWidget());
                                  },
                                  child: Text('VIEW Profile',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                              color: AppColor.buttonColor))),
                                ),
                              ],
                            ),
                            const Gap(10),
                            SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: profileList.length,
                                itemBuilder: ((context, index) {
                                  return profileContainer(profileList[index]);
                                }),
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const Gap(30);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (snapShot.hasError) {
                    return Center(child: Text('Error${snapShot.error}'));
                  } else {
                    return const Text('somthing was wrong ');
                  }
                } else if (snapShot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Text("somthing went wrong");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
