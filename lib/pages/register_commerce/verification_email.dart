import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../const.dart';

class VerificationEmail extends StatefulWidget {
  final bool isVerificationEmail;
  const VerificationEmail({super.key, required this.isVerificationEmail});

  @override
  State<VerificationEmail> createState() => _VerificationEmailState();
}

class _VerificationEmailState extends State<VerificationEmail> {
  String otp = "";
  int _secondsRemaining = 120; // 2 minutes

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel(); // Cancel the timer when it reaches 0
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _secondsRemaining ~/ 60;
    int seconds = _secondsRemaining % 60;

    return Column(
      children: [
        Image.asset(
          "assets/images/logo_email.png",
          height: 90.h,
          width: 90.w,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 20.h),
        Visibility(
          visible: widget.isVerificationEmail,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verification d'adresse mail",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.1.h,
                  letterSpacing: 0.20.w,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(children: [
                  TextSpan(
                    text:
                        "Veuillez saisir le code SMS à 4 chiffres qui a été envoyé à\nvotre adresse mail ",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.1.h,
                      letterSpacing: 0.20.w,
                    ),
                  ),
                  TextSpan(
                    text: "test.12@gmail.com",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.1.h,
                      letterSpacing: 0.20.w,
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 30.h,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.w),
                child: PinFieldAutoFill(
                  // controller: _phoneContr,
                  codeLength: 4,
                  autoFocus: true,
                  textInputAction: TextInputAction.none,
                  // cursor: Cursor(color: color3, enabled: true),
                  decoration: UnderlineDecoration(
                    lineHeight: 2,
                    lineStrokeCap: StrokeCap.square,
                    textStyle: TextStyle(color: color3, fontSize: 20.sp),
                    bgColorBuilder: PinListenColorBuilder(color4, color4),
                    colorBuilder: FixedColorBuilder(color3),
                  ),
                  onCodeChanged: (code) {
                    otp = code.toString();
                    print(otp);
                  },
                ),
              ),
              SizedBox(height: 200.h),
              Text.rich(
                textAlign: TextAlign.center,
                TextSpan(children: [
                  TextSpan(
                    text: "Renvoyer le code dans ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.1.h,
                      letterSpacing: 0.20.w,
                    ),
                  ),
                  TextSpan(
                    text: '$minutes:${seconds < 10 ? '0$seconds' : '$seconds'}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.1.h,
                      letterSpacing: 0.20.w,
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        Visibility(
          visible: !widget.isVerificationEmail,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Lier votre email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.20,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Veuillez entrer l'adresse email que vous souhaitez associer à votre compte professionnel",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color6,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.20,
                ),
              ),
              SizedBox(height: 30.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  // controller: _emailContr,
                  cursorColor: color3,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.black),
                    hintText: "Adresse email",
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: BorderSide(
                        color: color3,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(50.r), // Set border radius
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                            .hasMatch(value)) {
                      return "Adresse e-mail non valide";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
