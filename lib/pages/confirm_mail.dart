import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/steps.dart';
import 'dart:convert';
import 'package:whowiyati/pages/welcome.dart';

class ConfirmMail extends StatefulWidget {
  final String id;
  final String mail;
  final String token;

  const ConfirmMail(
      {Key? key, required this.id, required this.mail, required this.token})
      : super(key: key);

  @override
  State<ConfirmMail> createState() => _ConfirmMailState();
}

class _ConfirmMailState extends State<ConfirmMail> {
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _mailContr = TextEditingController();

  //functions
  validateCode() async {
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
            Uri.parse('https://api.icosnet.com/apisrv/email-verify/check/'));
        request.fields.addAll({'code': _mailContr.text, 'id': widget.id});

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();
        String answer = await response.stream.bytesToString();
        var answerJson = jsonDecode(answer);
        if (answerJson["success"] == true) {
          print(answerJson.toString());
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => Steps(
          //           token: widget.token,
          //         )));
          //await _addtoportaone();
          await _updateEmail();
        } else {
          print(answerJson.toString());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Code incorrect, Veillez vérifier svp"),
              duration: Duration(seconds: 5),
            ),
          );
        }
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

  Future<int> _addtoportaone() async {
    isLoading = true;
    setState(() {});
    var headers = {
      'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.icosnet.com/ibmpp/esb/pbflow_account_create.php'));
    request.fields
        .addAll({'token': widget.token, 'type': 'email', 'value': widget.mail});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (answerJson["success"] == true) {
      await prefs.setString('mail', _mailContr.text);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Steps(
                token: widget.token,
              )));
      print(answerJson.toString());
      isLoading = false;
      setState(() {});
      return 1;
    } else {
      print('email not send to portaone');
      print(answerJson.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            answerJson.toString(),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
        ),
      );
      print(response.reasonPhrase);
      isLoading = false;
      setState(() {});
      return 0;
    }
    isLoading = false;
    setState(() {});
  }

  Future<int> _updateEmail() async {
    isLoading = true;
    setState(() {});
    var headers = {
      'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
      'Cookie': 'PHPSESSID=baa6nj4s6682e98sbb1v2gsgr7'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse('https://api.icosnet.com/ibmpp/esb/pbflow_update_email.php'));
    request.fields.addAll(
        {'phone': prefs.getString('phone').toString(), 'email': widget.mail});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (answerJson["message"] != "Phone not found") {
      await prefs.setString('mail', widget.mail);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Steps(
                token: widget.token,
              )));
      print(answerJson.toString());
      isLoading = false;
      setState(() {});
      return 1;
    } else {
      print('email not found');
      print(answerJson.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            answerJson.toString(),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
        ),
      );
      print(response.reasonPhrase);
      isLoading = false;
      setState(() {});
      return 0;
    }
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter:
              ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
          child: Image.asset(
            "assets/images/background.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
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
                              width: 200.w,
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
                                    autofocus: true,
                                    keyboardType: TextInputType.number,
                                    validator: (val) {
                                      return validInput(val!, 2, 8);
                                    },
                                    cursorColor: color3,
                                    controller: _mailContr,
                                    style: TextStyle(color: Colors.white),
                                    // Set text color to white
                                    decoration: InputDecoration(
                                      label: Text(
                                        "code",
                                        style: TextStyle(color: Colors.white),
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
                                        Icons.lock,
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
                                      validateCode();
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
                                      "Verify code",
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
    );
  }
}
