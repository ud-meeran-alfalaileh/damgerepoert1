import 'package:damgerepoert/config/theme/theme.dart';
import 'package:damgerepoert/core/widget/text.dart';
import 'package:damgerepoert/features/buttons_page/buttons_page.dart';
import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColor.mainAppColor,
        body: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ButtonsPage()),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  const SizedBox(width: 75),
                  TextApp.splashAppText('Damge Report'),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
