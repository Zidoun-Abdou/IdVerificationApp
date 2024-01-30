import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCancelButton extends StatelessWidget {
  final void Function() onTap;
  const CustomCancelButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.white.withOpacity(0.10000000149011612),
        child: Icon(
          Icons.clear,
          color: Colors.white,
          size: 17.sp,
        ),
      ),
    );
  }
}
