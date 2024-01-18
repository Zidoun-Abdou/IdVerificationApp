import 'dart:convert';
import 'dart:io';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../const.dart';
import '../widgets/adaptive_circular_progress_indicator.dart';
import 'recto.dart';

class IdCards extends StatefulWidget {
  const IdCards({Key? key}) : super(key: key);

  @override
  State<IdCards> createState() => _IdCardsState();
}

class _IdCardsState extends State<IdCards> {
  bool? _is_loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: Center(
          child: _is_loading == true
              ? AdaptiveCircularProgressIndicator(color: color3)
              : Form(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
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
                                width: 150.w,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: Text(
                                "Pour vérifier votre carte d’identité la caméra du téléphone va se lancer vous permettant de scanner le recto et le verso  de votre carte d’identité",
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
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset(
                              'assets/images/id_card.png',
                              // Replace with the actual path to your image file
                              fit: BoxFit.fill,
                            ).animate().fade(delay: 1000.ms),
                            Positioned(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 8.h),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Recto()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color3,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.h),
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
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
