import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/pages/compte_pro/steps_verify_compte_pro.dart';

class VeriferPhone extends StatefulWidget {
  final String companyId;
  final String companyUserId;
  const VeriferPhone(
      {super.key, required this.companyUserId, required this.companyId});

  @override
  State<VeriferPhone> createState() => _VeriferPhoneState();
}

class _VeriferPhoneState extends State<VeriferPhone> {
  String countryCode = "";
  String otp = "";
  bool isPhoneNumberValid = false;
  bool _utiliseNum = false;
  bool isVerificationNum = false;
  TextEditingController _phoneContr = TextEditingController();
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String smsId = "";

  addComptePhone(String phone) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isLoading = true;
      setState(() {});

      var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

      var request = http.MultipartRequest(
          'PUT', Uri.parse('https://api.icosnet.com/sign/wh/company/phone/'));

      request.fields
          .addAll({'company_user_id': widget.companyUserId, 'phone': phone});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);

      if (answerJson["success"] == true) {
        await prefs.setString("step", "1");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Votre téléphone est ajouté"),
            duration: Duration(seconds: 5),
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
            content: Text("Votre téléphone n'est pas ajouté, réessayez"),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veillez vérifier votre connection internet"),
          duration: Duration(seconds: 5),
        ),
      );
    }
    isLoading = false;
    setState(() {});
  }

  sendSms() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (isPhoneNumberValid == true) {
        isLoading = true;
        setState(() {});
        var headers = {
          'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
        };

        var request = http.MultipartRequest('POST',
            Uri.parse('https://api.icosnet.com/apisrv/sms-verify/generate/'));

        final String signature = await SmsAutoFill().getAppSignature;
        request.fields.addAll({
          'phone': '${countryCode}${_phoneContr.text}',
          'template': 'Votre code est: {{code}}\n$signature'
        });

        FirebaseMessaging.instance.getToken().then((value) {
          var mytoken = value.toString();
          request.fields.addAll({
            'phone': "${countryCode}${_phoneContr.text}",
            'token': mytoken.toString()
          });
        });
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        String answer = await response.stream.bytesToString();
        var answerJson = jsonDecode(answer);
        if (answerJson["id"] != null) {
          smsId = answerJson["id"].toString();
          setState(() {
            isVerificationNum = true;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Sms non envoyé"),
              duration: Duration(seconds: 2),
            ),
          );
          print(response.reasonPhrase);
        }
      }
      isLoading = false;
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veillez vérifier votre connection internet"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  verifySms() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (otp.length == 4) {
        var headers = {
          'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
        };
        var request = http.MultipartRequest('POST',
            Uri.parse('https://api.icosnet.com/apisrv/sms-verify/check/'));
        request.fields.addAll({'id': smsId, 'code': otp});

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        String answer = await response.stream.bytesToString();
        var answerJson = jsonDecode(answer);
        if (answerJson["success"] == true) {
          await addComptePhone("+${countryCode}${_phoneContr.text}");
        } else {
          print(answerJson.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Code incorrect, Veillez vérifier svp",
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 3),
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
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veillez vérifier votre connection internet"),
          duration: Duration(seconds: 2),
        ),
      );
    }
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
          child: SafeArea(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: color3,
                    ),
                  )
                : Form(
                    key: formKey,
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
                                  visible: isVerificationNum,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 50.h),
                                      Column(
                                        children: [
                                          Text(
                                            "Verification du numéro de téléphone",
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
                                                    "Veuillez saisir le code SMS à 4 chiffres qui a été\nenvoyé à ",
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
                                                text:
                                                    "+$countryCode${_phoneContr.text}",
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
                                  visible: !isVerificationNum,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 50.h),
                                      Column(
                                        children: [
                                          Text(
                                            "Saisissez votre numéro de téléphone professionnel",
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
                                            "Nous utilisons votre numéro de téléphone pour créer\nvotre compte professionnel",
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
                                        visible: _utiliseNum,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.h, horizontal: 20.w),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.r)),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              addComptePhone(prefs
                                                  .getString("phone")
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
                                                  .getString("phone")
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
                                        visible: !_utiliseNum,
                                        child: IntlPhoneField(
                                          autofocus: false,
                                          textInputAction: TextInputAction.done,
                                          controller: _phoneContr,
                                          cursorColor: color3,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            hintStyle:
                                                TextStyle(color: Colors.black),
                                            hintText: "Numero de téléphone",
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
                                          ),
                                          invalidNumberMessage:
                                              "Numéro de Téléphone non valide",
                                          initialCountryCode: 'DZ',
                                          dropdownIcon: Icon(
                                            Icons.arrow_drop_down,
                                            color: color3,
                                          ),
                                          validator: (value) {
                                            if (value == null) {
                                              return "Phone non valide";
                                            }
                                            return null;
                                          },
                                          onChanged: (phone) {
                                            if (phone.completeNumber.length ==
                                                13) {
                                              setState(() {
                                                isPhoneNumberValid = true;
                                                countryCode = phone.countryCode
                                                    .substring(1);
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
                                  visible: !isVerificationNum,
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 8.h),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          _utiliseNum = !_utiliseNum;
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
                                        _utiliseNum
                                            ? 'Utiliser un autre numéro'
                                            : 'Utiliser votre numéro personnel',
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
                                      if (isVerificationNum == false) {
                                        if (formKey.currentState!.validate()) {
                                          sendSms();
                                        }
                                      } else {
                                        verifySms();
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
