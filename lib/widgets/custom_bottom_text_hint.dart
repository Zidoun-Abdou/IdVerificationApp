import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomTextHint extends StatelessWidget {
  const CustomBottomTextHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Votre application d’indentification',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF666680),
        fontSize: 12.h,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w500,
        letterSpacing: 0.20,
      ),
    );
  }
}
