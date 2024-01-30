import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNonIdentifie extends StatelessWidget {
  const CustomNonIdentifie({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5.sp),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10.r)),
      child: Text(
        "Non identifié",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
