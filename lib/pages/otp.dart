import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:whowiyati/const.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:whowiyati/main.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/pages/dealpad.dart';
import 'package:whowiyati/pages/steps.dart';
import 'package:whowiyati/pages/welcome.dart';

import '../widgets/adaptive_circular_progress_indicator.dart';

class Otp extends StatefulWidget {
  final String phone;
  final String id;
  final String token;
  final String password;

  const Otp(
      {Key? key,
      required this.phone,
      required this.id,
      required this.token,
      required this.password})
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
  String mytoken = "";

  Future<bool> sendToken() async {
    /*  var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {*/
    _isLoading = true;
    setState(() {});
    var headers = {
      'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ==',
    };
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.icosnet.com/sign/wh/create/account/'));

    request.fields.addAll({
      'phone': widget.phone,
      'token': widget.token.toString(),
      'password': widget.password
    });
    print("phone ${widget.phone}");
    print("token" + widget.token.toString());
    print('password' + widget.password);

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    print("=====================");
    print(answerJson);
    print("=====================");

    if (answerJson["success"] == true) {
      // ******** send Phone and UserId & Set Status 2
      var headers = {
        'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ==',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'PUT', Uri.parse('https://api.icosnet.com/sign/wh/verify/sms/'));
      request.body = json.encode(
          {"phone": widget.phone, "user_id": answerJson["user_id"].toString()});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      String answer2 = await response.stream.bytesToString();
      var answerJs = jsonDecode(answer2);

      if (answerJs["status"] == true) {
        await prefs.setString('user_id', answerJson["user_id"].toString());
        await prefs.setString('phone', widget.phone);
        await prefs.setString('login', 'true');
        await prefs.setString("status", "2");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => DialpadScreen(status: 1)),
            (Route<dynamic> route) => false);
        return true;
      } else {
        print(response.reasonPhrase);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Utilisateur non trouvé"),
            duration: Duration(seconds: 3),
            backgroundColor: colorRed,
          ),
        );
        _isLoading = false;
        setState(() {});
        return false;
      }
    } else {
      print(answerJson.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text("Numéro ou téléphone déjà utilisé, veuillez vous connecter"),
          duration: Duration(seconds: 3),
          backgroundColor: colorRed,
        ),
      );
      _isLoading = false;
      setState(() {});
      return false;
    }
    /* } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veillez vérifier votre connection internet"),
          duration: Duration(seconds: 3),
          backgroundColor: colorRed,
        ),
      );
      isLoading = false;
      setState(() {});
    }*/
  }

  Future<int> verifySms() async {
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
        await sendToken();
        return 1;
      } else {
        //print(answerJson["success"]);
        print(answerJson.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "OTP non valide",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            backgroundColor: colorRed,
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
          backgroundColor: colorRed,
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
      print("add to portaone with succus");
      print(answerJson.toString());
      _isLoading = false;
      setState(() {});

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
          backgroundColor: colorRed,
        ),
      );
      _isLoading = false;
      setState(() {});
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: color1,
        body: _isLoading
            ? Center(
                child: AdaptiveCircularProgressIndicator(color: color3),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/logo.png',
                        // Replace with the actual path to your image file
                        fit: BoxFit.contain,
                        height: 100.h,
                        width: 200.w,
                        // Adjust the image's fit property as needed
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
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
                            height: 30.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40.w),
                            child: PinFieldAutoFill(
                              controller: _phoneContr,
                              codeLength: 4, autoFocus: true,
                              textInputAction: TextInputAction.done,
                              // cursor: Cursor(color: color3,enabled: true),
                              decoration: UnderlineDecoration(
                                lineHeight: 2,
                                lineStrokeCap: StrokeCap.square,
                                textStyle:
                                    TextStyle(color: color3, fontSize: 20.sp),
                                bgColorBuilder:
                                    PinListenColorBuilder(color4, color4),
                                colorBuilder: FixedColorBuilder(color3),
                              ),
                              onCodeChanged: (code) {
                                otp = code.toString();
                                print(otp);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 30.h),
                      child: ElevatedButton(
                        onPressed: () async {
                          verifySms();
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
                ),
              ),
      ),
    );
  }
}
