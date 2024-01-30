import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAlign extends StatelessWidget {
  const CustomAlign({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 30.h,
        padding: EdgeInsets.only(left: 30.w),
        child: VerticalDivider(
          color: Colors.grey,
          thickness: 1,
        ),
      ),
    );
  }
}
