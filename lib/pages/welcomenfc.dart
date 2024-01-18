import 'dart:convert';
import 'dart:io';
import 'package:dmrtd/dmrtd.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../const.dart';
import '../widgets/adaptive_circular_progress_indicator.dart';
import 'readnfc.dart';

class WelcomeNfc extends StatefulWidget {
  final String dob;
  final String doe;
  final String idnumber;
  final String face;
  final String front;
  final String back;
  final String signature;

  const WelcomeNfc(
      {Key? key,
      required this.dob,
      required this.doe,
      required this.idnumber,
      required this.face,
      required this.front,
      required this.back,
      required this.signature})
      : super(key: key);

  @override
  State<WelcomeNfc> createState() => _WelcomeNfcState();
}

class _WelcomeNfcState extends State<WelcomeNfc> {
  bool? _is_loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: Center(
          child: _is_loading == true
              ? AdaptiveCircularProgressIndicator(color: color3)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: Text(
                        "Cette action nécessite l’activation de l’NFC",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.20.w,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/nfcphone.png',
                      // Replace with the actual path to your image file
                      fit: BoxFit.fill,
                    )
                        .animate()
                        .fade(delay: 1000.ms)
                        .moveY(delay: 1000.ms, end: 1, begin: 500),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReadNfc(
                                    dob: widget.dob,
                                    doe: widget.doe,
                                    idnumber: widget.idnumber,
                                    face: widget.face,
                                    back: widget.back,
                                    front: widget.front,
                                    signature: widget.signature,
                                  )));
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
