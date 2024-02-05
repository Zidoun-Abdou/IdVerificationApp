import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomImageLogo extends StatelessWidget {
  final double? width;
  const CustomImageLogo({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/logo.png',
        // Replace with the actual path to your image file
        fit: BoxFit.contain,
        width: width!.w, // Adjust the image's fit property as needed
      ),
    );
  }
}
