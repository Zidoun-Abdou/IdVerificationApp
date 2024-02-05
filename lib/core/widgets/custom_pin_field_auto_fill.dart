import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../const.dart';

class CustomPinFieldAutoFill extends StatelessWidget {
  final bool autoFocus;
  final dynamic Function(String?)? onCodeChanged;
  const CustomPinFieldAutoFill(
      {super.key, this.autoFocus = false, required this.onCodeChanged});

  @override
  Widget build(BuildContext context) {
    return PinFieldAutoFill(
      autoFocus: autoFocus,
      codeLength: 4,
      textInputAction: TextInputAction.done,
      // cursor: Cursor(color: color3,enabled: true),
      decoration: UnderlineDecoration(
        lineHeight: 2,
        lineStrokeCap: StrokeCap.square,
        textStyle: TextStyle(color: color3, fontSize: 20.sp),
        bgColorBuilder: PinListenColorBuilder(color4, color4),
        colorBuilder: FixedColorBuilder(color3),
      ),
      onCodeChanged: onCodeChanged,
    );
  }
}
