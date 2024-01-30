import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../const.dart';

class CustomCheckboxConditions extends StatelessWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  const CustomCheckboxConditions(
      {super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.grey,
          ),
          child: Checkbox(
            checkColor: color3,
            activeColor: Colors.black,
            value: value,
            onChanged: onChanged,
          ),
        ),
        GestureDetector(
          onTap: () async {
            await launchUrl(Uri.parse(
                "https://icosnet.com.dz/conditions-dutilisation-application-whowiyati/"));
          },
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Condition générales',
                  style: TextStyle(
                    color: Color(0xFF23D27E),
                    fontSize: 13.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.20,
                  ),
                ),
                TextSpan(
                  text: ' et politique \nde respect de la vie privée.',
                  style: TextStyle(
                    color: Color(0xFF666680),
                    fontSize: 13.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.20,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
