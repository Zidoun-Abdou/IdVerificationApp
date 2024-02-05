import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../const.dart';
import '../../../../main.dart';

class CustomWelcomeItem extends StatelessWidget {
  final void Function()? onTap;
  final String icon;
  final String title;
  const CustomWelcomeItem(
      {super.key, this.onTap, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.width / 2 - 10.h - 10.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
            color: color4.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38.w,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                  color:
                      prefs.getString('status') == "5" ? color5 : Colors.grey,
                  borderRadius: BorderRadius.circular(15.r)),
              child: SvgPicture.asset(
                "assets/images/$icon.svg",
                height: 20.h,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 15.sp, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
