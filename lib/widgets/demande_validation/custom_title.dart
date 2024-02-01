import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTitle extends StatelessWidget {
  final Color color;
  final String data;
  const CustomTitle({super.key, required this.color, required this.data});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
            text: 'ID : ',
            style: TextStyle(
              color: color,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            )),
        TextSpan(
            text: data,
            style: TextStyle(
              color: color,
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ))
      ]),
    );
  }
}
