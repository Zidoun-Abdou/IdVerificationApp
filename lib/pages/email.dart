import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../const.dart';
import 'package:http/http.dart' as http;
import 'confirm_mail.dart';
import 'dart:convert';

import 'package:whowiyati/pages/login.dart';

class Email extends StatefulWidget {
  final String token;
  const Email({Key? key, required this.token}) : super(key: key);

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _mailContr = TextEditingController();

  //functions
  sendCode() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      if (_formKey.currentState!.validate()) {
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
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ConfirmMail(
                    token: widget.token,
                    mail: _mailContr.text,
                    id: answerJson["id"].toString(),
                  )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Email incorrect, Veillez vérifier svp"),
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
            body: SafeArea(
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: color3,
                      ),
                    )
                  : Form(
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
                                      keyboardType: TextInputType.emailAddress,
                                      // autofocus: true,
                                      validator: (val) {
                                        return validInput(val!, 5, 50);
                                      },
                                      cursorColor: color3,
                                      controller: _mailContr,
                                      style: TextStyle(color: Colors.white),
                                      // Set text color to white
                                      decoration: InputDecoration(
                                        hintText: "Email",
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
                                          Icons.mail,
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
                                    child: ElevatedButton(
                                      onPressed: () {
                                        sendCode();
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
                                        "Envoyer le code",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                          Expanded(
                              flex: 1,
                              child: ListView(
                                children: [
                                  SizedBox(
                                    height: 50.h,
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
