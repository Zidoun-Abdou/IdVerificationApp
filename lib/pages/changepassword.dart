import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../const.dart';
import '../widgets/adaptive_circular_progress_indicator.dart';
import '../widgets/custom_bottom_text_hint.dart';
import '../widgets/custom_image_logo.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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

  bool _isChecked = false;
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _passwordContr = TextEditingController();

  //functions

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color4,
      body: isLoading
          ? Center(
              child: AdaptiveCircularProgressIndicator(color: color3),
            )
          : SafeArea(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomImageLogo(width: 200),
                    ),
                    Expanded(
                        flex: 2,
                        child: ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 8.h),
                              child: TextFormField(
                                controller: _passwordContr,
                                validator: (val) {
                                  return validInput(val!, 3, 13);
                                },
                                cursorColor: color3,
                                obscureText: true,
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
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        50.r), // Set border radius
                                  ),
                                ),
                              ),
                            ),
                            // Container(
                            //     margin: EdgeInsets.symmetric(
                            //         horizontal: 20.w, vertical: 8.h),
                            //     child: Row(
                            //       mainAxisAlignment:
                            //           MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Row(
                            //           children: [
                            //             Theme(
                            //               data: Theme.of(context).copyWith(
                            //                 unselectedWidgetColor:
                            //                     Colors.grey,
                            //               ),
                            //               child: Checkbox(
                            //                 checkColor: color3,
                            //                 activeColor: Colors.black,
                            //                 value: _isChecked,
                            //                 onChanged: (value) {
                            //                   setState(() {
                            //                     _isChecked = !_isChecked;
                            //                   });
                            //                 },
                            //               ),
                            //             ),
                            //             Text(
                            //               'Remember me',
                            //               textAlign: TextAlign.center,
                            //               style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontSize: 12.sp,
                            //                 fontFamily: 'Poppins',
                            //                 fontWeight: FontWeight.w400,
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         Text(
                            //           'Forget password ?',
                            //           textAlign: TextAlign.center,
                            //           style: TextStyle(
                            //             color: Colors.white,
                            //             fontSize: 12.sp,
                            //             fontStyle: FontStyle.italic,
                            //             fontFamily: 'Poppins',
                            //             fontWeight: FontWeight.w300,
                            //           ),
                            //         )
                            //       ],
                            //     )),
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
                                onPressed: () {},
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
                                  "Login",
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
                            CustomBottomTextHint(),
                          ],
                        ))
                  ],
                ),
              ),
            ),
    );
  }
}
