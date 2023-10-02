import 'dart:convert';
import 'dart:io';
import 'package:dmrtd/dmrtd.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/idinfos.dart';
import 'package:whowiyati/pages/readnfc.dart';
import 'package:whowiyati/pages/recto.dart';
import 'package:whowiyati/pages/verify_face.dart';

class WelcomeNfc extends StatefulWidget {
  final String token;

  const WelcomeNfc({Key? key, required this.token}) : super(key: key);

  @override
  State<WelcomeNfc> createState() => _WelcomeNfcState();
}

class _WelcomeNfcState extends State<WelcomeNfc> {
  bool? _is_loading = false;
  @override
  void initState() {
    super.initState();
    getNfcStatus();
  }

  getNfcStatus() async {
    NfcStatus status = await NfcProvider.nfcStatus;
    print("//////////////////////////////////");
    print(status.toString());
    print("//////////////////////////////////");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: Center(
          child: _is_loading == true
              ? CircularProgressIndicator()
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
                                    dob: '07/04/1963',
                                    doe: '10/18/2026',
                                    docNumber: '101427617',
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
