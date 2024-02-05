import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const.dart';

class CustomQuestionShowBottomSheet extends StatelessWidget {
  final String questionText;
  final void Function()? onAccepte;
  final void Function()? onRefus;
  const CustomQuestionShowBottomSheet(
      {super.key,
      required this.questionText,
      required this.onAccepte,
      required this.onRefus});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Text(
            questionText,
            style: TextStyle(color: Colors.white),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: onAccepte,
              child: Text("Oui"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: color3,
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  elevation: 10,
                  shadowColor: color3),
            ),
            ElevatedButton(
              onPressed: onRefus,
              child: Text("Non"),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  elevation: 10,
                  shadowColor: Colors.red),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
