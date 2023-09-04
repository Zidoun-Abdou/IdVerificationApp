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

class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _phoneContr = TextEditingController();
  bool isPhoneNumberValid = false;
  String countryCode = "";
  String mytoken = "";

  getToken() async {
    /*  var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {*/
    isLoading = true;
    setState(() {});
    var headers = {
      'Authorization': 'Basic aWNvc25ldF9hcHBzOkttNGFHVGxiZU1sNEFOcmh0U0xy',
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.icosnet.com/ibmpp/esb/pbflow_customer_create.php'));

    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      mytoken = value!;
      request.fields.addAll(
          {'phone': "213${_phoneContr.text}", 'token': token.toString()});
    });
    await prefs.setString('token', mytoken.toString());

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (answerJson["success"] == true) {
      await sendSms();
      print(answerJson.toString());
    } else {
      print(answerJson.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Number or phone already used, Please Login"),
          duration: Duration(seconds: 2),
        ),
      );
      isLoading = false;
      setState(() {});
    }
    /* } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veillez vérifier votre connection internet"),
          duration: Duration(seconds: 5),
        ),
      );
      isLoading = false;
      setState(() {});
    }*/
    isLoading = false;
    setState(() {});
  }

  Future<int> sendSms() async {
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

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (answerJson["id"] != null) {
      print(answerJson["id"].toString());
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Otp(
                phone: "+213${_phoneContr.text}",
                id: answerJson["id"].toString(),
                token: mytoken,
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

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: Form(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        // Replace with the actual path to your image file
                        fit: BoxFit.contain,
                        height: 150.h,
                        width: 250.w,
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Text(
                      "Saisissez votre numéro de téléphone",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.1.h,
                        letterSpacing: 0.20.w,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Nous utilisons votre numéro de téléphone pour vous\n identifier.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.1.h,
                        letterSpacing: 0.20.w,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      child: IntlPhoneField(
                        autofocus: true,
                        controller: _phoneContr,
                        cursorColor: color3,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "21 99 33 42",
                          hintStyle: TextStyle(color: Colors.white),
                          label: Text(
                            "Numero de téléphone",
                            style: TextStyle(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.r),
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
                        initialCountryCode: 'DZ',
                        dropdownIcon: Icon(
                          Icons.arrow_drop_down,
                          color: color3,
                        ),
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
                    Text(
                      "* Première étape de vérification de l’identité \n « insertion du numéro de téléphone »",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.1.h,
                        letterSpacing: 0.20.w,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: isLoading,
                        child: const CircularProgressIndicator(
                          color: color3,
                        ),
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
                                getToken();
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      "Veillez vérifier votre connection internet"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                              isLoading = false;
                              setState(() {});
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isPhoneNumberValid ? color3 : color4,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            foregroundColor: Colors.white,
                            minimumSize: Size.fromHeight(30.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            elevation: 20,
                            shadowColor: isPhoneNumberValid
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
                  )),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
