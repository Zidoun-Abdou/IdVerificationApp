import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/cardnfcinfo.dart';
import 'package:whowiyati/pages/conditions.dart';
import 'package:whowiyati/pages/idinfos.dart';
import 'package:whowiyati/pages/steps.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

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
  late CameraController controller;
  var isRecording = false;
  bool _isShownFace = false;
  late File savedImage;
  bool _is_loading = false;
  String _myToken = "";

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
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

      controller.dispose();
      await sendToAlfresco();
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Face verification failed, Please try again."),
          duration: Duration(seconds: 5),
        ),
      );
      print(response.reasonPhrase);
      return false;
    }
  }

  Future<bool> sendToAlfresco() async {
    // var headers = {
    //   'Authorization': 'Basic ZHNpX3NlbGZjYXJlOmRzaV9zZWxmY2FyZQ==',
    // };
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/wh/alfresco/'));

    request.fields.addAll({
      'token': _myToken,
      'french_surname': prefs.getString('surname_latin').toString(),
      'french_name': prefs.getString('name_latin').toString(),
      'id_number': prefs.getString('nin').toString(),
      'creation_date': prefs.getString('deliv_date').toString(),
      'birth_date': prefs.getString('birth_date').toString(),
      'expiration_date': prefs.getString('exp_date').toString(),
      'card_number': prefs.getString('document_number').toString(),
      'email': prefs.getString('mail').toString(),
      'user_id': prefs.getString('user_id').toString(),
    });
    request.files
        .add(await http.MultipartFile.fromPath('image_recto', widget.front));
    request.files
        .add(await http.MultipartFile.fromPath('image_verso', widget.back));
    request.files
        .add(await http.MultipartFile.fromPath('image_face', widget.face));
    request.files
        .add(await http.MultipartFile.fromPath('signature', widget.signature));
    // request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);

    if (response.statusCode == 200 || response.statusCode == 201) {
      await prefs.setString("status", "5");
      print("Alfresco ok");
      print(answerJson);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => IdInfos()),
          (Route<dynamic> route) => false);
      return true;
    } else {
      print(answerJson);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send to Alfresco."),
          duration: Duration(seconds: 5),
        ),
      );
      print(response.reasonPhrase);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                        color: color1,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.r),
                            bottomRight: Radius.circular(20.r))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 1,
                            ),
                            Text(
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
                            Icon(
                              Icons.settings,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        Text(
                          'Placez votre visage dans \nle cadre de la caméra ',
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
                    top: 130.h,
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
                                      child: CircularProgressIndicator(
                                          color: color3),
                                    )
                                  : Image.asset(
                                      'assets/images/face.png',
                                      fit: BoxFit.contain,
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
                        child: ElevatedButton(
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
                            setState(() {});
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color3,
                            padding: EdgeInsets.symmetric(vertical: 15.h),
                            foregroundColor: Colors.white,
                            minimumSize: Size.fromHeight(50.w),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            elevation: 20,
                            shadowColor: color3, // Set the shadow color
                          ),
                          child: Text(
                            "Open camera",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20.h,
                    right: 0,
                    left: 0,
                    child: Text(
                      'Powered by ICOSNET',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20,
                      ),
                    ),
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
