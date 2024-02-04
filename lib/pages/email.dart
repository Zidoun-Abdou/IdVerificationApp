import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/widgets/custom_main_button.dart';
import 'package:whowiyati/widgets/custom_text_form_field.dart';
import '../const.dart';
import 'package:http/http.dart' as http;
import '../widgets/adaptive_circular_progress_indicator.dart';
import '../widgets/custom_bottom_text_hint.dart';
import '../widgets/custom_image_background.dart';
import '../widgets/custom_image_logo.dart';
import 'confirm_mail.dart';
import 'dart:convert';

class Email extends StatefulWidget {
  final String token;
  const Email({Key? key, required this.token}) : super(key: key);

  @override
  State<Email> createState() => _EmailState();
}

class _EmailState extends State<Email> {
  // ******************* Logic *******************
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
              elevation: 0.0,
            ),
            body: SafeArea(
              child: isLoading
                  ? Center(
                      child: AdaptiveCircularProgressIndicator(color: color3),
                    )
                  : Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
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
                                      textInputAction: TextInputAction.done,
                                      controller: _mailContr,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(color: Colors.white),
                                      validator: (val) {
                                        return validInput(val!, 5, 50);
                                      },
                                      hintText: "Email",
                                      hintStyle: TextStyle(color: Colors.white),
                                      fillColor: Colors.black,
                                      prefixIcon: Icon(
                                        Icons.mail,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 8.h),
                                    child: CustomMainButton(
                                      onPressed: () {
                                        sendCode();
                                      },
                                      text: "Envoyer le code",
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
