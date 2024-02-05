import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../const.dart';
import '../../../../main.dart';

class CustomProfilWelcome extends StatelessWidget {
  final void Function()? onTap;
  const CustomProfilWelcome({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.35,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 30.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
            color: color4.withOpacity(0.8),
            borderRadius: BorderRadius.circular(15.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                      color: color5, borderRadius: BorderRadius.circular(15.r)),
                  child: Icon(
                    Icons.person_outline_outlined,
                    color: Colors.white,
                  )),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: 'ID: ',
                    style: TextStyle(
                      color: Color(0xFF666680),
                      fontSize: 14.h,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.20,
                    )),
                TextSpan(
                    text: prefs.getString('user_id')?.toUpperCase(),
                    style: TextStyle(
                      color: Color(0xFFA2A2B5),
                      fontSize: 14.h,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.20,
                    )),
              ]),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: 'Nom: ',
                    style: TextStyle(
                      color: Color(0xFF666680),
                      fontSize: 14.h,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.20,
                    )),
                TextSpan(
                    text: prefs.getString('name_latin')?.toUpperCase(),
                    style: TextStyle(
                      color: Color(0xFFA2A2B5),
                      fontSize: 14.h,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.20,
                    )),
              ]),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: 'Prénom: ',
                    style: TextStyle(
                      color: Color(0xFF666680),
                      fontSize: 14.h,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.20,
                    )),
                TextSpan(
                    text: prefs.getString('surname_latin')?.toUpperCase(),
                    style: TextStyle(
                      color: Color(0xFFA2A2B5),
                      fontSize: 14.h,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.20,
                    )),
              ]),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: 'Né(e) le: ',
                    style: TextStyle(
                      color: Color(0xFF666680),
                      fontSize: 14.h,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.20,
                    )),
                TextSpan(
                    text: prefs.getString('birth_date')?.toUpperCase(),
                    style: TextStyle(
                      color: Color(0xFFA2A2B5),
                      fontSize: 14.h,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.20,
                    )),
              ]),
            ),
            Spacer(
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "NIN: ${prefs.getString('nin')?.toUpperCase()}",
                  style: TextStyle(
                    color: Color(0xFF666680),
                    fontSize: 12.h,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.20,
                  ),
                ),
                Image.asset(
                  "assets/images/finger_print.png",
                  height: 40.h,
                  width: 40.w,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
