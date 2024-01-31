import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../const.dart';

class CustomIntlPhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool autofocus;
  final Color styleColor;
  final Color fillColor;
  final TextStyle? dropdownTextStyle;
  final void Function(PhoneNumber)? onChanged;
  final FutureOr<String?> Function(PhoneNumber?)? validator;
  final String? invalidNumberMessage;
  const CustomIntlPhoneField(
      {super.key,
      required this.controller,
      required this.autofocus,
      required this.styleColor,
      required this.fillColor,
      required this.onChanged,
      this.validator,
      this.dropdownTextStyle,
      this.invalidNumberMessage});

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      autofocus: autofocus,
      textInputAction: TextInputAction.done,
      controller: controller,
      cursorColor: color3,
      style: TextStyle(color: styleColor),
      decoration: InputDecoration(
        hintStyle: TextStyle(color: styleColor),
        hintText: "Numero de téléphone",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r),
          borderSide: BorderSide(
            color: color3,
          ),
        ),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r), // Set border radius
        ),
      ),
      invalidNumberMessage: invalidNumberMessage,
      initialCountryCode: 'DZ',
      dropdownTextStyle: dropdownTextStyle,
      dropdownIcon: Icon(
        Icons.arrow_drop_down,
        color: color3,
      ),
      validator: validator,
      onChanged: onChanged,
    );
  }
}
