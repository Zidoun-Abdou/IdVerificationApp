import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../const.dart';
import 'etape_verification_compte_pro.dart';

class VerificationTelephone extends StatefulWidget {
  final ValueNotifier<int> currentEtapeValueNotifier;
  final ValueNotifier<bool> etape1ValueNotifier;
  const VerificationTelephone(
      {super.key,
      required this.currentEtapeValueNotifier,
      required this.etape1ValueNotifier});

  @override
  State<VerificationTelephone> createState() => _VerificationTelephoneState();
}

class _VerificationTelephoneState extends State<VerificationTelephone> {
  bool isVerificationNum = false;
  bool isPhoneNumberValid = false;
  String countryCode = "";
  String otp = "";
  bool _utiliseNum = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: isVerificationNum,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
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
                            textStyle:
                                TextStyle(color: color3, fontSize: 20.sp),
                            bgColorBuilder:
                                PinListenColorBuilder(color4, color4),
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
                Positioned(
                  bottom: 20.h,
                  right: 0,
                  left: 0,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.currentEtapeValueNotifier.value = 0;
                      widget.etape1ValueNotifier.value = true;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color3,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(30.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      elevation: 20,
                      shadowColor: color3,
                    ),
                    child: Text(
                      'Continuer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: !isVerificationNum,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
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
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
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
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: Stack(
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
                                  invalidNumberMessage:
                                      "Numéro de Téléphone non valide",
                                  initialCountryCode: 'DZ',
                                  dropdownIcon: Icon(
                                    Icons.arrow_drop_down,
                                    color: color3,
                                  ),
                                  onChanged: (phone) {
                                    if (phone.completeNumber.length == 13) {
                                      setState(() {
                                        isPhoneNumberValid = true;
                                        countryCode =
                                            phone.countryCode.substring(1);
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
                              Positioned(
                                bottom: 130.h,
                                right: 0,
                                left: 0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _utiliseNum = !_utiliseNum;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF120918),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.h),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 60.h,
                  right: 0,
                  left: 0,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isVerificationNum = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color3,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(30.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      elevation: 20,
                      shadowColor: color3,
                    ),
                    child: Text(
                      'Continuer',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.currentEtapeValueNotifier.value = 0;
                      widget.etape1ValueNotifier.value = true;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      foregroundColor: Colors.white,
                      minimumSize: Size.fromHeight(30.w),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: color3, width: 1),
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                    ),
                    child: Text(
                      'Passer l\'étape',
                      style: TextStyle(
                        color: color3,
                        fontSize: 15.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
