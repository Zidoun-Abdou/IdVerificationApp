import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/pages/register_commerce/verification_email.dart';
import 'package:whowiyati/pages/register_commerce/verification_telephone.dart';

import 'etape_verification_compte_pro.dart';

class AjouterComptePro extends StatefulWidget {
  const AjouterComptePro({super.key});

  @override
  State<AjouterComptePro> createState() => _AjouterCompteProState();
}

class _AjouterCompteProState extends State<AjouterComptePro> {
  bool etape1 = true;
  bool etape2 = false;
  bool etape3 = false;
  bool etape4 = false;

  int currentEtape = 1;

  bool isVerificationNum = false;
  bool isVerificationEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    height: MediaQuery.of(context).size.height / 2.3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: color1,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 1,
                            ),
                            Text(
                              "My account",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFA2A2B5),
                                fontSize: 16.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20,
                              ),
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Bonjour",
                                //text: 'Hello\n${prefs.getString('idinfos').toString()}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              TextSpan(
                                text: '.',
                                style: TextStyle(
                                  color: Color(0xFF1FD15C),
                                  fontSize: 40,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.w, vertical: 10.h),
                              decoration: ShapeDecoration(
                                color: Colors.white
                                    .withOpacity(0.10000000149011612),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(width: 0.50),
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                              ),
                              child: Text(
                                'Ajoutez Compte PRO',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 260.h,
                    right: 0,
                    left: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width /
                                                  2 -
                                              10.h -
                                              10.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                          color: color4.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(15.r)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(8.sp),
                                              decoration: BoxDecoration(
                                                  color: color5,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.r)),
                                              child: Icon(
                                                Icons.person_outline_outlined,
                                                color: Colors.white,
                                              )),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            "Mon identité",
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width /
                                                  2 -
                                              10.h -
                                              10.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                          color: color4.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(15.r)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(8.sp),
                                              decoration: BoxDecoration(
                                                  color: color5,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.r)),
                                              child: Icon(
                                                Icons.folder_open,
                                                color: Colors.white,
                                              )),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            "Signature des documents",
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width /
                                                  2 -
                                              10.h -
                                              10.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                          color: color4.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(15.r)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(8.sp),
                                              decoration: BoxDecoration(
                                                  color: color5,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.r)),
                                              child: Icon(
                                                Icons.phone,
                                                color: Colors.white,
                                              )),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            "My Number",
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.width /
                                                  2 -
                                              10.h -
                                              10.h,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                          color: color4.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(15.r)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: EdgeInsets.all(8.sp),
                                              decoration: BoxDecoration(
                                                  color: color5,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.r)),
                                              child: Icon(
                                                Icons.credit_card_outlined,
                                                color: Colors.white,
                                              )),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            "My Identity Card",
                                            style: TextStyle(
                                                fontSize: 15.sp,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.h),
                            child: Text(
                              'Votre application d’indentification',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF666680),
                                fontSize: 12.h,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ClipRect(
                    child: BackdropFilter(
                      filter: new ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                      child: Container(
                        color: Colors.transparent,
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.all(15.h),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white
                                      .withOpacity(0.10000000149011612),
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                    size: 17.sp,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: 60.h,
                                right: 0,
                                left: 0,
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.white
                                      .withOpacity(0.10000000149011612),
                                )),
                            Positioned(
                              top: 120.h,
                              right: 0,
                              left: 0,
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: currentEtape == 0,
                                    child: EtapeVerificationComptePro(
                                        etape1: etape1,
                                        etape2: etape2,
                                        etape3: etape3,
                                        etape4: etape4),
                                  ),
                                  Visibility(
                                    visible: currentEtape == 1,
                                    child: VerificationTelephone(
                                      isVerificationNum: isVerificationNum,
                                    ),
                                  ),
                                  Visibility(
                                    visible: currentEtape == 2,
                                    child: VerificationEmail(
                                      isVerificationEmail: isVerificationEmail,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 50.h,
                              right: 0,
                              left: 0,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (currentEtape == 0) {
                                    if (etape1 == false) {
                                      currentEtape = 1;
                                      setState(() {});
                                    } else if (etape2 == false) {
                                      currentEtape = 2;
                                      setState(() {});
                                    }
                                  } else if (currentEtape == 1) {
                                    if (isVerificationNum == false) {
                                      isVerificationNum = true;
                                      setState(() {});
                                    } else {
                                      currentEtape = 0;
                                      etape1 = true;
                                      setState(() {});
                                    }
                                  } else if (currentEtape == 2) {
                                    if (isVerificationEmail == false) {
                                      isVerificationEmail = true;
                                      setState(() {});
                                    } else {
                                      currentEtape = 0;
                                      etape2 = true;
                                      setState(() {});
                                    }
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
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                      text: 'WHOWIATY',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600)),
                                  TextSpan(
                                    text: ' by icosnet',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.white),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
