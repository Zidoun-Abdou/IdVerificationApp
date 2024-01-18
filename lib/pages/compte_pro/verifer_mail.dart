import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:whowiyati/const.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/compte_pro/steps_verify_compte_pro.dart';

import '../../widgets/adaptive_circular_progress_indicator.dart';

class VeriferMail extends StatefulWidget {
  final String companyId;
  final String companyUserId;
  const VeriferMail(
      {super.key, required this.companyUserId, required this.companyId});

  @override
  State<VeriferMail> createState() => _VeriferMailState();
}

class _VeriferMailState extends State<VeriferMail> {
  GlobalKey<FormState> _formMailKey = GlobalKey<FormState>();
  bool isLoading = false;
  String codeId = "";
  TextEditingController _mailContr = TextEditingController();
  String otp = "";
  bool isVerificationMail = false;
  bool _utiliseMail = false;

  sendCode() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isLoading = true;
      setState(() {});
      var headers = {
        'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('https://api.icosnet.com/apisrv/email-verify/generate/'));
      request.fields.addAll({'email': _mailContr.text});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);

      if (response.statusCode == 200) {
        codeId = answerJson["id"].toString();
        setState(() {
          isVerificationMail = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email incorrect, Veillez vérifier svp"),
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
    isLoading = false;
    setState(() {});
  }

  validateCode() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (otp.length == 4) {
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
          await addCompteMail("${_mailContr.text}");
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

  addCompteMail(String mail) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isLoading = true;
      setState(() {});

      var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

      var request = http.MultipartRequest(
          'PUT', Uri.parse('https://api.icosnet.com/sign/wh/company/email/'));

      request.fields
          .addAll({'company_user_id': widget.companyUserId, 'email': mail});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);
      print(answer);
      print(mail);

      if (answerJson["success"] == true) {
        await prefs.setString("step", "2");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Votre mail est ajouté"),
            duration: Duration(seconds: 3),
            backgroundColor: color3,
          ),
        );
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StepsVerifyComptePro(
            companyId: widget.companyId,
            companyUserId: widget.companyUserId,
          ),
        ));
      } else {
        print(response.reasonPhrase);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Votre mail n'est pas ajouté, réessayez"),
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
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: color1,
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: color4.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.r))),
                    content: Text(
                      'Si vous quittez maintenant, les modifications\neffectuées ne seront pas enregistrées',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
                    actionsAlignment: MainAxisAlignment.center,
                    actionsPadding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          fixedSize: Size(100.w, 40.h),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD32424),
                          foregroundColor: Colors.white,
                          fixedSize: Size(100.w, 40.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          elevation: 20,
                          shadowColor: Color(0xFFD32424),
                        ),
                        child: Text(
                          'Quitter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  );
                });
            return false;
          },
          child: isLoading
              ? Center(
                  child: AdaptiveCircularProgressIndicator(color: color3),
                )
              : Form(
                  key: _formMailKey,
                  child: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              // Replace with the actual path to your image file
                              fit: BoxFit.contain,
                              height: 100.h,
                              width: 200
                                  .w, // Adjust the image's fit property as needed
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Stack(
                              children: [
                                Visibility(
                                  visible: isVerificationMail,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 50.h),
                                      Column(
                                        children: [
                                          Text(
                                            "Verification d'adresse mail",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              height: 1.1.h,
                                              letterSpacing: 0.20.w,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text.rich(
                                            textAlign: TextAlign.center,
                                            TextSpan(children: [
                                              TextSpan(
                                                text:
                                                    "Veuillez saisir le code SMS à 4 chiffres qui a été envoyé à\nvotre adresse mail ",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12.sp,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.1.h,
                                                  letterSpacing: 0.20.w,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "${_mailContr.text}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp,
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w400,
                                                  height: 1.1.h,
                                                  letterSpacing: 0.20.w,
                                                ),
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 50.h),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 40.w),
                                        child: PinFieldAutoFill(
                                          codeLength: 4,
                                          textInputAction: TextInputAction.none,
                                          decoration: UnderlineDecoration(
                                            lineHeight: 2,
                                            lineStrokeCap: StrokeCap.square,
                                            textStyle: TextStyle(
                                                color: color3, fontSize: 20.sp),
                                            bgColorBuilder:
                                                PinListenColorBuilder(
                                                    color4, color4),
                                            colorBuilder:
                                                FixedColorBuilder(color3),
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
                                Visibility(
                                  visible: !isVerificationMail,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 50.h),
                                      Column(
                                        children: [
                                          Text(
                                            "Lier votre email",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.20,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            "Veuillez entrer l'adresse email que vous souhaitez\nassocier à votre compte pro",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: color6,
                                              fontSize: 12.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 50.h),
                                      Visibility(
                                        visible: _utiliseMail,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 20.w),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.r)),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              addCompteMail(prefs
                                                  .getString("mail")
                                                  .toString());
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF0C23F1),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15.h),
                                              foregroundColor: Colors.white,
                                              minimumSize:
                                                  Size.fromHeight(30.w),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.r),
                                              ),
                                            ),
                                            child: Text(
                                              prefs
                                                  .getString("mail")
                                                  .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: !_utiliseMail,
                                        child: Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20.w),
                                          child: TextFormField(
                                            autofocus: false,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: _mailContr,
                                            cursorColor: color3,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.black),
                                              hintText: "Adresse email",
                                              prefixIcon: Icon(
                                                Icons.email_outlined,
                                                color: Colors.black,
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50.r),
                                                borderSide: BorderSide(
                                                  color: color3,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50
                                                        .r), // Set border radius
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(50.r),
                                              ),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Adresse e-mail non valide";
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Visibility(
                                  visible: !isVerificationMail,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 8.h),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _utiliseMail = !_utiliseMail;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF120918),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.h),
                                        foregroundColor: Colors.white,
                                        minimumSize: Size.fromHeight(30.w),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                        ),
                                        elevation: 20,
                                        shadowColor: Color(0xFF120918),
                                      ),
                                      child: Text(
                                        _utiliseMail
                                            ? 'Utiliser un autre mail'
                                            : 'Utiliser votre mail personnel',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 8.h),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (isVerificationMail == false) {
                                        if (_formMailKey.currentState!
                                            .validate()) {
                                          sendCode();
                                        }
                                      } else {
                                        validateCode();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: color3,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.h),
                                        foregroundColor: Colors.white,
                                        minimumSize: Size.fromHeight(30.w),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                        ),
                                        elevation: 20,
                                        shadowColor: color3),
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
                                Text.rich(
                                  TextSpan(children: [
                                    TextSpan(
                                        text: 'WHOWIATY',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600)),
                                    TextSpan(
                                      text: ' by icosnet',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Colors.white),
                                    ),
                                  ]),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
