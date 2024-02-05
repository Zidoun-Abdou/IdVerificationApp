import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../main.dart';


class CustomIdentifientWelcome extends StatelessWidget {
  const CustomIdentifientWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "ID : ${prefs.getString("user_id")}",
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFFA2A2B5),
        fontSize: 20.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.bold,
        letterSpacing: 0.20,
      ),
    );
  }
}
