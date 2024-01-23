import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../const.dart';
import '../widgets/adaptive_circular_progress_indicator.dart';
import 'package:http/http.dart' as http;

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _phoneContr = TextEditingController();

  bool isPhoneNumberValid = false;
  String countryCode = "";

  //functions
  sendRefreshPassword() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (_formKey.currentState!.validate()) {
        isLoading = true;
        setState(() {});
        var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

        var request = http.MultipartRequest('POST',
            Uri.parse('https://api.icosnet.com/sign/wh/forget/password/'));

        request.fields.addAll({'phone': '+213${_phoneContr.text}'});

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        String answer = await response.stream.bytesToString();
        var answerJson = jsonDecode(answer);

        if (answerJson["success"] == true) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Vérifiez votre mail pour réinitialisation votre mot de passe"),
              duration: Duration(seconds: 3),
              backgroundColor: color3,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Numéro de téléphone n'existe pas, Veillez les vérifier svp"),
              duration: Duration(seconds: 3),
              backgroundColor: colorRed,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veillez vérifier votre connection internet"),
          duration: Duration(seconds: 3),
          backgroundColor: colorRed,
        ),
      );
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    _phoneContr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
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
                        flex: 3,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              // Replace with the actual path to your image file
                              fit: BoxFit.contain,
                              height: 100.h,
                              width: 200
                                  .w, // Adjust the image's fit property as needed
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "Saisissez votre numéro de téléphone",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.1.h,
                                letterSpacing: 0.20.w,
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "Nous utilisons votre numéro de téléphone afin\nenvoyer un mail pour réinitialisation votre mot de passe",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.5.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                height: 1.1.h,
                                letterSpacing: 0.20.w,
                              ),
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.w),
                              alignment: Alignment.center,
                              child: IntlPhoneField(
                                autofocus: true,
                                textInputAction: TextInputAction.next,
                                controller: _phoneContr,
                                cursorColor: color3,
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: "Numero de téléphone",
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
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        50.r), // Set border radius
                                  ),
                                ),
                                initialCountryCode: 'DZ',
                                dropdownTextStyle:
                                    TextStyle(color: Colors.white),
                                dropdownIcon: Icon(
                                  Icons.arrow_drop_down,
                                  color: color3,
                                ),
                                onChanged: (phone) {
                                  if (phone.completeNumber.length == 13) {
                                    setState(() {
                                      isPhoneNumberValid = true;
                                      countryCode =
                                          phone.countryCode.substring(1);
                                      print(countryCode);
                                    });
                                  } else {
                                    setState(() {
                                      isPhoneNumberValid = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                    sendRefreshPassword();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color3,

                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.h),
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
                                    "Confirmer",
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
                              Text(
                                "Votre application d'identification",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12.5.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.1.h,
                                  letterSpacing: 0.20.w,
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
