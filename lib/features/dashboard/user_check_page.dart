import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damgerepoert/core/backend/authentication.dart';
import 'package:damgerepoert/core/backend/user_repository.dart';
import 'package:damgerepoert/features/admin/admin_pages/admin_nav_bar.dart';
import 'package:damgerepoert/features/login/view/login_page.dart';
import 'package:damgerepoert/features/mainPage/main_page.dart';
import 'package:damgerepoert/features/monitor_user/monitor_pages/monitor_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserTypeCheck extends StatefulWidget {
  const UserTypeCheck({
    super.key,
  });

  @override
  State<UserTypeCheck> createState() => _UserTypeCheckState();
}

class _UserTypeCheckState extends State<UserTypeCheck> {
  final _authRepo = Get.put(AuthenticationRepository());
  late final email = _authRepo.firebaseUser.value?.email;
  final userRepository = Get.put(UserRepository());

  @override
  void initState() {
    super.initState();
    if (email != null) {
      // userRepository.getUserDetails(email!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('User')
          .where('Email', isEqualTo: email ?? "")
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: const Text('Loading...')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return const LoginScreen();
        }
        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return const LoginScreen(); // No user found, redirect to login
          }
          var userData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          print(userData['userType']);
          if (userData['userType'] == 'User') {
            return const MainPage();
          } else if (userData['userType'] == 'Admin') {
            return const AdminNavBar();
          } else if (userData['userType'] == 'Monitor') {
            return const MonitorNavBar();
          }
        }
        return const LoginScreen();
      },
    );
  }
}
