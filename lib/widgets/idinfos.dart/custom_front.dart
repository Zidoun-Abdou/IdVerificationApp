import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFront extends StatelessWidget {
  const CustomFront({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.h,
      width: 320.w,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        image: DecorationImage(
            image: AssetImage("assets/images/flip1.png"), fit: BoxFit.cover),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Identité\nValidée',
              style: TextStyle(
                color: Color(0xFF00FF84),
                fontSize: 26.sp,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.20,
              ),
            ),
            Expanded(child: Text('')),
            Text(
              'Votre identité à été désormais validée \navec succéss.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.5.h,
                letterSpacing: 0.20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
