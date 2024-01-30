import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextPro extends StatelessWidget {
  final String data;
  final Color color;
  final double size;
  final FontWeight? fontWeight;
  const CustomTextPro(
      {super.key,
      required this.data,
      required this.color,
      required this.size,
      this.fontWeight = FontWeight.w400});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: size.sp,
        fontFamily: 'Inter',
        fontWeight: fontWeight,
        height: 1.1.h,
        letterSpacing: 0.20.w,
      ),
    );
  }
}
