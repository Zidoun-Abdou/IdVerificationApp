import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBonjourWelcome extends StatelessWidget {
  const CustomBonjourWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: "Bonjour",
            style: TextStyle(
              color: Colors.white,
              fontSize: 35.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: '.',
            style: TextStyle(
              color: Color(0xFF1FD15C),
              fontSize: 40,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
