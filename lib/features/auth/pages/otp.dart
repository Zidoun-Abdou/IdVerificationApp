import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/core/utils/snackbar_message.dart';
import 'package:whowiyati/main.dart';
import 'package:http/http.dart' as http;

import '../../../core/widgets/adaptive_circular_progress_indicator.dart';
import '../../../core/widgets/custom_image_logo.dart';
import '../../../core/widgets/custom_main_button.dart';
import '../../../core/widgets/custom_pin_field_auto_fill.dart';
import '../../home/pages/dealpad.dart';
import '../widgets/otp/custom_text_otp.dart';

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
  // ******************* Logic *******************
  bool is_filled = false;
  bool isPhoneNumberValid = false;
  String otp = "";
  bool _isLoading = false;
  String mytoken = "";

  Future<bool> sendToken() async {
    try {
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
        var headers2 = {
          'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ==',
          'Content-Type': 'application/json'
        };
        var request2 = http.Request(
            'PUT', Uri.parse('https://api.icosnet.com/sign/wh/verify/sms/'));
        request2.body = json.encode({
          "phone": widget.phone,
          "user_id": answerJson["user_id"].toString()
        });
        request2.headers.addAll(headers2);

        http.StreamedResponse response2 = await request2.send();
        String answer2 = await response2.stream.bytesToString();
        var answerJs2 = jsonDecode(answer2);

        if (answerJs2["status"] == true) {
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
          SnackBarMessage().showErrorSnackBar(
              message:
                  "Numéro de téléphone déjà utilisé, veuillez vous connecter",
              context: context);
          _isLoading = false;
          setState(() {});
          return false;
        }
      } else {
        print(answerJson.toString());
        SnackBarMessage().showErrorSnackBar(
            message:
                "Numéro de téléphone déjà utilisé, veuillez vous connecter",
            context: context);
        _isLoading = false;
        setState(() {});
        return false;
      }
    } on Exception {
      SnackBarMessage().showErrorSnackBar(
          message: "Quelque chose s'est mal passé, réessayez plus tard",
          context: context);
      _isLoading = false;
      setState(() {});
      return false;
    }
  }

  Future<int> verifySms() async {
    if (otp.length == 4) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
          _isLoading = true;
          setState(() {});
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
            SnackBarMessage()
                .showErrorSnackBar(message: "OTP non valide", context: context);
            _isLoading = false;
            setState(() {});
            return 0;
          }
        } on Exception {
          SnackBarMessage().showErrorSnackBar(
              message: "Quelque chose s'est mal passé, réessayez plus tard",
              context: context);
          _isLoading = false;
          setState(() {});
          return 0;
        }
      } else {
        SnackBarMessage().showErrorSnackBar(
            message: "Veillez vérifier votre connection internet",
            context: context);
        _isLoading = false;
        setState(() {});
        return 0;
      }
    } else {
      SnackBarMessage()
          .showErrorSnackBar(message: "OTP incomplet", context: context);
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
        body: _isLoading
            ? Center(
                child: AdaptiveCircularProgressIndicator(color: color3),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomImageLogo(width: 200),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          CustomTextOtp(
                              data: "Verification du numéro de téléphone",
                              color: Colors.white,
                              size: 15),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomTextOtp(
                              data:
                                  "Veuillez saisir le code SMS à 4 chiffres qui a été envoyé à ${widget.phone}",
                              color: Colors.grey,
                              size: 12.5),
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40.w),
                            child: CustomPinFieldAutoFill(
                              autoFocus: true,
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
                      child: CustomMainButton(
                        onPressed: () async {
                          verifySms();
                        },
                        text: 'Continuer',
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
