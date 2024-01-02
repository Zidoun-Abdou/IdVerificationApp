import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/main.dart';
import 'dart:convert';

import 'package:whowiyati/pages/welcome.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    getToken();
  }

  String _myToken = "";

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      _myToken = value.toString();
    });
  }

  bool _isChecked = false;
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
          await prefs.setString("status", answerJson["user"]['status']);
          await prefs.setString("username", answerJson["user"]['username']);
          await prefs.setString("user_id", answerJson["user"]['user_id']);
          await prefs.setString("phone", answerJson["user"]['phone']);
          await prefs.setString("email", answerJson["user"]['email']);
          await prefs.setString("nin", answerJson["user"]['nin'] ?? "");

          // await prefs.setString("daira", answerJson["dg12"]["daira"]);
          // await prefs.setString(
          //     "baladia_latin", answerJson["dg12"]["baladia_latin"]);
          // await prefs.setString(
          //     "baladia_arab", answerJson["dg12"]["baladia_arab"]);
          // await prefs.setString("deliv_date", answerJson["dg12"]["deliv_date"]);
          // await prefs.setString("exp_date", answerJson["dg12"]["exp_date"]);
          // await prefs.setString(
          //     "surname_latin", answerJson["dg11"]["surname_latin"]);
          // await prefs.setString(
          //     "surname_arabic", answerJson["dg11"]["surname_arabic"]);
          // await prefs.setString("name_latin", answerJson["dg11"]["name_latin"]);
          // await prefs.setString(
          //     "name_arabic", answerJson["dg11"]["name_arabic"]);
          // await prefs.setString(
          //     "birthplace_latin", answerJson["dg11"]["birthplace_latin"]);
          // await prefs.setString(
          //     "birthplace_arabic", answerJson["dg11"]["birthplace_arabic"]);
          // await prefs.setString("birth_date", answerJson["dg11"]["birth_date"]);
          // await prefs.setString("sexe_latin", answerJson["dg11"]["sexe_latin"]);
          // await prefs.setString(
          //     "sexe_arabic", answerJson["dg11"]["sexe_arabic"]);
          // await prefs.setString("blood_type", answerJson["dg11"]["blood_type"]);
          // await prefs.setString('idinfos', answerJson["dg11"]["nin"]);
          // await prefs.setString("face", answerJson["dg2"]["face"]);
          // await prefs.setString("signature", answerJson["dg7"]["signature"]);
          // await prefs.setString("document_number", document_number);

          await prefs.setString('login', 'true');

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Welcome(token: _myToken)),
              (Route<dynamic> route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Invalid credentials"),
              duration: Duration(seconds: 5),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Informations incorrects, Veillez les vérifier svp"),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.darken),
            child: Image.asset(
              "assets/images/background.png",
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: isLoading
                ? Center(
                    child: CircularProgressIndicator(color: color3),
                  )
                : SafeArea(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
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
                              flex: 2,
                              child: ListView(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 8.h),
                                    child: TextFormField(
                                      validator: (val) {
                                        return validInput(val!, 6, 25);
                                      },
                                      cursorColor: color3,
                                      keyboardType: TextInputType.number,
                                      controller: _useridContr,
                                      style: TextStyle(color: Colors.white),
                                      maxLength: 8,
                                      // Set text color to white
                                      decoration: InputDecoration(
                                        hintText: "Identifiant d'utilisateur",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        counterStyle: TextStyle(
                                          color: Colors
                                              .white, // Change this color to your desired color
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                          borderSide: BorderSide(
                                            color: color3,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.black,
                                        // Set background color to black
                                        prefixIcon: Icon(
                                          Icons.person_outline,
                                          color: Colors.white,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              50.r), // Set border radius
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 8.h),
                                    child: TextFormField(
                                      controller: _passwordContr,
                                      validator: (val) {
                                        return validInput(val!, 3, 13);
                                      },
                                      cursorColor: color3,
                                      obscureText: true,
                                      style: TextStyle(color: Colors.white),
                                      // Set text color to white
                                      decoration: InputDecoration(
                                        hintText: "Mot de passe",
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                          borderSide: BorderSide(
                                            color: color3,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.black,
                                        // Set background color to black
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: Colors.white,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              50.r), // Set border radius
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Container(
                                  //     margin: EdgeInsets.symmetric(
                                  //         horizontal: 20.w, vertical: 8.h),
                                  //     child: Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.spaceBetween,
                                  //       children: [
                                  //         Row(
                                  //           children: [
                                  //             Theme(
                                  //               data: Theme.of(context).copyWith(
                                  //                 unselectedWidgetColor:
                                  //                     Colors.grey,
                                  //               ),
                                  //               child: Checkbox(
                                  //                 checkColor: color3,
                                  //                 activeColor: Colors.black,
                                  //                 value: _isChecked,
                                  //                 onChanged: (value) {
                                  //                   setState(() {
                                  //                     _isChecked = !_isChecked;
                                  //                   });
                                  //                 },
                                  //               ),
                                  //             ),
                                  //             Text(
                                  //               'Remember me',
                                  //               textAlign: TextAlign.center,
                                  //               style: TextStyle(
                                  //                 color: Colors.white,
                                  //                 fontSize: 12.sp,
                                  //                 fontFamily: 'Poppins',
                                  //                 fontWeight: FontWeight.w400,
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //         Text(
                                  //           'Forget password ?',
                                  //           textAlign: TextAlign.center,
                                  //           style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 12.sp,
                                  //             fontStyle: FontStyle.italic,
                                  //             fontFamily: 'Poppins',
                                  //             fontWeight: FontWeight.w300,
                                  //           ),
                                  //         )
                                  //       ],
                                  //     )),
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
                                    child: ElevatedButton(
                                      onPressed: () {
                                        login();
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
                                        shadowColor: color3,
                                        // Set the shadow color
                                      ),
                                      child: Text(
                                        "Se Connecter",
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
                                  Text(
                                    "Votre application d'identification",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12.5.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w400,
                                      height: 1.1.h,
                                      letterSpacing: 0.20.w,
                                    ),
                                  ),
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
