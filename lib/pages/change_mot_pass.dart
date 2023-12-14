import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const.dart';

class ChangeMotPass extends StatefulWidget {
  ChangeMotPass({Key? key}) : super(key: key);

  @override
  State<ChangeMotPass> createState() => _ChangeMotPassState();
}

class _ChangeMotPassState extends State<ChangeMotPass> {
  int step = 1;
  bool hidePassword = true;
  bool hidePasswordActual = true;
  bool hidePasswordNouveau = true;
  bool hidePasswordConfirmer = true;
  double _textFontSize = 12.sp;

  List<String> title = [
    "Nous vous conseillons d'utiliser un mot de passe sûr\nque vous n'utilisez nulle part ailleurs",
    'Votre mot de passe a été\nchangé avec succès',
  ];

  List<String> icon = [
    "assets/images/icon_setting.png",
    "assets/images/icon_eye.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C1C23),
      body: SafeArea(
        child: Form(
          child: SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Image.asset(
                    hidePassword ? icon[0] : icon[1],
                    height: 90.h,
                    width: 90.w,
                    fit: BoxFit.contain,
                  ),
                  step == 2 ? SizedBox(height: 60.h) : SizedBox(height: 20.h),
                  Text(
                    title[step - 1],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFA2A2B5),
                      fontSize: _textFontSize,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  AnimatedOpacity(
                    opacity: step == 2 ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    child: Visibility(
                        visible: step == 2,
                        child: Image.asset(
                          "assets/images/tick.png",
                          height: 100.h,
                          width: 100.w,
                          fit: BoxFit.contain,
                        )),
                  ),
                  Visibility(
                    visible: step == 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          child: Text(
                            "Actuel",
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
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 8.h),
                          child: TextFormField(
                            // controller: _passwordContr,
                            validator: (val) {
                              return validInput(val!, 3, 13);
                            },
                            cursorColor: color3,
                            obscureText: hidePasswordActual,
                            obscuringCharacter: "*",
                            style: TextStyle(color: Colors.white),
                            // Set text color to white
                            decoration: InputDecoration(
                              hintText: 
                                    "Password",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.r),
                                borderSide: BorderSide(
                                  color: color3,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.black,
                              // Set background color to black
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  hidePassword = !hidePassword;
                                  hidePasswordActual = !hidePasswordActual;
                                  setState(() {});
                                },
                                child: Icon(Icons.remove_red_eye_outlined,
                                    color: color3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    50.r), // Set border radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: step == 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          child: Text(
                            'Nouveau',
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
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 8.h),
                          child: TextFormField(
                            // controller: _passwordContr,
                            validator: (val) {
                              return validInput(val!, 3, 13);
                            },
                            cursorColor: color3,
                            obscureText: hidePasswordNouveau,
                            obscuringCharacter: "*",
                            style: TextStyle(color: Colors.white),
                            // Set text color to white
                            decoration: InputDecoration(
                               hintText: 
                                    "Password",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.r),
                                borderSide: BorderSide(
                                  color: color3,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.black,
                              // Set background color to black
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  hidePassword = !hidePassword;
                                  hidePasswordNouveau = !hidePasswordNouveau;
                                  setState(() {});
                                },
                                child: Icon(Icons.remove_red_eye_outlined,
                                    color: color3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    50.r), // Set border radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: step == 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 22.w),
                          child: Text(
                            'Confirmer',
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
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 8.h),
                          child: TextFormField(
                            // controller: _passwordContr,
                            validator: (val) {
                              return validInput(val!, 3, 13);
                            },
                            cursorColor: color3,
                            obscureText: hidePasswordConfirmer,
                            obscuringCharacter: "*",
                            style: TextStyle(color: Colors.white),
                            // Set text color to white
                            decoration: InputDecoration(
                               hintText: 
                                    "Password",
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.r),
                                borderSide: BorderSide(
                                  color: color3,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.black,
                              // Set background color to black
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.white,
                              ),
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  hidePassword = !hidePassword;
                                  hidePasswordConfirmer = !hidePasswordConfirmer;
                                  setState(() {});
                                },
                                child: Icon(Icons.remove_red_eye_outlined,
                                    color: color3),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                    50.r), // Set border radius
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Visibility(
                    visible: step == 1,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                                _textFontSize = 15.sp;
                                step = 2;
                              });
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
                          // Set the shadow color
                        ),
                        child: Text("Enregistrer",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Spacer(flex: 2,),
                Container(
                  margin: EdgeInsets.only(top: step == 1 ? 70.h : 240.h),
                  
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
        ),
      ),
    );
  }
}
