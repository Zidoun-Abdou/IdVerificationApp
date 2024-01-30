import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/pages/conditions.dart';
import 'package:whowiyati/pages/login.dart';

import '../widgets/custom_image_background.dart';
import '../widgets/custom_image_logo.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomImageBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
                child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomImageLogo(width: 200),
                ),
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 8.h),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Login()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              foregroundColor: Colors.white,
                              minimumSize: Size.fromHeight(30.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              // Set the shadow color
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_outline_outlined),
                                Text(
                                  ' Mon compte',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 8.h),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Conditions()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color3,
                              padding: EdgeInsets.symmetric(vertical: 15.h),
                              foregroundColor: Colors.white,
                              minimumSize: Size.fromHeight(30.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              elevation: 20,
                              shadowColor: color3, // Set the shadow color
                            ),
                            child: Text(
                              "S'inscrire",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "En vous inscrivant, vous acceptez nos conditions\nd'utilisation. Découvrez comment nous collectons,\nutilisons et partageons vos données.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12.5.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.1.h,
                            letterSpacing: 0.20.w,
                          ),
                        ),
                      ],
                    ))
              ],
            )),
          ),
        ),
      ],
    );
  }
}
