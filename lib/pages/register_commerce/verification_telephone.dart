import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:whowiyati/const.dart';

class VerificationTelephone extends StatefulWidget {
  final bool isVerificationNum;
  const VerificationTelephone({super.key, required this.isVerificationNum});

  @override
  State<VerificationTelephone> createState() => _VerificationTelephoneState();
}

class _VerificationTelephoneState extends State<VerificationTelephone> {
  bool isPhoneNumberValid = false;
  String countryCode = "";
  String otp = "";
  bool _utiliseNum = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: widget.isVerificationNum,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Verification du numéro de téléphone",
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
                        "Veuillez saisir le code SMS à 4 chiffres qui a été\nenvoyé à ",
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
                    text: "+213 699 673 374",
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
            ],
          ),
        ),
        Visibility(
          visible: !widget.isVerificationNum,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Saisissez votre numéro de téléphone professionnel",
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
                "Nous utilisons votre numéro de téléphone pour créer\nvotre compte professionnel",
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
              Visibility(
                visible: _utiliseNum,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0C23F1),
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          foregroundColor: Colors.white,
                          minimumSize: Size.fromHeight(30.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          // elevation: 20,s
                          // shadowColor: Color(0xFF0C23F1),
                        ),
                        child: Text(
                          '+213 699 673 374',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          foregroundColor: Colors.white,
                          minimumSize: Size.fromHeight(30.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                            side: BorderSide(),
                          ),
                          // elevation: 20,
                          // shadowColor: Color(0xFF0C23F1),
                        ),
                        child: Text(
                          '+213 699 673 374',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !_utiliseNum,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: IntlPhoneField(
                        autofocus: false,
                        textInputAction: TextInputAction.done,
                        // controller: _phoneContr,
                        cursorColor: color3,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: "Numero de téléphone",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.r),
                            borderSide: BorderSide(
                              color: color3,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                50.r), // Set border radius
                          ),
                        ),
                        invalidNumberMessage: "Numéro de Téléphone non valide",
                        initialCountryCode: 'DZ',
                        dropdownIcon: Icon(
                          Icons.arrow_drop_down,
                          color: color3,
                        ),
                        onChanged: (phone) {
                          if (phone.completeNumber.length == 13) {
                            setState(() {
                              isPhoneNumberValid = true;
                              countryCode = phone.countryCode.substring(1);
                              print(countryCode);
                            });
                          } else {
                            setState(() {
                              isPhoneNumberValid = false;
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 200.h),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _utiliseNum = !_utiliseNum;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF120918),
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        foregroundColor: Colors.white,
                        minimumSize: Size.fromHeight(30.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        elevation: 20,
                        shadowColor: Color(0xFF120918),
                      ),
                      child: Text(
                        'Utiliser un numéro existant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
