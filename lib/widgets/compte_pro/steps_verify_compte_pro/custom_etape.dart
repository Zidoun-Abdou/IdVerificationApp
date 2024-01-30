import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const.dart';

class CustomEtape extends StatelessWidget {
  final bool condition;
  final String title;
  const CustomEtape({super.key, required this.condition, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: CircleAvatar(
            backgroundColor: condition ? color3 : Colors.grey,
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 30.sp,
            ),
          ),
        ),
        SizedBox(
          width: 30.w,
        ),
        Expanded(
          flex: 3,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: TextStyle(
                    color: condition ? Colors.white : Colors.grey,
                    fontSize: 13.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.20,
                  ),
                ),
                TextSpan(
                  text: 'Vérifié',
                  style: TextStyle(
                    color: condition ? color3 : Colors.grey,
                    fontSize: 12.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.20,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
