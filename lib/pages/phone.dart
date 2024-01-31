import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:whowiyati/const.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/main.dart';
import 'dart:convert';
import 'package:whowiyati/pages/otp.dart';
import 'package:whowiyati/widgets/custom_intl_phone_field.dart';
import 'package:whowiyati/widgets/custom_text_form_field.dart';
import 'package:whowiyati/widgets/phone/custom_text_phone.dart';

import '../widgets/adaptive_circular_progress_indicator.dart';
import '../widgets/custom_image_logo.dart';

class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  // ******************* Logic *******************
  bool obscureText = true;

  GlobalKey<FormState> _formstate = GlobalKey();
  bool isLoading = false;
  TextEditingController _phoneContr = TextEditingController();
  TextEditingController _confpasswordContr = TextEditingController();
  TextEditingController _passwordContr = TextEditingController();

  bool isPhoneNumberValid = false;
  String countryCode = "";
  String mytoken = "";

  Future<int> sendSms() async {
    if (_formstate.currentState!.validate()) {
      if (_confpasswordContr.text == _passwordContr.text) {
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
          mytoken = value.toString();
          request.fields.addAll(
              {'phone': "213${_phoneContr.text}", 'token': mytoken.toString()});
        });
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        String answer = await response.stream.bytesToString();
        var answerJson = jsonDecode(answer);
        if (answerJson["id"] != null) {
          print('sms sent with succus');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Otp(
                    phone: "+213${_phoneContr.text}",
                    id: answerJson["id"].toString(),
                    token: mytoken,
                    password: _passwordContr.text,
                  )));
          isLoading = false;
          setState(() {});
          return 1;
        } else {
          print('sms not sent');
          print(response.reasonPhrase);
          isLoading = false;
          setState(() {});
          return 0;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Mot de passes non identiques"),
            duration: Duration(seconds: 3),
            backgroundColor: colorRed,
          ),
        );
        return 0;
      }
    } else {
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: color1,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Form(
            key: _formstate,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomImageLogo(width: 200),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomTextPhone(
                      data: "Saisissez votre numéro de téléphone",
                      color: Colors.white,
                      size: 15),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomTextPhone(
                      data:
                          "Nous utilisons votre numéro de téléphone pour vous\n identifier.",
                      color: Colors.grey,
                      size: 12.5),
                  SizedBox(
                    height: 20.h,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomIntlPhoneField(
                      controller: _phoneContr,
                      autofocus: true,
                      styleColor: Colors.white,
                      fillColor: Colors.black,
                      dropdownTextStyle: TextStyle(color: Colors.white),
                      invalidNumberMessage: "Numéro de Téléphone non valide",
                      validator: (value) {
                        if (value == null) {
                          return "Phone non valide";
                        }
                        return null;
                      },
                      onChanged: (phone) {
                        if (phone.completeNumber.length == 13) {
                          setState(() {
                            isPhoneNumberValid = true;
                            countryCode = phone.countryCode.substring(1);
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
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: CustomTextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _passwordContr,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: Colors.white),
                      validator: (val) {
                        return validInput(val!, 8, 50);
                      },
                      obscureText: obscureText,
                      hintText: "Mot de passe",
                      hintStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.black,
                      prefixIcon: Icon(
                        Icons.lock,
                        color: color3,
                      ),
                      suffixIcon: obscureText
                          ? IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  obscureText = false;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility_off,
                                color: Colors.white,
                              ))
                          : IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  obscureText = true;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    child: CustomTextFormField(
                      textInputAction: TextInputAction.done,
                      controller: _confpasswordContr,
                      keyboardType: TextInputType.visiblePassword,
                      style: TextStyle(color: Colors.white),
                      validator: (val) {
                        return validInput(val!, 8, 50);
                      },
                      obscureText: obscureText,
                      hintText: "Confirmer le mot de passe",
                      hintStyle: TextStyle(color: Colors.white),
                      fillColor: Colors.black,
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: color3,
                      ),
                      suffixIcon: obscureText
                          ? IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  obscureText = false;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility_off,
                                color: Colors.white,
                              ))
                          : IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: () {
                                setState(() {
                                  obscureText = true;
                                });
                              },
                              icon: const Icon(
                                Icons.visibility,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomTextPhone(
                      data:
                          "* Première étape de vérification de votre identité",
                      color: Colors.grey,
                      size: 12.5),
                  SizedBox(
                    height: 30.h,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: isLoading,
                        child: const AdaptiveCircularProgressIndicator(
                            color: color3),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 8.h),
                        child: ElevatedButton(
                          onPressed: () async {
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult ==
                                    ConnectivityResult.mobile ||
                                connectivityResult == ConnectivityResult.wifi) {
                              if (isPhoneNumberValid == true) {
                                await sendSms();
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Veillez vérifier votre connection internet"),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: colorRed,
                                ),
                              );
                              isLoading = false;
                              setState(() {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isPhoneNumberValid &&
                                    _confpasswordContr.text ==
                                        _passwordContr.text &&
                                    _confpasswordContr.text.isNotEmpty
                                ? color3
                                : color4,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            foregroundColor: Colors.white,
                            minimumSize: Size.fromHeight(30.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            elevation: 20,
                            shadowColor: isPhoneNumberValid &&
                                    _confpasswordContr.text ==
                                        _passwordContr.text &&
                                    _confpasswordContr.text.isNotEmpty
                                ? color3
                                : color4, // Set the shadow color
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
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
