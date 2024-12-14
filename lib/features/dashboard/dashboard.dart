import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:damgerepoert/core/backend/authentication.dart';
import 'package:damgerepoert/core/backend/user_repository.dart';
import 'package:damgerepoert/features/mainPage/main_page.dart';
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
    userRepository.getUserDetails(email ?? '');
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
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text("Error: ${snapshot.error}")),
          );
        }
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          var userData =
              snapshot.data!.docs.first.data() as Map<String, dynamic>;
          if (userData['userType'] == 'Doctor') {
            return const DoctorDashboardPage();
          } else {
            return const MainPage();
          }
        }
        return Scaffold(
          appBar: AppBar(title: const Text('User not found')),
          body: const Center(child: Text("User data not found")),
        );
      },
    );
  }
}

class DoctorDashboardPage extends StatefulWidget {
  const DoctorDashboardPage({super.key});

  @override
  _DoctorDashboardPageState createState() => _DoctorDashboardPageState();
}

class _DoctorDashboardPageState extends State<DoctorDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Dashboard'),
        actions: [
          IconButton(
              onPressed: () => AuthenticationRepository().logout(),
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('User')
            .where('userType', isEqualTo: 'User')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot user = snapshot.data!.docs[index];
              return ListTile(
                title: Text(user['UserName']),
                subtitle: Text(user['Email']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserReviewsPage(email: user['Email']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class UserReviewsPage extends StatelessWidget {
  final String email;

  const UserReviewsPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Reviews'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where('userEmail', isEqualTo: email)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot review = snapshot.data!.docs[index];
              return ListTile(
                title: Text('Rating: ${review['rating']}'),
                subtitle: Text(review['review']),
                // You can add more details if needed
              );
            },
          );
        },
      ),
    );
  }
}

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome, User!'),
      ),
    );
  }
}
