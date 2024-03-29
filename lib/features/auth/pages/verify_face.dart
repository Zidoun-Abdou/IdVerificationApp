import 'dart:convert';
import 'dart:io';
import 'package:dmrtd/dmrtd.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:whowiyati/core/utils/snackbar_message.dart';

import '../../../const.dart';
import '../../../core/widgets/custom_byicosnet_hint.dart';
import '../../../core/widgets/custom_main_button.dart';
import '../../../main.dart';
import '../../home/pages/welcome.dart';

class VerifyFace extends StatefulWidget {
  final String face;
  final String front;
  final String back;
  final String signature;

  const VerifyFace({
    Key? key,
    required this.face,
    required this.front,
    required this.back,
    required this.signature,
  }) : super(key: key);

  @override
  State<VerifyFace> createState() => _VerifyFaceState();
}

class _VerifyFaceState extends State<VerifyFace> {
  // ******************* Logic *******************
  late CameraController controller;
  var isRecording = false;
  bool _isShownFace = false;
  late File savedImage;
  bool _is_loading = false;
  String _myToken = "";
  double progress = 0.8;

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      _myToken = value.toString();
      print(_myToken);
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
    controller = CameraController(
      cameras[1],
      ResolutionPreset.ultraHigh,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<bool> verifyFace(String link) async {
    try {
      var headers = {
        'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
        'Content-Type':
            'multipart/form-data; boundary=<calculated when request is sent>',
      };

      /// Initialize Ip Address
      var ipAddress = IpAddress(type: RequestType.text);

      /// Get the IpAddress based on requestType.
      dynamic data = await ipAddress.getIpAddress();
      String ip = data.toString();
      print(data.toString());

      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://api.icosnet.com/kyc_liveness/liveness?token=${_myToken}&question=neutral&ip_adress=${ip}'));
      request.files.add(await http.MultipartFile.fromPath('video', link));
      request.files.add(await http.MultipartFile.fromPath('face', widget.face));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);
      print(answerJson);

      if (answerJson["decision"] == "True") {
        print("face ok");
        await prefs.setString('idinfos', "ok");

        await sendToAlfresco();
        return true;
      } else {
        SnackBarMessage().showErrorSnackBar(
            message: "La vérification faciale a échoué. Veuillez réessayer",
            context: context);
        print(response.reasonPhrase);
        return false;
      }
    } on Exception {
      return false;
    }
  }

  String convertDateCart(String inputDate) {
    DateFormat inputFormat = DateFormat("MM/dd/yyyy");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");

    // Parse the input date and format it in the desired output format
    DateTime parsedDate = inputFormat.parse(inputDate);
    String outputDate = outputFormat.format(parsedDate);

    return outputDate;
  }

  String convertDateNfc(String inputDate) {
    // Define the input and output date formats
    DateFormat inputFormat = DateFormat("yyyy/MM/dd");
    DateFormat outputFormat = DateFormat("yyyy-MM-dd");

    // Parse the input date and format it in the desired output format
    DateTime parsedDate = inputFormat.parse(inputDate);
    String outputDate = outputFormat.format(parsedDate);

    return outputDate;
  }

