import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/backend/authentication.dart';
import 'package:damgerepoert/core/backend/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authRepo = Get.put(AuthenticationRepository());

  late final email = _authRepo.firebaseUser.value?.email;

  final userRepository = Get.put(UserRepository());

  @override
  void initState() {
    super.initState();
    userRepository.getUserDetails(email ?? '');
  }

  String _getUsernameFromEmail(String email) {
    // Split email by "@"
    List<String> parts = email.split("@");
    // Get the username part (before "@")
    String username = parts[0];
    return username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.menu,
              color: AppColor.subappcolor,
            )),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.smart_toy, size: 40, color: Colors.white)],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.circle_notifications),
            onPressed: () {},
            color: AppColor.subappcolor,
          ),
        ],
        centerTitle: true,
        backgroundColor: AppColor.mainAppColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 0,
              ), // Add space above the welcome messages
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'Welcome back,  ${_getUsernameFromEmail(email ?? "")}!',
                  style: TextStyle(
                    color: AppColor.mainAppColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              const SizedBox(height: 0),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  'How are you feeling today?',
                  style: TextStyle(
                    color: AppColor.mainAppColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(
                  height: 15), // Add space below the welcome messages
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Action to perform when the book icon is tapped
                            //Get.to(const VoicePage());
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.voice_chat,
                              size: 50,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Alan',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(width: 120),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            //  Get.to(SchuldePage(
                            //  userEmail: email ?? "",
                            // ));
                            print(email ?? "no");
                          },
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.all(10),
                            child: const Icon(
                              Icons.book_online,
                              size: 50,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Schedule',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Add space below the icons
              const SizedBox(height: 20.0), // Add space between the containers
              Center(
                child: Container(
                  width: 330.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 11, 10, 61),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Import video or image or file',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10.0),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button click
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 0, 0, 0)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          child: const Text('click here'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0), // Add space between the containers
              Center(
                child: Container(
                  width: 330.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 11, 10, 61),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue the bot conversation',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 10.0),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle button click
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          ),
                          child: const Text('chat bot'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
