import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/pages/mot_pass_oublie/reinitialisation.dart';
import 'package:whowiyati/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;

import '../../const.dart';
import '../../widgets/adaptive_circular_progress_indicator.dart';
import '../../widgets/custom_bottom_text_hint.dart';
import '../../widgets/custom_title_text.dart';

class ResetPassword extends StatefulWidget {
  final bool isEmail;
  final String resetTo;
  const ResetPassword(
      {super.key, required this.resetTo, required this.isEmail});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  // ******************* Logic *******************
  TextEditingController _passwordContr = TextEditingController();
  TextEditingController _confirmContr = TextEditingController();
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool obscureText = true;

  resetPass() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (_formKey.currentState!.validate()) {
        isLoading = true;
        setState(() {});
        var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

        var request = http.MultipartRequest('PUT',
            Uri.parse('https://api.icosnet.com/sign/wh/update/password/'));

        if (widget.isEmail) {
          request.fields.addAll({
            'email': widget.resetTo,
            'new_password': _passwordContr.text,
            'confirm_password': _confirmContr.text
          });
        } else {
          request.fields.addAll({
            'phone': widget.resetTo,
            'new_password': _passwordContr.text,
            'confirm_password': _confirmContr.text
          });
        }

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        String answer = await response.stream.bytesToString();
        Map answerJson = jsonDecode(answer);

        if (answerJson["success"] == true) {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Reinitialisation()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Echec dans la réinitialisé du mot de passe, Veillez les vérifier svp"),
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
                            Center(
                              child: Image.asset(
                                'assets/images/icon_eye.png',
                                // Replace with the actual path to your image file
                                fit: BoxFit.contain,
                                width: 100
                                    .w, // Adjust the image's fit property as needed
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            CustomTitleText(
                                data: "Réinitialisation de votre\nmot de passe",
                                color: Colors.white,
                                size: 15),
                            SizedBox(
                              height: 20.h,
                            ),
                            CustomTitleText(
                                data:
                                    "Nous vous recommandons d'utiliser un mot de passe\nsécurisé que vous n'utilisez nulle part ailleurs",
                                color: Colors.grey,
                                size: 12.5),
                            SizedBox(
                              height: 40.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              child: CustomTextFormField(
                                textInputAction: TextInputAction.next,
                                controller: _passwordContr,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: obscureText,
                                style: TextStyle(color: Colors.white),
                                validator: (val) {
                                  return validInput(val!, 8, 50);
                                },
                                hintText: "Mot de passe",
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
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              child: CustomTextFormField(
                                textInputAction: TextInputAction.done,
                                controller: _confirmContr,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: obscureText,
                                style: TextStyle(color: Colors.white),
                                validator: (val) {
                                  return validInput(val!, 8, 50);
                                },
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
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 1,
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
                                    resetPass();
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
