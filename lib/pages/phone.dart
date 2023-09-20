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
            duration: Duration(seconds: 5),
          ),
        );
        return 0;
      }
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: Form(
          key: _formstate,
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        // Replace with the actual path to your image file
                        fit: BoxFit.contain,
                        height: 100.h,
                        width: 200.w,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
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
                        textInputAction: TextInputAction.next,
                        controller: _phoneContr,
                        cursorColor: color3,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
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
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,

                        validator: (val) {
                          return validInput(val!, 5, 50);
                        },
                        cursorColor: color3,
                        controller: _passwordContr,
                        obscureText: true,

                        style: TextStyle(color: Colors.white),
                        // Set text color to white
                        decoration: InputDecoration(
                          label: Text(
                            "Mot de passe",
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
                            Icons.lock,
                            color: color3,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                50.r), // Set border radius
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          return validInput(val!, 5, 50);
                        },
                        cursorColor: color3,
                        controller: _confpasswordContr,
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        // Set text color to white
                        decoration: InputDecoration(
                          label: Text(
                            "Confirmer le mot de passe",
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
                            color: color3,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                50.r), // Set border radius
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "* Première étape de vérification de l’identité",
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
                                await sendSms();
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
