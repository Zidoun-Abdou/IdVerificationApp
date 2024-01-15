import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:whowiyati/pages/otp.dart';
import 'package:whowiyati/pages/steps.dart';
import 'package:whowiyati/pages/welcome.dart';

/*class PhoneOk extends StatefulWidget {
  const PhoneOk({Key? key}) : super(key: key);

  @override
  State<PhoneOk> createState() => _PhoneOkState();
}

class _PhoneOkState extends State<PhoneOk> {
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _phoneContr = TextEditingController();
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
                flex: 3,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        // Replace with the actual path to your image file
                        fit: BoxFit.contain,
                        height: 150.h,
                        width: 250.w, // Adjust the image's fit property as needed
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      "Validation du numéro de téléphone",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.1.h,
                        letterSpacing: 0.20.w,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Nous utilisons votre numéro de téléphone pour vous\n identifier.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.1.h,
                        letterSpacing: 0.20.w,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.verified_outlined,color: color3,size: 50.sp,),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 8.h),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => Steps(token: widget.,)));
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
}*/
