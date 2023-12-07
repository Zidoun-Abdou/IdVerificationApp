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
  bool isObscureText = true;
  bool isHide = true;

  List<String> title = [
    'Changer le mot de passe',
    "Nous vous conseillons d'utiliser un mot de passe sûr\nque vous n'utilisez nulle part ailleurs",
    'Votre mot de passe a été\nchangé avec succès',
  ];

  List<String> icon = [
    "assets/images/icon_setting.png",
    "assets/images/icon_eye.png",
  ];

  @override
  Widget build(BuildContext context) {
    double? sizeWidth = MediaQuery.of(context).size.width * 0.3;

    return Scaffold(
      backgroundColor: Color(0xFF1C1C23),
      body: SafeArea(
        child: Form(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(height: 30.h),
                Image.asset(
                  isObscureText ? icon[0] : icon[1],
                  height: 90.h,
                  width: 90.w,
                ),
                step == 3 ? SizedBox(height: 60.h) : SizedBox(height: 20.h),
                Text(
                  title[step - 1],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFA2A2B5),
                    fontSize: step == 2 ? 12.sp : 15.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 30.h),
                Visibility(
                    visible: step == 3,
                    child: Image.asset(
                      "assets/images/tick.png",
                      height: 100.h,
                      width: 100.w,
                      fit: BoxFit.cover,
                    )),
                Visibility(
                  visible: step != 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 22.w),
                        child: Text(
                          isHide ? "Mot de pass" : "Actuel",
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
                          obscureText: isObscureText,
                          style: TextStyle(color: Colors.white),
                          // Set text color to white
                          decoration: InputDecoration(
                            label: Text(
                              "Password",
                              style: TextStyle(color: Colors.white),
                            ),
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
                                isObscureText = !isObscureText;
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
                  visible: !isHide,
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
                          obscureText: isObscureText,
                          style: TextStyle(color: Colors.white),
                          // Set text color to white
                          decoration: InputDecoration(
                            label: Text(
                              "Password",
                              style: TextStyle(color: Colors.white),
                            ),
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
                            // suffixIcon: GestureDetector(
                            //   onTap: () {
                            //     isObscureText = !isObscureText;
                            //     setState(() {});
                            //   },
                            //   child: Icon(Icons.remove_red_eye_outlined,
                            //       color: color3),
                            // ),
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
                  visible: !isHide,
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
                          obscureText: isObscureText,
                          style: TextStyle(color: Colors.white),
                          // Set text color to white
                          decoration: InputDecoration(
                            label: Text(
                              "Password",
                              style: TextStyle(color: Colors.white),
                            ),
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
                            // suffixIcon: GestureDetector(
                            //   onTap: () {
                            //     isObscureText = !isObscureText;
                            //     setState(() {});
                            //   },
                            //   child: Icon(Icons.remove_red_eye_outlined,
                            //       color: color3),
                            // ),
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
                  visible: step != 3,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      width: step == 1 ? sizeWidth : null,
                      child: ElevatedButton(
                        onPressed: () {
                          if (isHide) {
                            if (step == 1) {
                              setState(() {
                                step = 2;
                              });
                            } else if (step == 2) {
                              isHide = false;
                              setState(() {});
                            }
                          } else {
                            step = 3;
                            isHide = true;
                            setState(() {});
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
                          // Set the shadow color
                        ),
                        child: Text(
                          isHide ? "Modifier" : "Enregistrer",
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
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(bottom: 40.h),
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
    );
  }
}
