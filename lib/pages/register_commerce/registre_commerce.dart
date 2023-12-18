import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/pages/register_commerce/recto_rc.dart';

class RegisterCommerce extends StatefulWidget {
  const RegisterCommerce({super.key});

  @override
  State<RegisterCommerce> createState() => _RegisterCommerceState();
}

class _RegisterCommerceState extends State<RegisterCommerce> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 150.h,
                width: 150.w,
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(30.w),
                      child: Text(
                        "Pour vérifier votre registre de commerce la caméra du téléphone va se lancer vous permettant au début de scanner le recto et le verso  de votre registre de commerce",
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
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => RectoRC()));
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
                          'Prendre une photo',
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
                ))
          ],
        ),
      ),
    );
  }
}
