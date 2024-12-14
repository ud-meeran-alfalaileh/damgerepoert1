import 'package:damgerepoert/config/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buttons {
  static selectedButton(
      String text, Function()? onTap, Color color, Color textColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 146,
        height: 46,
        decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(Radius.circular(7))),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              fontSize: 15,
              color: textColor,
            )),
          ),
        ),
      ),
    );
  }

  static GestureDetector formscontainer(
      {required String title, required Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColor.mainAppColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color:
                    const Color.fromARGB(255, 221, 212, 212).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Center(
          child: Text(title,
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: AppColor.subappcolor))),
        ),
      ),
    );
  }
}
