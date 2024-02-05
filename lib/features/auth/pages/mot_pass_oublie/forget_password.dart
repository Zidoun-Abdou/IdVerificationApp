import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/features/auth/pages/mot_pass_oublie/verifier_code.dart';
import 'package:whowiyati/core/widgets/custom_intl_phone_field.dart';
import 'package:whowiyati/core/widgets/custom_main_button.dart';
import 'package:whowiyati/core/widgets/custom_title_text.dart';
import '../../../../const.dart';
import '../../../../core/utils/snackbar_message.dart';
import '../../../../core/widgets/adaptive_circular_progress_indicator.dart';
import 'package:http/http.dart' as http;

import '../../../../core/widgets/custom_bottom_text_hint.dart';
import '../../../../core/widgets/custom_image_logo.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  // ******************* Logic *******************
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _phoneContr = TextEditingController();
  bool isPhoneNumberValid = false;
  String countryCode = "";

  checkPhoneNumber() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (_formKey.currentState!.validate()) {
        try {
          isLoading = true;
          setState(() {});
          var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

          var request = http.MultipartRequest(
              'POST', Uri.parse('https://api.icosnet.com/sign/wh/user/check/'));

          request.fields.addAll({'phone': '+213${_phoneContr.text}'});

          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();
          String answer = await response.stream.bytesToString();
          Map answerJson = jsonDecode(answer);

          if (answerJson["success"] == true) {
            if (answerJson.containsKey("email")) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VerifierCode(
                        isEmail: true,
                        sendTo: answerJson["email"],
                      )));
            } else if (answerJson.containsKey("phone")) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VerifierCode(
                        isEmail: false,
                        sendTo: answerJson["phone"],
                      )));
            }
          } else {
            SnackBarMessage().showErrorSnackBar(
                message:
                    "Numéro de téléphone n'existe pas, Veillez les vérifier svp",
                context: context);
          }
        } on Exception {
          SnackBarMessage().showErrorSnackBar(
              message: "Quelque chose s'est mal passé, réessayez plus tard",
              context: context);
        }
      }
    } else {
      SnackBarMessage().showErrorSnackBar(
          message: "Veillez vérifier votre connection internet",
          context: context);
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void dispose() {
    _phoneContr.dispose();
    super.dispose();
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            CustomImageLogo(width: 200),
                            SizedBox(
                              height: 20.h,
                            ),
                            CustomTitleText(
                                data:
                                    "Saisissez votre numéro\nde téléphone associé à votre compte Whowiaty",
                                color: Colors.white,
                                size: 14),
                            SizedBox(
                              height: 40.h,
                            ),
                            Padding(
                              padding: EdgeInsets.all(20.w),
                              child: CustomIntlPhoneField(
                                  controller: _phoneContr,
                                  autofocus: false,
                                  styleColor: Colors.black,
                                  fillColor: Colors.white,
                                  invalidNumberMessage:
                                      "Numéro de Téléphone non valide",
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
                                        countryCode =
                                            phone.countryCode.substring(1);
                                        print(countryCode);
                                      });
                                    } else {
                                      setState(() {
                                        isPhoneNumberValid = false;
                                      });
                                    }
                                  }),
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
                                    checkPhoneNumber();
                                  },
                                  text: "Envoyer",
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
      ),
    );
  }
}
