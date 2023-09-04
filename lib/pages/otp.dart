import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:whowiyati/const.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/phone_ok.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/pages/steps.dart';
import 'package:whowiyati/pages/welcome.dart';

class Otp extends StatefulWidget {
  final String phone;
  final String id;
  final String token;

  const Otp(
      {Key? key, required this.phone, required this.id, required this.token})
      : super(key: key);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  TextEditingController _phoneContr = TextEditingController();
  bool is_filled = false;
  bool isPhoneNumberValid = false;
  String otp = "";
  bool _isLoading = false;

  Future<int> Next() async {
    if (otp.length == 4) {
      var headers = {
        'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('https://api.icosnet.com/apisrv/sms-verify/check/'));
      request.fields.addAll({'id': widget.id, 'code': otp});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);
      if (answerJson["success"] == true) {
        print(answerJson.toString());
        await _addtoportaone();
      return 1;
      } else {
        //print(answerJson["success"]);
        print(answerJson.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "OTP non valid ",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
          ),
        );
        return 0;

      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "OTP incomplet ",
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
        ),
      );
      return 0;
    }
  }

  Future<int> _addtoportaone() async {
    _isLoading = true;
    setState(() {});
    var headers = {
      'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.icosnet.com/ibmpp/esb/pbflow_account_create.php'));

    request.fields.addAll({
      'token': widget.token,
      'type': 'mobile',
      'value': '213${widget.phone}'
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (answerJson["success"] == true) {
      print(answerJson.toString());
      _isLoading = false;
      setState(() {});
      await prefs.setString('phone', widget.phone);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Steps(token: widget.token),
        ),
      );
      return 1;
    } else {
      print('sms not sent');
      print(answerJson.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            answerJson.toString(),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
        ),
      );
      _isLoading = false;
      setState(() {});
      return 0;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: color1,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: color3,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: 150,
                        width: 250,
                        child: Image.asset(
                          'assets/images/logo.png',
                          // Replace with the actual path to your image file
                          fit: BoxFit.contain,
                          // Adjust the image's fit property as needed
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "Verification du numéro de téléphone",
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
                      "Veuillez saisir le code SMS à 4 chiffres qui a été envoyé à ${widget.phone}",
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
                      height: 20.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40.w),
                      child: PinFieldAutoFill(
                        controller: _phoneContr,
                        codeLength: 4,
                        autoFocus: true,
                        // cursor: Cursor(color: color3,enabled: true),
                        decoration: UnderlineDecoration(
                          lineHeight: 2,
                          lineStrokeCap: StrokeCap.square,
                          textStyle: TextStyle(color: color3, fontSize: 20.sp),
                          bgColorBuilder: PinListenColorBuilder(color4, color4),
                          colorBuilder: const FixedColorBuilder(color3),
                        ),
                        onCodeChanged: (code) {
                          otp = code.toString();
                          print(otp);
                        },
                      ),
                    ),
                    //Expanded(child: Text("")),
                    SizedBox(
                      height: 200.h,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: ElevatedButton(
                        onPressed: () async {
                          Next();
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
                    /* Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                          visible: is_filled, child: CircularProgressIndicator()),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                        child: ElevatedButton(
                          onPressed: () async {
                            Next();
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
                    ],
                  )),*/
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
