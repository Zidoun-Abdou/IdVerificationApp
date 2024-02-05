import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const.dart';

class CustomTextFormField extends StatelessWidget {
  final TextInputAction? textInputAction;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextStyle? style;
  final bool obscureText;
  final int? maxLength;
  final String? Function(String?)? validator;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final TextStyle? counterStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;
  const CustomTextFormField(
      {super.key,
      required this.textInputAction,
      required this.controller,
      required this.keyboardType,
      required this.style,
      this.validator,
      this.obscureText = false,
      required this.hintText,
      required this.hintStyle,
      required this.fillColor,
      required this.prefixIcon,
      this.suffixIcon,
      this.maxLength,
      this.counterStyle,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: textInputAction,
      controller: controller,
      cursorColor: color3,
      keyboardType: keyboardType,
      style: style,
      obscureText: obscureText,
      obscuringCharacter: "*",
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintStyle: hintStyle,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: fillColor,
        counterStyle: counterStyle,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r),
          borderSide: BorderSide(color: color3),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r), // Set border radius
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(50.r),
        ),
      ),
    );
  }
}
