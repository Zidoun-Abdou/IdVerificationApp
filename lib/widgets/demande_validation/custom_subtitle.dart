import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const.dart';

class CustomSubtitle extends StatelessWidget {
  final String text;
  final String data;
  const CustomSubtitle({super.key, required this.text, required this.data});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
            text: text,
            style: TextStyle(
              color: color9,
              fontSize: 15.sp,
            )),
        TextSpan(
            text: data,
            style: TextStyle(
              color: color9,
              fontSize: 15.sp,
            ))
      ]),
    );
  }
}
