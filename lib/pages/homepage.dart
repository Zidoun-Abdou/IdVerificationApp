import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/login.dart';
import 'package:whowiyati/pages/register.dart';
import 'package:whowiyati/pages/steps.dart';
import 'package:whowiyati/pages/welcome.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color2,
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Expanded(
              flex: 2,
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
                flex: 1,
                child: Column(
                  children: [
                    Text(
                      "Bienvenue sur Whowiaty\nVotre application d’identification\net de signature électronique en ligne",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
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
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Register()));
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
                          'Commencer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[850],
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          foregroundColor: Colors.white,
                          minimumSize: Size.fromHeight(30.w),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          // Set the shadow color
                        ),
                        child: Text(
                          'Déjà identifié',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
          ],
        )),
      ),
    );
  }
}
