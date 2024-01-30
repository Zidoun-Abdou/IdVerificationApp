import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const.dart';
import '../../main.dart';

class CustomSouvenirMoiCheckbox extends StatelessWidget {
  final void Function(bool?)? onChanged;
  const CustomSouvenirMoiCheckbox({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.grey,
          ),
          child: Checkbox(
            checkColor: color3,
            activeColor: Colors.black,
            value: prefs.getBool("isRememberMe") ?? false,
            onChanged: onChanged,
          ),
        ),
        Text(
          'Se souvenir de moi',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
