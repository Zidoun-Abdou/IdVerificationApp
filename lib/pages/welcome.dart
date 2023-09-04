import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/steps.dart';

class Welcome extends StatefulWidget {
  final String token;
  const Welcome({Key? key, required this.token}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
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
                              'My account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFA2A2B5),
                                fontSize: 16.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.20,
                              ),
                            ),
                            Icon(
                              Icons.settings,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Hello\n${prefs.getString('idinfos').toString()}',
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Manage your profile ',
                              style: TextStyle(
                                color: Color(0xFFA2A2B5),
                                fontSize: 15.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
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
                                'profile',
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
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (context) => Steps(token: widget.token,)));},
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.width / 2 -
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
                                          "Mon profil",
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
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.width / 2 -
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
                                                  BorderRadius.circular(15.r)),
                                          child: Icon(
                                            Icons.folder_open,
                                            color: Colors.white,
                                          )),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        "Formulaire KYC",
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
                                      MediaQuery.of(context).size.width / 2 -
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
                                                  BorderRadius.circular(15.r)),
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
                                      MediaQuery.of(context).size.width / 2 -
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
                                                  BorderRadius.circular(15.r)),
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
                          SizedBox(
                            height: 20.h,
                          ),
                          Text(
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
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
