import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../const.dart';

class CustomNotifWelcome extends StatelessWidget {
  const CustomNotifWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: 10.h, left: 15.w, bottom: 10.h, right: 10.w),
      alignment: Alignment.center,
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.10000000149011612),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/images/notif.svg",
            height: 20.h,
          ),
          SizedBox(
            height: 20.h,
            child: CircleAvatar(
              backgroundColor: color5,
              child: Text(
                "0",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
