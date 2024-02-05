import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: color4.withOpacity(0.8),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.r))),
      content: Text(
        'Si vous quittez maintenant, les modifications\neffectuées ne seront pas enregistrées',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.only(top: 10.h, bottom: 20.h),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            fixedSize: Size(100.w, 40.h),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
          child: Text(
            'Annuler',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFD32424),
            foregroundColor: Colors.white,
            fixedSize: Size(100.w, 40.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r),
            ),
            elevation: 20,
            shadowColor: Color(0xFFD32424),
          ),
          child: Text(
            'Quitter',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
