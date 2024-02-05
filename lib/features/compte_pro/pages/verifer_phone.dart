import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:http/http.dart' as http;

import '../../../core/utils/snackbar_message.dart';
import '../../../core/widgets/adaptive_circular_progress_indicator.dart';
import '../../../core/widgets/custom_byicosnet_hint.dart';
import '../../../core/widgets/custom_image_logo.dart';
import '../../../core/widgets/custom_intl_phone_field.dart';
import '../../../core/widgets/custom_main_button.dart';
import '../../../core/widgets/custom_pin_field_auto_fill.dart';
import '../widgets/custom_alert_dialog.dart';
import 'steps_verify_compte_pro.dart';

class VeriferPhone extends StatefulWidget {
  final String companyId;
  final String companyUserId;
  const VeriferPhone(
      {super.key, required this.companyUserId, required this.companyId});

  @override
  State<VeriferPhone> createState() => _VeriferPhoneState();
}

class _VeriferPhoneState extends State<VeriferPhone> {
  // ******************* Logic *******************
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
      try {
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
          SnackBarMessage().showSuccessSnackBar(
              message: "Votre téléphone est ajouté", context: context);
          Navigator.pop(context);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => StepsVerifyComptePro(
              companyId: widget.companyId,
              companyUserId: widget.companyUserId,
            ),
          ));
        } else {
          print(response.reasonPhrase);
          SnackBarMessage().showErrorSnackBar(
              message: "Votre téléphone n'est pas ajouté, réessayez",
              context: context);
        }
      } on Exception {
        SnackBarMessage().showErrorSnackBar(
            message: "Quelque chose s'est mal passé, réessayez plus tard",
            context: context);
      }
    } else {
      SnackBarMessage().showErrorSnackBar(
          message: "Veillez vérifier votre connection internet",
          context: context);
    }
    isLoading = false;
    setState(() {});
  }

  sendSms() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
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
            SnackBarMessage()
                .showErrorSnackBar(message: "Sms non envoyé", context: context);
            print(response.reasonPhrase);
          }
        }
        isLoading = false;
        setState(() {});
      } on Exception {
        SnackBarMessage().showErrorSnackBar(
            message: "Quelque chose s'est mal passé, réessayez plus tard",
            context: context);
      }
    } else {
      SnackBarMessage().showErrorSnackBar(
          message: "Veillez vérifier votre connection internet",
          context: context);
    }
  }

  verifySms() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
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
            SnackBarMessage().showErrorSnackBar(
                message: "Code incorrect, Veillez vérifier svp",
                context: context);
          }
        } else {
          SnackBarMessage()
              .showErrorSnackBar(message: "OTP incomplet", context: context);
        }
      } on Exception {
        SnackBarMessage().showErrorSnackBar(
            message: "Quelque chose s'est mal passé, réessayez plus tard",
            context: context);
      }
    } else {
      SnackBarMessage().showErrorSnackBar(
          message: "Veillez vérifier votre connection internet",
          context: context);
    }
  }

  // ******************* Interface *******************
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: color1,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: color1,
          elevation: 0.0,
        ),
        body: WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog();
                });
            return false;
          },
          child: SafeArea(
            child: isLoading
                ? Center(
                    child: AdaptiveCircularProgressIndicator(color: color3),
                  )
                : Form(
                    key: formKey,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CustomImageLogo(width: 200),
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
                                        child: CustomIntlPhoneField(
                                          controller: _phoneContr,
                                          autofocus: false,
                                          styleColor: Colors.black,
                                          fillColor: Colors.white,
                                          validator: (value) {
                                            if (value == null) {
                                              return "Numéro de Téléphone non valide";
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
                                    child: CustomMainButton(
                                      onPressed: () {
                                        setState(() {
                                          _utiliseNum = !_utiliseNum;
                                        });
                                      },
                                      text: _utiliseNum
                                          ? 'Utiliser un autre numéro'
                                          : 'Utiliser votre numéro personnel',
                                      backgroundColor: Color(0xFF120918),
                                      elevation: 0,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 8.h),
                                  child: CustomMainButton(
                                    onPressed: () {
                                      if (isVerificationNum == false) {
                                        if (formKey.currentState!.validate()) {
                                          sendSms();
                                        }
                                      } else {
                                        verifySms();
                                      }
                                    },
                                    text: 'Continuer',
                                  ),
                                ),
                                CustomByIcosnetHint(),
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
