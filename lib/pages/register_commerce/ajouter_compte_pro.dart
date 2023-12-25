import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/pages/register_commerce/verification_email.dart';
import 'package:whowiyati/pages/register_commerce/verification_telephone.dart';

import '../../main.dart';
import 'etape_verification_compte_pro.dart';

class AjouterComptePro extends StatefulWidget {
  const AjouterComptePro({super.key});

  @override
  State<AjouterComptePro> createState() => _AjouterCompteProState();
}

class _AjouterCompteProState extends State<AjouterComptePro> {
  ValueNotifier<int> _currentEtape = ValueNotifier(1);
  ValueNotifier<bool> _etape1 = ValueNotifier(false);
  ValueNotifier<bool> _etape2 = ValueNotifier(false);
  ValueNotifier<bool> _etape3 = ValueNotifier(false);
  ValueNotifier<bool> _etape4 = ValueNotifier(false);

  @override
  void initState() {
    _currentEtape.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
                      height: MediaQuery.of(context).size.height / 2.3,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          // color: color1,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      // text: "Bonjour",
                                      text:
                                          'Hello\n${prefs.getString('name_latin').toString()[0].toUpperCase()}${prefs.getString('name_latin').toString().substring(1).toLowerCase()}',
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
                              Container(
                                padding: EdgeInsets.only(
                                    top: 10.h,
                                    left: 15.w,
                                    bottom: 10.h,
                                    right: 10.w),
                                alignment: Alignment.center,
                                decoration: ShapeDecoration(
                                  color: Colors.white
                                      .withOpacity(0.10000000149011612),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.notifications_none_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 20.h,
                                      child: CircleAvatar(
                                        backgroundColor: color5,
                                        child: Text("3"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40.h,
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
                                              "Mon\nprofile",
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
                                              "Mes\ndocuments",
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
                                              "Mes\ncomptes Pro",
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
                                                  Icons.edit_outlined,
                                                  color: Colors.white,
                                                )),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Text(
                                              "Signature\nélectronique",
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
                        filter:
                            new ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
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
                                    if (_currentEtape.value == 0) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                color4.withOpacity(0.8),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.r))),
                                            content: Text(
                                              'Si vous quittez maintenant, les modifications\neffectuées ne seront pas enregistrées',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 30.h,
                                                    horizontal: 20.w),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actionsPadding: EdgeInsets.only(
                                                top: 10.h, bottom: 20.h),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  foregroundColor: Colors.white,
                                                  fixedSize: Size(100.w, 40.h),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.r),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Annuler',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.sp,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xFFD32424),
                                                  foregroundColor: Colors.white,
                                                  fixedSize: Size(100.w, 40.h),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.r),
                                                  ),
                                                  elevation: 20,
                                                  shadowColor:
                                                      Color(0xFFD32424),
                                                ),
                                                child: Text(
                                                  'Quitter',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.sp,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
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
                                      visible: _currentEtape.value == 0,
                                      child: EtapeVerificationComptePro(
                                          currentEtapeValueNotifier:
                                              _currentEtape,
                                          etape1ValueNotifier: _etape1,
                                          etape2ValueNotifier: _etape2,
                                          etape3ValueNotifier: _etape3,
                                          etape4ValueNotifier: _etape4),
                                    ),
                                    Visibility(
                                      visible: _currentEtape.value == 1,
                                      child: VerificationTelephone(
                                        currentEtapeValueNotifier:
                                            _currentEtape,
                                        etape1ValueNotifier: _etape1,
                                      ),
                                    ),
                                    Visibility(
                                      visible: _currentEtape.value == 2,
                                      child: VerificationEmail(
                                        currentEtapeValueNotifier:
                                            _currentEtape,
                                        etape2ValueNotifier: _etape2,
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}
