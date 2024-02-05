import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../main.dart';

class CustomTitleWelcome extends StatelessWidget {
  const CustomTitleWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Text(
        '${prefs.getString('name_latin').toString()[0].toUpperCase()}${prefs.getString('name_latin').toString().substring(1).toLowerCase()}',
        style: TextStyle(
          color: Colors.white,
          fontSize: 35.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
