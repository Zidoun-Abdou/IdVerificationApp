import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/register_commerce/ajouter_compte_pro.dart';
import 'package:whowiyati/pages/cardnfcinfo.dart';
import 'package:whowiyati/pages/change_mot_pass.dart';
import 'package:whowiyati/pages/changepassword.dart';
import 'package:whowiyati/pages/homepage.dart';
import 'package:whowiyati/pages/register_commerce/registre_commerce.dart';
import 'package:whowiyati/pages/steps.dart';

import 'idinfos.dart';
import 'listofdocuments.dart';

class Welcome extends StatefulWidget {
  final String token;
  const Welcome({Key? key, required this.token}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  bool isProfile = false;
  final GlobalKey<State<BottomSheet>> _bottomSheetKey = GlobalKey();
  double initialSize = 0.7;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                                onPressed: () async {
                                  showModalBottomSheet(
                                      backgroundColor: color2,
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20.w,
                                                  vertical: 20.h),
                                              child: Text(
                                                "Êtes-vous sûr de vouloir quitter Whowiyaty?",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    await prefs.clear();
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                HomePage()),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                                  },
                                                  child: Text("Oui"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              color3,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      15.h,
                                                                  horizontal:
                                                                      30.w),
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.r),
                                                          ),
                                                          elevation: 10,
                                                          shadowColor: color3),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Non"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.red,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      15.h,
                                                                  horizontal:
                                                                      30.w),
                                                          foregroundColor:
                                                              Colors.white,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.r),
                                                          ),
                                                          elevation: 10,
                                                          shadowColor:
                                                              Colors.red),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        );
                                      });
                                },
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.grey,
                                ))
                            // Icon(
                            //   Icons.logout,
                            //   color: Colors.grey,
                            // )
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
                                      child: Text("0"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: prefs.getString('name_latin') == null,
                          child: Container(
                            margin: EdgeInsets.all(5.sp),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 5.h),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Text(
                              "Non identifié",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Text(
                            //   'Manage your profile ',
                            //   style: TextStyle(
                            //     color: Color(0xFFA2A2B5),
                            //     fontSize: 15.sp,
                            //     fontFamily: 'Inter',
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            InkWell(
                              onTap: () {
                                if (prefs.getString('name_latin') != null) {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      barrierColor: Colors.transparent,
                                      isDismissible: true,
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                      builder: (context) {
                                        return ClipRect(
                                          child: BackdropFilter(
                                            filter: new ImageFilter.blur(
                                                sigmaX: 20.0, sigmaY: 20.0),
                                            child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.62,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            color: color4))),
                                                child: Padding(
                                                  padding: EdgeInsets.all(15.h),
                                                  child: Stack(
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: CircleAvatar(
                                                            backgroundColor: Colors
                                                                .white
                                                                .withOpacity(
                                                                    0.10000000149011612),
                                                            child: Icon(
                                                              Icons.clear,
                                                              color:
                                                                  Colors.white,
                                                              size: 17.sp,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        top: 90.h,
                                                        right: 0,
                                                        left: 0,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              "Souhaitez-vous ajouter un  compte\nprofessionnel ?",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14.sp,
                                                                fontFamily:
                                                                    'Inter',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                letterSpacing:
                                                                    0.20,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: 30.h),
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                // Navigator to ajouter compte pro
                                                                Navigator.of(
                                                                        context)
                                                                    .push(
                                                                  PageRouteBuilder(
                                                                    pageBuilder: (context,
                                                                            animation,
                                                                            secondaryAnimation) =>
                                                                        const AjouterComptePro(),
                                                                    transitionsBuilder: (context,
                                                                        animation,
                                                                        secondaryAnimation,
                                                                        child) {
                                                                      var tween = Tween<Offset>(
                                                                              begin: const Offset(0.0, 1.0),
                                                                              end: Offset.zero)
                                                                          .chain(CurveTween(curve: Curves.easeInOut));

                                                                      var offestAnimation =
                                                                          animation
                                                                              .drive(tween);

                                                                      return SlideTransition(
                                                                        position:
                                                                            offestAnimation,
                                                                        child:
                                                                            child,
                                                                      );
                                                                    },
                                                                  ),
                                                                );
                                                              },
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                backgroundColor:
                                                                    color3,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            15.h),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                minimumSize: Size
                                                                    .fromHeight(
                                                                        30.w),
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50.r),
                                                                ),
                                                                elevation: 20,
                                                                shadowColor:
                                                                    color3,
                                                              ),
                                                              child: Text(
                                                                'Ajouter un compte PRO',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      15.sp,
                                                                  fontFamily:
                                                                      'Inter',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomCenter,
                                                        child: Text.rich(
                                                          TextSpan(children: [
                                                            TextSpan(
                                                                text:
                                                                    'WHOWIATY',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            TextSpan(
                                                              text:
                                                                  ' by icosnet',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ]),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ),
                                        );
                                      });
                                }
                              },
                              child: Container(
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
                                    color:
                                        prefs.getString('idinfos').toString() !=
                                                    "null" &&
                                                prefs
                                                        .getString('mail')
                                                        .toString() !=
                                                    "null"
                                            ? Colors.white
                                            : Colors.grey,
                                    fontSize: 12.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
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
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: isProfile
                                ?
                                // Profile-details
                                GestureDetector(
                                    onTap: () {
                                      isProfile = !isProfile;
                                      setState(() {});
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 30.w),
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
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: Container(
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
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Text.rich(
                                            TextSpan(children: [
                                              TextSpan(
                                                  text: 'Nom: ',
                                                  style: TextStyle(
                                                    color: Color(0xFF666680),
                                                    fontSize: 14.h,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.20,
                                                  )),
                                              TextSpan(
                                                  text: prefs
                                                      .getString('name_latin')
                                                      ?.toUpperCase(),
                                                  style: TextStyle(
                                                    color: Color(0xFFA2A2B5),
                                                    fontSize: 14.h,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.20,
                                                  )),
                                            ]),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text.rich(
                                            TextSpan(children: [
                                              TextSpan(
                                                  text: 'Prénom: ',
                                                  style: TextStyle(
                                                    color: Color(0xFF666680),
                                                    fontSize: 14.h,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.20,
                                                  )),
                                              TextSpan(
                                                  text: prefs
                                                      .getString(
                                                          'surname_latin')
                                                      ?.toUpperCase(),
                                                  style: TextStyle(
                                                    color: Color(0xFFA2A2B5),
                                                    fontSize: 14.h,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.20,
                                                  )),
                                            ]),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text.rich(
                                            TextSpan(children: [
                                              TextSpan(
                                                  text: 'ID :',
                                                  style: TextStyle(
                                                    color: Color(0xFF666680),
                                                    fontSize: 14.h,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.20,
                                                  )),
                                              TextSpan(
                                                  text: prefs
                                                      .getString('user_id')
                                                      ?.toUpperCase(),
                                                  style: TextStyle(
                                                    color: Color(0xFFA2A2B5),
                                                    fontSize: 14.h,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 0.20,
                                                  )),
                                            ]),
                                          ),
                                          Spacer(
                                            flex: 2,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "NIN: ${prefs.getString('nin')?.toUpperCase()}",
                                                style: TextStyle(
                                                  color: Color(0xFF666680),
                                                  fontSize: 12.h,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.20,
                                                ),
                                              ),
                                              Image.asset(
                                                "assets/images/finger_print.png",
                                                height: 40.h,
                                                width: 40.w,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                if (prefs.getString(
                                                        'name_latin') !=
                                                    null) {
                                                  setState(() {
                                                    isProfile = !isProfile;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    10.h -
                                                    10.h,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w,
                                                    vertical: 10.h),
                                                decoration: BoxDecoration(
                                                    color:
                                                        color4.withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(
                                                            8.sp),
                                                        decoration: BoxDecoration(
                                                            color: prefs.getString(
                                                                        'name_latin') !=
                                                                    null
                                                                ? color5
                                                                : Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.r)),
                                                        child: Icon(
                                                          Icons
                                                              .person_outline_outlined,
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
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                if (prefs.getString(
                                                        'name_latin') !=
                                                    null) {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ListOfDocuments(),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    10.h -
                                                    10.h,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w,
                                                    vertical: 10.h),
                                                decoration: BoxDecoration(
                                                    color:
                                                        color4.withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(
                                                            8.sp),
                                                        decoration: BoxDecoration(
                                                            color: prefs.getString(
                                                                        'name_latin') !=
                                                                    null
                                                                ? color5
                                                                : Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {},
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    10.h -
                                                    10.h,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w,
                                                    vertical: 10.h),
                                                decoration: BoxDecoration(
                                                    color:
                                                        color4.withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(
                                                            8.sp),
                                                        decoration: BoxDecoration(
                                                            color: prefs.getString(
                                                                        'name_latin') !=
                                                                    null
                                                                ? color5
                                                                : Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.r)),
                                                        child: Icon(
                                                          Icons
                                                              .star_border_outlined,
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
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                if (prefs.getString(
                                                        'name_latin') !=
                                                    null) {
                                                  prefs.getString("name_arabic") ==
                                                          null
                                                      ? Navigator.of(context)
                                                          .push(
                                                          MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    IdInfos(),
                                                          ),
                                                        )
                                                      : Navigator.of(context)
                                                          .push(MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CardNfcInfo()));
                                                }
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    10.h -
                                                    10.h,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.w,
                                                    vertical: 10.h),
                                                decoration: BoxDecoration(
                                                    color:
                                                        color4.withOpacity(0.8),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.r)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                        padding: EdgeInsets.all(
                                                            8.sp),
                                                        decoration: BoxDecoration(
                                                            color: prefs.getString(
                                                                        'name_latin') !=
                                                                    null
                                                                ? color5
                                                                : Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                          Visibility(
                            visible: prefs.getString('name_latin') == null,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 15.h),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Steps(
                                            token: widget.token,
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Poursuivre mon identification   ',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Icon(
                                      Icons.warning_rounded,
                                      size: 25.sp,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                              visible: isProfile,
                              child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              )),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
