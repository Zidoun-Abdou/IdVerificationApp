import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTitleConditions extends StatelessWidget {
  const CustomTitleConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "En continuant, vous confirmez avoir lu et \n approuvé les conditions générales et la \n politique de respect de la vie privée de \n Whowiaty",
        style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.3,
            letterSpacing: 0.20),
        textAlign: TextAlign.center,
      ),
    );
  }
}
