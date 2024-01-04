import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/welcome.dart';

class IdInfos extends StatefulWidget {
  const IdInfos({
    Key? key,
  }) : super(key: key);

  @override
  State<IdInfos> createState() => _IdInfosState();
}

class _IdInfosState extends State<IdInfos> {
  bool? _is_loading = false;
  GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();
  @override
  void initState() {
    super.initState();
    getToken();
  }

  String _myToken = "";

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      _myToken = value.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: Center(
          child: _is_loading == true
              ? CircularProgressIndicator()
              : Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ListView(
                              shrinkWrap: true,
                              children: [
                                SizedBox(
                                  height: 50.h,
                                ),
                                Container(
                                  height: 400.h,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/fingerprint.png'),
                                        fit: BoxFit.fitHeight,
                                        alignment: Alignment.centerRight),
                                  ),
                                )
                              ],
                            ),
                            Positioned(
                              top: 150.h,
                              child: FlipCard(
                                key: _cardKey,
                                flipOnTouch: true,
                                direction: FlipDirection.HORIZONTAL,
                                speed: 500,
                                front: Container(
                                  height: 170.h,
                                  width: 320.w,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/flip1.png"),
                                        fit: BoxFit.cover),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 20.h),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Identité \nValidée',
                                          style: TextStyle(
                                            color: Color(0xFF00FF84),
                                            fontSize: 26.sp,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 0.20,
                                          ),
                                        ),
                                        Expanded(child: Text('')),
                                        Text(
                                          'Votre identité à été désormais validée \navec succéss.',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 1.5.h,
                                            letterSpacing: 0.20,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                back: Container(
                                  height: 170.h,
                                  width: 320.w,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            "assets/images/flip2.png"),
                                        fit: BoxFit.cover),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 5.h),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                              color: Color(
                                                                  0xFF00FF84),
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: prefs
                                                                .getString(
                                                                    'name_latin')
                                                                ?.toUpperCase(),
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
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
                                                              color: Color(
                                                                  0xFF00FF84),
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: prefs
                                                                .getString(
                                                                    'surname_latin')
                                                                ?.toUpperCase(),
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
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
                                                              color: Color(
                                                                  0xFF00FF84),
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: prefs
                                                                .getString(
                                                                    'birth_date')
                                                                ?.toUpperCase(),
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
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
                                                              color: Color(
                                                                  0xFF00FF84),
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: prefs
                                                                    .getString(
                                                                        'deliv_date')
                                                                    ?.toUpperCase() ??
                                                                "",
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
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
                                                              color: Color(
                                                                  0xFF00FF84),
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: prefs
                                                                    .getString(
                                                                        'exp_date')
                                                                    ?.toUpperCase() ??
                                                                "",
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
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
                                                              color: Color(
                                                                  0xFF00FF84),
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: prefs
                                                                .getString(
                                                                    'document_number')
                                                                ?.toUpperCase(),
                                                            style: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 12.sp,
                                                              fontFamily:
                                                                  'Poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              letterSpacing:
                                                                  0.20,
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 0.h),
                                          alignment: Alignment.centerRight,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text.rich(
                                                TextSpan(
                                                  children: [
                                                    TextSpan(
                                                      text: 'Nin: ',
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xFF00FF84),
                                                        fontSize: 12.sp,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        height: 3.39,
                                                        letterSpacing: 0.20,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: prefs
                                                          .getString('nin')
                                                          ?.toUpperCase(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12.sp,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 30.h),
                              child: Text(
                                "Bienvenue sur Whowiaty Votre application d’identification en ligne",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontFamily: 'Inter',
                                  height: 1.1.h,
                                  letterSpacing: 0.20.w,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 5.h),
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
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
                                  'Retourner',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
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
