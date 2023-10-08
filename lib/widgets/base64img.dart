import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Base64ImageWidget extends StatelessWidget {
  final String base64String;
  final int width;

  Base64ImageWidget({required this.base64String, this.width =300});

  @override
  Widget build(BuildContext context) {
    return Image.memory(
      width: width.w,
      base64Decode(base64String),
      fit: BoxFit.contain,
    );
  }
}
