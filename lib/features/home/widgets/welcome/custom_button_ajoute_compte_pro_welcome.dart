import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../main.dart';

class CustomButtonAjouteCompteProWelcome extends StatelessWidget {
  final void Function()? onTap;
  const CustomButtonAjouteCompteProWelcome({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(0.10000000149011612),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.50),
            borderRadius: BorderRadius.circular(50.r),
          ),
        ),
        child: Text(
          'Ajoutez Compte PRO',
          textAlign: TextAlign.right,
          style: TextStyle(
            color:
                prefs.getString('status') == "5" ? Colors.white : Colors.grey,
            fontSize: 12.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
