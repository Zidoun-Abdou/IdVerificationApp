import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/core/widgets/custom_main_button.dart';
import 'package:whowiyati/core/widgets/custom_text_form_field.dart';
import '../../../const.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/snackbar_message.dart';
import '../../../main.dart';
import '../../../core/widgets/adaptive_circular_progress_indicator.dart';
import '../../../core/widgets/custom_bottom_text_hint.dart';
import '../../../core/widgets/custom_image_background.dart';
import '../../../core/widgets/custom_image_logo.dart';
import 'steps.dart';
import 'dart:convert';

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
  // ******************* Logic *******************
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
        try {
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
            SnackBarMessage().showErrorSnackBar(
                message: "Code incorrect, Veillez vérifier svp",
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
          backgroundColor: colorRed,
        ),
      );
      print(response.reasonPhrase);
      isLoading = false;
      setState(() {});
      return 0;
    }
  }

  Future<int> _updateEmail() async {
    isLoading = true;
    setState(() {});
    try {
      // ******** send Phone and UserId and Email & Set Status 3
      var headers = {
        'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ==',
        'Content-Type': 'application/json'
      };
      var request = http.Request(
          'PUT', Uri.parse('https://api.icosnet.com/sign/wh/verify/email/'));

      request.body = json.encode({
        "phone": prefs.getString('phone').toString(),
        "user_id": prefs.getString('user_id').toString(),
        "email": widget.mail
      });

      request.headers.addAll(headers);

      http.StreamedResponse response2 = await request.send();
      String answer = await response2.stream.bytesToString();
      var answerJson = jsonDecode(answer);

      if (answerJson["status"] == true) {
        await prefs.setString("status", "3");
        await prefs.setString('mail', widget.mail);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Steps(
              token: widget.token,
            ),
          ),
        );
        return 1;
      } else {
        SnackBarMessage().showErrorSnackBar(
            message: answerJson["message"].toString(), context: context);
        print(response2.reasonPhrase);
        isLoading = false;
        setState(() {});
        return 0;
      }
    } on Exception {
      SnackBarMessage().showErrorSnackBar(
          message: "Quelque chose s'est mal passé, réessayez plus tard",
          context: context);
      isLoading = false;
      setState(() {});
      return 0;
    }
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
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(color: Colors.white),
                                      validator: (val) {
                                        return validInput(val!, 2, 8);
                                      },
                                      hintText: "Code",
                                      hintStyle: TextStyle(color: Colors.white),
                                      fillColor: Colors.black,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 8.h),
                                    child: CustomMainButton(
                                      onPressed: () {
                                        validateCode();
                                      },
                                      text: "Vérifier le code",
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