  Future<bool> sendToAlfresco() async {
    try {
      var headers = {
        'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ==',
      };
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://api.icosnet.com/sign/wh/alfresco/'));

      String creation_date = prefs.getString('deliv_date').toString();
      String birth_date = prefs.getString('birth_date').toString();
      String expiry_date = prefs.getString('exp_date').toString();

      NfcStatus statusNfc = await NfcProvider.nfcStatus;

      if (statusNfc.toString() == "NfcStatus.notSupported") {
        creation_date = convertDateCart(creation_date);
        birth_date = convertDateCart(birth_date);
        expiry_date = convertDateCart(expiry_date);
      } else {
        creation_date = convertDateNfc(creation_date);
        birth_date = convertDateNfc(birth_date);
        expiry_date = convertDateNfc(expiry_date);
      }

      request.fields.addAll({
        'token': _myToken,
        'french_surname': prefs.getString('surname_latin').toString(),
        'french_name': prefs.getString('name_latin').toString(),
        'id_number': prefs.getString('nin').toString(),
        'creation_date': creation_date,
        'birth_date': birth_date,
        'expiration_date': expiry_date,
        'card_number': prefs.getString('document_number').toString(),
        'email': prefs.getString('mail').toString(),
        'user_id': prefs.getString('user_id').toString()
      });

      print(creation_date);
      print(birth_date);
      print(expiry_date);

      request.files
          .add(await http.MultipartFile.fromPath('image_recto', widget.front));
      request.files
          .add(await http.MultipartFile.fromPath('image_verso', widget.back));
      request.files
          .add(await http.MultipartFile.fromPath('image_face', widget.face));
      request.files.add(
          await http.MultipartFile.fromPath('signature', widget.signature));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 201) {
        await prefs.setString("status", "5");
        await prefs.setString("deliv_date", creation_date);
        await prefs.setString("birth_date", birth_date);
        await prefs.setString("exp_date", expiry_date);
        print("Alfresco ok");
        print(await response.stream.bytesToString());
        controller.dispose();
        SnackBarMessage().showSuccessSnackBar(
            message: "Identification réussie avec succès !", context: context);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => Welcome(
                      token: _myToken,
                    )),
            (Route<dynamic> route) => false);
        return true;
      } else {
        print(response.reasonPhrase);
        print(await response.stream.bytesToString());
        SnackBarMessage().showErrorSnackBar(
            message: "Échec de l'envoi, réessayez", context: context);
        print(response.reasonPhrase);
        return false;
      }
    } on Exception {
      return false;
    }
  }

  // ******************* Interface *******************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'My account',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFFA2A2B5),
            fontSize: 16.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.20,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    height: MediaQuery.of(context).size.height / 2.3,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        // color: color1,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          _is_loading
                              ? "Veuillez patienter, nous sommes en train de vérifier votre visage"
                              : 'Placez votre visage dans \nle cadre de la caméra ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 17,
                            height: 1.41,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 100.h,
                    right: 0,
                    left: 0,
                    child: _isShownFace
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 60.w, vertical: 10.h),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              height: 300.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: color4.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(15.r)),
                              child: CameraPreview(controller),
                            ),
                          )
                        : Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 60.w, vertical: 10.h),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              height: 300.h,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                  color: color4.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(15.r)),
                              child: _is_loading == true
                                  ? Center(
                                      child: CircularPercentIndicator(
                                        animation: true,
                                        animationDuration: 30000,
                                        radius: 40.r,
                                        lineWidth: 6.0.w,
                                        percent: progress,
                                        progressColor: color3,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/images/face.png',
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                  ),
                  Visibility(
                    visible: _is_loading,
                    child: Positioned(
                      bottom: 80.h,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                          color: color3,
                          size: 40.sp,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _is_loading == false && _isShownFace == false,
                    child: Positioned(
                      bottom: 80.h,
                      right: 0,
                      left: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: CustomMainButton(
                          onPressed: () async {
                            setState(() {
                              _isShownFace = !_isShownFace;
                            });
                            controller.startVideoRecording();
                            await Future.delayed(const Duration(seconds: 7));
                            var video = await controller.stopVideoRecording();
                            setState(() {
                              _isShownFace = !_isShownFace;
                            });
                            _is_loading = true;
                            setState(() {
                              progress = 0.8;
                            });
                            String _mypath = video.path;
                            print(_mypath);
                            await GallerySaver.saveVideo(_mypath);
                            var myvideo = File(video.path);
                            print(
                                "--------------------------------------------------------");
                            print(myvideo.path);
                            await verifyFace(myvideo.path);
                            _is_loading = false;
                            setState(() {});
                            print("finish");
                          },
                          text: "Open camera",
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomByIcosnetHint(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
