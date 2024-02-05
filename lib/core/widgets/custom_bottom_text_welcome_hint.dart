
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomTextWelcomeHint extends StatelessWidget {
  const CustomBottomTextWelcomeHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Bienvenue sur Whowiaty\nVotre application d’identification\net de signature électronique en ligne",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 12.5.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 1.1.h,
        letterSpacing: 0.20.w,
      ),
    );
  }
}
