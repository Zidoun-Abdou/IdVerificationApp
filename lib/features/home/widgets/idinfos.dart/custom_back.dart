import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../main.dart';

class CustomBack extends StatelessWidget {
  const CustomBack({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.h,
      width: 320.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        image: DecorationImage(
            image: AssetImage("assets/images/flip2.png"), fit: BoxFit.cover),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text.rich(
                          maxLines: 1,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Nom: ',
                                style: TextStyle(
                                  color: Color(0xFF00FF84),
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.20,
                                ),
                              ),
                              TextSpan(
                                text: prefs
                                    .getString('name_latin')
                                    ?.toUpperCase(),
                                style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text.rich(
                          maxLines: 1,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Prénom: ',
                                style: TextStyle(
                                  color: Color(0xFF00FF84),
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.20,
                                ),
                              ),
                              TextSpan(
                                text: prefs
                                    .getString('surname_latin')
                                    ?.toUpperCase(),
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
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
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text.rich(
                          maxLines: 1,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Né(e) le: ',
                                style: TextStyle(
                                  color: Color(0xFF00FF84),
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.20,
                                ),
                              ),
                              TextSpan(
                                text: prefs
                                    .getString('birth_date')
                                    ?.toUpperCase(),
                                style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text.rich(
                          maxLines: 1,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Crée le: ',
                                style: TextStyle(
                                  color: Color(0xFF00FF84),
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.20,
                                ),
                              ),
                              TextSpan(
                                text: prefs
                                        .getString('deliv_date')
                                        ?.toUpperCase() ??
                                    "",
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
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
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text.rich(
                          maxLines: 1,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Expire le: ',
                                style: TextStyle(
                                  color: Color(0xFF00FF84),
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.20,
                                ),
                              ),
                              TextSpan(
                                text: prefs
                                        .getString('exp_date')
                                        ?.toUpperCase() ??
                                    "",
                                style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text.rich(
                          maxLines: 1,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Carte N°: ',
                                style: TextStyle(
                                  color: Color(0xFF00FF84),
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.20,
                                ),
                              ),
                              TextSpan(
                                text: prefs
                                    .getString('document_number')
                                    ?.toUpperCase(),
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
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
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Nin: ',
                          style: TextStyle(
                            color: Color(0xFF00FF84),
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 3.39,
                            letterSpacing: 0.20,
                          ),
                        ),
                        TextSpan(
                          text: prefs.getString('nin')?.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 3.39,
                            letterSpacing: 0.20,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
