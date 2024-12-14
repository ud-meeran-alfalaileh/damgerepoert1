import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/backend/authentication.dart';
import 'package:damgerepoert/features/intropage/intropage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => Get.put(AuthenticationRepository()));

  await Supabase.initialize(
    url: 'https://rswjzvujasbepihbdvwu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJzd2p6dnVqYXNiZXBpaGJkdnd1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQxNzUzMzIsImV4cCI6MjA0OTc1MTMzMn0.E4zy3xihy72JxrLBEmZfAya5_vzyRaSf5_6r-TS4Dik',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Damge Report',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.subappcolor),
        useMaterial3: true,
      ),
      home: const IntroPage(),
    );
  }
}
