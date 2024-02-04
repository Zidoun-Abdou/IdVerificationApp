import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:whowiyati/pages/mot_pass_oublie/reset_password.dart';
import 'package:whowiyati/widgets/custom_main_button.dart';
import 'package:whowiyati/widgets/custom_pin_field_auto_fill.dart';
import 'package:http/http.dart' as http;
import '../../const.dart';
import '../../widgets/adaptive_circular_progress_indicator.dart';
import '../../widgets/custom_bottom_text_hint.dart';
import '../../widgets/custom_title_text.dart';

class VerifierCode extends StatefulWidget {
  final bool isEmail;
  final String sendTo;
  const VerifierCode({super.key, required this.isEmail, required this.sendTo});

  @override
  State<VerifierCode> createState() => _VerifierCodeState();
}

class _VerifierCodeState extends State<VerifierCode> {
  // ******************* Logic *******************
  String otp = "";
  bool isLoading = false;
  String codeId = "";

  sendCodePhone() async {
    var headers = {
      'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
    };

    var request = http.MultipartRequest('POST',
        Uri.parse('https://api.icosnet.com/apisrv/sms-verify/generate/'));
    final String signature = await SmsAutoFill().getAppSignature;
    request.fields.addAll({
      'phone': widget.sendTo,
      'template': 'Votre code est: {{code}}\n$signature'
    });
    FirebaseMessaging.instance.getToken().then((value) {
      request.fields
          .addAll({'phone': widget.sendTo, 'token': value.toString()});
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (answerJson["id"] != null) {
      codeId = answerJson["id"].toString();
    } else {
      print('sms not sent');
      print(response.reasonPhrase);
    }
  }

  validateCodePhone() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (otp.length == 4) {
        isLoading = true;
        setState(() {});
        var headers = {
          'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
        };
        var request = http.MultipartRequest('POST',
            Uri.parse('https://api.icosnet.com/apisrv/sms-verify/check/'));
        request.fields.addAll({'id': codeId, 'code': otp});

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        String answer = await response.stream.bytesToString();
        var answerJson = jsonDecode(answer);
        if (answerJson["success"] == true) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ResetPassword(
                    resetTo: widget.sendTo,
                    isEmail: widget.isEmail,
                  )));
        } else {
          print(answerJson.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Code incorrect, Veillez vérifier svp"),
              duration: Duration(seconds: 3),
              backgroundColor: colorRed,
            ),
          );
        }
        isLoading = false;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "OTP incomplet",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            backgroundColor: colorRed,
          ),
        );
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
  }

  sendCodeEmail() async {
    var headers = {
      'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://api.icosnet.com/apisrv/email-verify/generate/'));
    request.fields.addAll({'email': widget.sendTo});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);

    if (response.statusCode == 200) {
      codeId = answerJson["id"].toString();
    } else {
      print('mail not sent');
      print(response.reasonPhrase);
    }
  }

  validateCodeEmail() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (otp.length == 4) {
        isLoading = true;
        setState(() {});
        var headers = {
          'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
        };
        var request = http.MultipartRequest('POST',
            Uri.parse('https://api.icosnet.com/apisrv/email-verify/check/'));
        request.fields.addAll({'code': otp, 'id': codeId});

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        String answer = await response.stream.bytesToString();
        var answerJson = jsonDecode(answer);
        if (answerJson["success"] == true) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ResetPassword(
                    resetTo: widget.sendTo,
                    isEmail: widget.isEmail,
                  )));
        } else {
          print(answerJson.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Code incorrect, Veillez vérifier svp"),
              duration: Duration(seconds: 3),
              backgroundColor: colorRed,
            ),
          );
        }
        isLoading = false;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "OTP incomplet",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            backgroundColor: colorRed,
          ),
        );
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
  }

  @override
  void initState() {
    widget.isEmail ? sendCodeEmail() : sendCodePhone();
    super.initState();
  }

  // ******************* Interface *******************
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: color1,
        appBar: AppBar(
          backgroundColor: color1,
          elevation: 0.0,
        ),
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? Center(
                child: AdaptiveCircularProgressIndicator(color: color3),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomTitleText(
                              data: widget.isEmail
                                  ? "Vérifier  votre  E-mail"
                                  : "Vérifier  vos  SMS",
                              color: Colors.white,
                              size: 18),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: CustomTitleText(
                                data: widget.isEmail
                                    ? "Veuillez entrer le code reçu par E-mail pour\nréinitialiser votre mot de passe "
                                    : "Veuillez entrer le code reçu par SMS pour réinitialiser votre mot de passe",
                                color: Colors.grey,
                                size: 13),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.w),
                            child: CustomPinFieldAutoFill(
                              autoFocus: false,
                              onCodeChanged: (code) {
                                otp = code.toString();
                                print(otp);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: widget.isEmail
                                        ? "Nous avons envoyé un code à l'adresse email:\n "
                                        : "Nous avons envoyé un code\nau numéro ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.20,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.isEmail
                                        ? widget.sendTo
                                        : widget.sendTo.replaceRange(
                                            0,
                                            widget.sendTo.length - 2,
                                            "xxxxxxxx"),
                                    style: TextStyle(
                                      color: color3,
                                      fontSize: 12.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.20,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
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
                              child: CustomMainButton(
                                onPressed: () {
                                  widget.isEmail
                                      ? validateCodeEmail()
                                      : validateCodePhone();
                                },
                                text: "Continue",
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
