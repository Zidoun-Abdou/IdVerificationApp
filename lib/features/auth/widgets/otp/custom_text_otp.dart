import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextOtp extends StatelessWidget {
  final String data;
  final Color color;
  final double size;
  const CustomTextOtp(
      {super.key, required this.data, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: size.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 1.1.h,
        letterSpacing: 0.20.w,
      ),
    );
  }
}
