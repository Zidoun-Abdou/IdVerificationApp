import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/email.dart';
import 'package:whowiyati/pages/idcards.dart';
import 'package:whowiyati/pages/idinfos.dart';
import 'dart:convert';

import 'package:whowiyati/pages/otp.dart';
import 'package:whowiyati/pages/welcome.dart';

class Steps extends StatefulWidget {
  final String token;

  const Steps({Key? key, required this.token}) : super(key: key);

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  bool isLoading = false;
  bool isPhoneNumberValid = false;
  String countryCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: Form(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    // Replace with the actual path to your image file
                    fit: BoxFit.contain,
                    height: 100.h,
                    width: 200.w, // Adjust the image's fit property as needed
                  ),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Etapes vérifiées',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF00FF84),
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                    backgroundColor: color3,
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 30.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30.w,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Confirmation par téléphone\n',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.20,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Vérifié',
                                          style: TextStyle(
                                            color: Color(0xFF00FF84),
                                            fontSize: 12.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 30.h,
                                padding: EdgeInsets.only(left: 30.w),
                                child: VerticalDivider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        // prefs.containsKey('mail').toString() ==
                                        //         "null"
                                        // ? Colors.grey
                                        //     : color3
                                        prefs.containsKey('mail')
                                            ? color3
                                            : Colors.grey,
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 30.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30.w,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Confirmation par mail\n',
                                          style: TextStyle(
                                            color: // prefs.containsKey('mail').toString() ==
                                                //         "null"
                                                prefs.containsKey('mail')
                                                    ? Colors.white
                                                    : Colors.grey,
                                            fontSize: 15.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.20,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Vérifié',
                                          style: TextStyle(
                                            color: // prefs.containsKey('mail').toString() ==
                                                //         "null"
                                                prefs.containsKey('mail')
                                                    ? color3
                                                    : Colors.grey,
                                            fontSize: 12.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 30.h,
                                padding: EdgeInsets.only(left: 30.w),
                                child: VerticalDivider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CircleAvatar(
                                    backgroundColor:
                                        // prefs.getBool('visage') == true
                                        prefs.containsKey("visage")
                                            ? color3
                                            : Colors.grey,
                                    child: Icon(
                                      Icons.check_rounded,
                                      color: Colors.white,
                                      size: 30.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30.w,
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Confirmation par Id Card\n',
                                          style: TextStyle(
                                            color:
                                                // prefs.getBool('visage') == true
                                                prefs.containsKey("visage")
                                                    ? Colors.white
                                                    : Colors.grey,
                                            fontSize: 15.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.20,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Vérifié',
                                          style: TextStyle(
                                            color:
                                                // prefs.getBool('visage') == true
                                                prefs.containsKey("visage")
                                                    ? color3
                                                    : Colors.grey,
                                            fontSize: 12.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "Suivez ces étapes pour compléter la validation\n de votre identité",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.2.h,
                          letterSpacing: 0.20.w,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 8.h),
                        child: ElevatedButton(
                          onPressed: () {
                            if (prefs.getString('mail').toString() == "null") {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Email(
                                        token: widget.token,
                                      )));
                            } else if (prefs.getBool('visage') != true) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => IdCards()));
                            } else if (prefs.getString('idinfos').toString() !=
                                    "null" &&
                                prefs.getString('mail').toString() != "null") {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => IdInfos(),
                                ),
                              );
                            }
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
                              shadowColor: color3),
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
                  )),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
