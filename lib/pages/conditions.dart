import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../const.dart';

import 'phone.dart';

class Conditions extends StatefulWidget {
  const Conditions({Key? key}) : super(key: key);

  @override
  State<Conditions> createState() => _ConditionsState();
}

class _ConditionsState extends State<Conditions> {
  bool _isChecked = false;
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _mailContr = TextEditingController();
  TextEditingController _passwordContr = TextEditingController();

  //functions

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
          child: Image.asset(
            "assets/images/background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        // Replace with the actual path to your image file
                        fit: BoxFit.contain,
                        height: 100.h,
                        width:
                            200.w, // Adjust the image's fit property as needed
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: ListView(
                        children: [
                          Center(
                            child: Text(
                              "En continuant, vous confirmez avoir lu et \n approuvé les conditions générales et la \n politique de respect de la vie privée de \n Whowiaty",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.3,
                                  letterSpacing: 0.20),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      unselectedWidgetColor: Colors.grey,
                                    ),
                                    child: Checkbox(
                                      checkColor: color3,
                                      activeColor: Colors.black,
                                      value: _isChecked,
                                      onChanged: (value) {
                                        setState(() {
                                          _isChecked = !_isChecked;
                                        });
                                      },
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      await launchUrl(Uri.parse(
                                          "https://icosnet.com.dz/conditions-dutilisation-application-whowiyati/"));
                                    },
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Condition générales',
                                            style: TextStyle(
                                              color: Color(0xFF23D27E),
                                              fontSize: 13.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.20,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' et politique \nde respect de la vie privée.',
                                            style: TextStyle(
                                              color: Color(0xFF666680),
                                              fontSize: 13.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              letterSpacing: 0.20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                ],
                              )),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 50.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 8.h),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_isChecked == true) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Phone()));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _isChecked ? color3 : Colors.grey[850],
                                padding: EdgeInsets.symmetric(vertical: 15.h),
                                foregroundColor: Colors.white,
                                minimumSize: Size.fromHeight(30.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                elevation: 20,
                                shadowColor: _isChecked
                                    ? color3
                                    : Colors.grey[850], // Set the shadow color
                              ),
                              child: Text(
                                "Continuer",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
