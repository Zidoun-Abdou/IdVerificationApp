import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/conditions.dart';
import 'package:whowiyati/pages/idinfos.dart';
import 'package:whowiyati/pages/steps.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;

class VerifyFace extends StatefulWidget {
  final String face;
  final String mrz;
  final String front;
  final String back;
  final String name;
  final String nin;
  final String creation_date;

  final String surname;
  final String birth_date;
  final String expiry_date;
  final String document_number;
  const VerifyFace(
      {Key? key,
      required this.face,
      required this.name,
      required this.surname,
      required this.birth_date,
      required this.expiry_date,
      required this.document_number,
      required this.front,
      required this.back,
      required this.mrz,
      required this.nin,
      required this.creation_date})
      : super(key: key);

  @override
  State<VerifyFace> createState() => _VerifyFaceState();
}

class _VerifyFaceState extends State<VerifyFace> {
  late CameraController controller;
  var isRecording = false;
  bool _isShownFace = false;
  late File savedImage;
  bool _is_loading = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      cameras[1],
      ResolutionPreset.low,
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
    var headers = {'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0='};

    // String base64Image =
    //     "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";
    //create local temp file from 64based image
    // List<int> imageBytes = base64Decode(base64Image);
    // final tempDir = await getTemporaryDirectory();
    // final file =
    //     await File('${tempDir.path}/temp_image.png').writeAsBytes(imageBytes);

    /// Initialize Ip Address
    var ipAddress = IpAddress(type: RequestType.text);

    /// Get the IpAddress based on requestType.
    dynamic data = await ipAddress.getIpAddress();
    String ip = data.toString();
    print(data.toString());

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.icosnet.com/kyc_liveness/liveness?token=ffffffff&question=neutral&ip_adress=${ip}'));
    request.files.add(await http.MultipartFile.fromPath('video', link));
    request.files.add(await http.MultipartFile.fromPath('face', widget.face));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    print(answerJson);

    if (answerJson["decision"] == "True") {
      print("face ok");
      await prefs.setString('name', widget.name);
      await prefs.setString('surname', widget.surname);
      await prefs.setString('creation_date', widget.creation_date);
      await prefs.setString('birth_date', widget.birth_date);
      await prefs.setString('expiry_date', widget.expiry_date);
      await prefs.setString('nin', widget.nin);
      await prefs.setString('document_number', widget.document_number);
      await prefs.setString('idinfos', widget.name);

      controller.dispose();

      // await sendToAlfresco();

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => IdInfos()));
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
    var headers = {
      'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
      'Cookie': 'PHPSESSID=lfn533cru9ah04m0gbsc5hrahv'
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.icosnet.com/ibmpp/esb/ged_add_user_identification_who.php'));
    request.fields.addAll({
      'folder_name':
          '${widget.name}_${widget.surname}_${widget.document_number}',
      'mrz': widget.mrz
    });
    request.files
        .add(await http.MultipartFile.fromPath('image_recto', widget.front));
    request.files
        .add(await http.MultipartFile.fromPath('image_verso', widget.back));
    request.files
        .add(await http.MultipartFile.fromPath('image_face', widget.face));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);

    if (answerJson["status"] == "success") {
      print("Alfresco ok");

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => IdInfos(
              // name: widget.name,
              // surname: widget.surname,
              // creation_date: widget.birth_date,
              // birth_date: widget.birth_date,
              // expiry_date: widget.expiry_date,
              // nin: widget.nin,
              // document_number: widget.document_number,
              )));
      return true;
    } else {
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
