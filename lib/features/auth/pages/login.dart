import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../const.dart';
import '../../../core/utils/snackbar_message.dart';
import '../../../core/widgets/adaptive_circular_progress_indicator.dart';
import '../../../core/widgets/custom_bottom_text_hint.dart';
import '../../../core/widgets/custom_image_background.dart';
import '../../../core/widgets/custom_image_logo.dart';
import '../../../core/widgets/custom_main_button.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../../main.dart';
import '../../home/pages/welcome.dart';
import '../widgets/login/custom_souvenir_moi_checkbox.dart';
import 'mot_pass_oublie/forget_password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // ******************* Logic *******************
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    prefs.getBool("isRememberMe") == true
        ? prefs.getString('rememberUserID') == null
            ? prefs.setBool("isRememberMe", false)
            : _useridContr.text = prefs.getString('rememberUserID').toString()
        : _useridContr.text = "";
    getToken();
  }

  String _myToken = "";

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      _myToken = value.toString();
    });
  }

  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _useridContr = TextEditingController();
  TextEditingController _passwordContr = TextEditingController();

  //functions
  login() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (_formKey.currentState!.validate()) {
        try {
          isLoading = true;
          setState(() {});
          var headers = {
            'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ==',
          };
          var request = http.MultipartRequest(
              'POST', Uri.parse('https://api.icosnet.com/sign/wh/login/'));

          request.fields.addAll(
              {'user_id': _useridContr.text, 'password': _passwordContr.text});

          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();
          String answer = await response.stream.bytesToString();
          var answerJson = jsonDecode(answer);
          print(answer);
          print(answerJson["success"]);

          if (answerJson["success"] == true) {
            await prefs.setString("status", answerJson["user"]['status'] ?? "");
            await prefs.setString(
                "name_latin", answerJson["user"]['last_name'] ?? "");
            await prefs.setString(
                "surname_latin", answerJson["user"]['first_name'] ?? "");
            await prefs.setString(
                "birth_date", answerJson["user"]['birthday'] ?? "");
            await prefs.setString(
                "deliv_date", answerJson["user"]['creation_date'] ?? "");
            await prefs.setString(
                "exp_date", answerJson["user"]['expiration_date'] ?? "");
            await prefs.setString(
                "document_number", answerJson["user"]['card_number'] ?? "");
            await prefs.setString(
                "user_id", answerJson["user"]['user_id'] ?? "");
            await prefs.setString("phone", answerJson["user"]['phone'] ?? "");
            await prefs.setString("mail", answerJson["user"]['email'] ?? "");
            await prefs.setString("nin", answerJson["user"]['nin'] ?? "");
            await prefs.setString(
                "pasword", answerJson["user"]['pass_code'] ?? "");

            if (prefs.getBool("isRememberMe") == true) {
              await prefs.setString("rememberUserID", _useridContr.text);
            } else if (prefs.getBool("isRememberMe") == false) {
              await prefs.remove("rememberUserID");
            }
            await prefs.setString('login', 'true');

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Welcome(token: _myToken)),
                (Route<dynamic> route) => false);
          } else {
            SnackBarMessage().showErrorSnackBar(
                message: "Informations incorrects, Veillez les vérifier svp",
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

  // ******************* Interface *******************
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          CustomImageBackground(),
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: isLoading
                ? AdaptiveCircularProgressIndicator(color: color3)
                : SafeArea(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomImageLogo(width: 200),
                          ),
                          Expanded(
                              flex: 2,
                              child: ListView(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 8.h),
                                    child: CustomTextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: _useridContr,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(color: Colors.white),
                                      validator: (val) {
                                        return validInput(val!, 8, 8);
                                      },
                                      maxLength: 8,
                                      hintText: "Identifiant d'utilisateur",
                                      hintStyle: TextStyle(color: Colors.white),
                                      fillColor: Colors.black,
                                      prefixIcon: Icon(
                                        Icons.person_outline,
                                        color: Colors.white,
                                      ),
                                      counterStyle: TextStyle(
                                        color: Colors
                                            .white, // Change this color to your desired color
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 8.h),
                                    child: CustomTextFormField(
                                      textInputAction: TextInputAction.done,
                                      controller: _passwordContr,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      style: TextStyle(color: Colors.white),
                                      obscureText: obscureText,
                                      validator: (val) {
                                        return validInput(val!, 8, 50);
                                      },
                                      hintText: "Mot de passe",
                                      hintStyle: TextStyle(color: Colors.white),
                                      fillColor: Colors.black,
                                      prefixIcon: Icon(
                                        Icons.lock_outline,
                                        color: Colors.white,
                                      ),
                                      suffixIcon: obscureText
                                          ? IconButton(
                                              highlightColor:
                                                  Colors.transparent,
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
                                              highlightColor:
                                                  Colors.transparent,
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
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 8.h),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomSouvenirMoiCheckbox(
                                              onChanged: (value) {
                                            if (prefs.getBool("isRememberMe") ==
                                                    false ||
                                                prefs.getBool("isRememberMe") ==
                                                    null) {
                                              setState(() {
                                                prefs.setBool(
                                                    "isRememberMe", true);
                                                if (prefs.getString(
                                                            'rememberUserID') !=
                                                        null &&
                                                    prefs.getString(
                                                            'rememberUserID') !=
                                                        "") {
                                                  _useridContr.text = prefs
                                                      .getString(
                                                          'rememberUserID')
                                                      .toString();
                                                }
                                              });
                                            } else {
                                              setState(() {
                                                prefs.setBool(
                                                    "isRememberMe", false);
                                              });
                                            }
                                          }),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ForgetPassword()));
                                            },
                                            child: Text(
                                              'Mot de passe oublié ?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.sp,
                                                fontStyle: FontStyle.italic,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                ],
                              )),
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
                                        login();
                                      },
                                      text: "Se Connecter",
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
        ],
      ),
    );
  }
}
