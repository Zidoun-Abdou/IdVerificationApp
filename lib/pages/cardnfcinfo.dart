import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';

import '../main.dart';
import '../widgets/base64img.dart';

class CardNfcInfo extends StatefulWidget {
  const CardNfcInfo({super.key});

  @override
  State<CardNfcInfo> createState() => _CardNfcInfoState();
}

class _CardNfcInfoState extends State<CardNfcInfo> {
  bool _isAr = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
          child: Center(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 30.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Text(
              "Validation Via NFC",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.20.w,
              ),
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/Group 131.png"),
                    fit: BoxFit.fill),
              ),
              child: Column(
                children: [
                  Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Base64ImageWidget(
                            width: 60,
                            base64String: prefs.getString('face').toString(),
                          ),
                          Visibility(
                            visible: !_isAr,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Personal Data',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.sp,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.20,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Ar',
                                      style: TextStyle(
                                        color: color3,
                                        fontSize: 12.sp,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.20,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          setState(() {
                                            _isAr = true;
                                          });
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: _isAr,
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'بيانات شخصية',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.20,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Fr',
                                      style: TextStyle(
                                        color: color3,
                                        fontSize: 12.sp,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.20,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          setState(() {
                                            _isAr = false;
                                          });
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: !_isAr,
                          child: Text(
                            'Nom: ' +
                                prefs.getString('surname_latin').toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _isAr,
                          child: Text(
                            'اللقب : ' +
                                prefs.getString('surname_arabic').toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Visibility(
                          visible: !_isAr,
                          child: Text(
                            'Prénom: ' +
                                prefs.getString('name_latin').toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _isAr,
                          child: Text(
                            'االاسم :' +
                                prefs.getString('name_arabic').toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Directionality(
                      textDirection:
                          _isAr ? TextDirection.rtl : TextDirection.ltr,
                      child: Row(
                        children: [
                          Text(
                            _isAr
                                ? 'تاريخ الميلاد : ' +
                                    prefs.getString('birth_date').toString()
                                : 'Date de naissance : ' +
                                    prefs.getString('birth_date').toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _isAr ? 14.sp : 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Directionality(
                      textDirection:
                          _isAr ? TextDirection.rtl : TextDirection.ltr,
                      child: Row(
                        children: [
                          Text(
                            _isAr
                                ? 'رقم التعريف الوطني: ' +
                                    prefs.getString('nin').toString()
                                : 'NIN : ' + prefs.getString('nin').toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _isAr ? 14.sp : 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Directionality(
                      textDirection:
                          _isAr ? TextDirection.rtl : TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _isAr
                                ? 'رقم البطاقة :' +
                                    prefs
                                        .getString('document_number')
                                        .toString()
                                : 'Numéro de la carte :' +
                                    prefs
                                        .getString('document_number')
                                        .toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _isAr ? 14.sp : 11.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Directionality(
                            textDirection:
                                _isAr ? TextDirection.rtl : TextDirection.ltr,
                            child: Text(
                              _isAr
                                  ? 'زمرة الدم: ' +
                                      prefs.getString('blood_type').toString()
                                  : 'Groupe sanguin: ' +
                                      prefs.getString('blood_type').toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: _isAr ? 14.sp : 11.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isAr
                              ? 'الجنس: ' +
                                  prefs.getString('sex_arabic').toString()
                              : 'Sexe: ' +
                                  prefs.getString('sexe_latin').toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _isAr ? 14.sp : 11.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.20,
                          ),
                        ),
                        Text(
                          _isAr
                              ? 'مكان الميلاد : ' +
                                  prefs
                                      .getString('birthplace_arabic')
                                      .toString()
                              : 'Lieu de naissance : ' +
                                  prefs
                                      .getString('birthplace_latin')
                                      .toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: _isAr ? 14.sp : 11.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Directionality(
                      textDirection:
                          _isAr ? TextDirection.rtl : TextDirection.ltr,
                      child: Row(
                        children: [
                          Text(
                            _isAr
                                ? 'تاريخ الإصدار : ' +
                                    prefs.getString('deliv_date').toString()
                                : 'Date d\'émission : ' +
                                    prefs.getString('deliv_date').toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _isAr ? 14.sp : 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Directionality(
                      textDirection:
                          _isAr ? TextDirection.rtl : TextDirection.ltr,
                      child: Row(
                        children: [
                          Text(
                            _isAr
                                ? 'تاريخ الإنتهاء : ' +
                                    prefs.getString('exp_date').toString()
                                : 'Date d\'expiration : ' +
                                    prefs.getString('exp_date').toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _isAr ? 14.sp : 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _isAr,
                    child: Expanded(
                      flex: 1,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            Text(
                              'سلطة الإصدار: ' +
                                  prefs.getString('baladia_arab').toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: !_isAr,
                    child: Expanded(
                      flex: 1,
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Row(
                          children: [
                            Text(
                              'Délivré à : ' +
                                  prefs.getString('baladia_latin').toString(),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Directionality(
                      textDirection:
                          _isAr ? TextDirection.rtl : TextDirection.ltr,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isAr ? 'التوقيع: ' : 'La signature: ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: _isAr ? 14.sp : 12.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20,
                            ),
                          ),
                          Base64ImageWidget(
                            width: 100,
                            base64String:
                                prefs.getString('signature').toString(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
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
                shadowColor: color3, // Set the shadow color
              ),
              child: Text(
                'Retourner',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
        ]),
      )),
    );
  }
}
