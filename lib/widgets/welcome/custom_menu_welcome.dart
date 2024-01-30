import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../const.dart';
import 'custom_cancel_button.dart';

class CustomMenuWelcome extends StatelessWidget {
  final void Function()? onDemandeValid;
  final void Function()? onLogout;
  const CustomMenuWelcome(
      {super.key, required this.onDemandeValid, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.88,
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Paramètre",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.20,
                  ),
                ),
                CustomCancelButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
            Positioned(
              top: 60.h,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: onDemandeValid,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color8,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      minimumSize: Size.fromHeight(30.w),
                      maximumSize: Size.fromHeight(60.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SvgPicture.asset(
                              "assets/images/demande_validation.svg"),
                        ),
                        Positioned(
                          left: 70.w,
                          right: 0.w,
                          child: Text(
                            'Mes Demandes de Validation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20.h,
              left: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: onLogout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color7,
                  elevation: 0,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                  minimumSize: Size.fromHeight(30.w),
                  maximumSize: Size.fromHeight(60.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset("assets/images/logout.svg"),
                    ),
                    Positioned(
                      left: 70.w,
                      right: 0.w,
                      child: Text(
                        'Se déconnecter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
