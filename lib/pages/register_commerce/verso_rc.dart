import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../const.dart';
import 'nif_rc.dart';

class VersoRC extends StatefulWidget {
  const VersoRC({
    super.key,
  });

  @override
  State<VersoRC> createState() => _VersoRCState();
}

class _VersoRCState extends State<VersoRC> {
  // ============== Business Logic ==============
  bool _is_loading = false;
  String _myToken = "";

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      _myToken = value.toString();
    });
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void takeVerso() async {
    final picker = ImagePicker();
    final versoPhoto =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if (versoPhoto != null) {
      _is_loading = true;
      setState(() {});

      var ipAddress = IpAddress(type: RequestType.text);
      dynamic data = await ipAddress.getIpAddress();
      String ip = data.toString();

      var headers = {
        'Authorization': 'Basic ZHNpX3NlbGZjYXJlOmRzaV9zZWxmY2FyZQ==',
        'Content-Type':
            'multipart/form-data; boundary=<calculated when request is sent>'
      };

      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://api.icosnet.com/classifier/nif_nis_rc_classifier?token=${_myToken}&ip_adress=${ip}&document_types=rc.back'));

      request.files
          .add(await http.MultipartFile.fromPath('document', versoPhoto.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String answer = await response.stream.bytesToString();

        Map<String, dynamic> answerJson = jsonDecode(answer);

        Map<String, dynamic> detailData = answerJson["detail"];

        List validityList = detailData['validity'];

        if (listEquals(validityList, [])) {
          _is_loading = false;
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "registre de commerce non valid, try again",
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Back registre de commerce valid",
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 3),
            ),
          );

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NifRC(),
            ),
          );
        }
      } else {
        print(response.reasonPhrase);
      }
    }
  }

  // ============== User Interface ==============
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: Center(
          child: _is_loading == true
              ? CircularProgressIndicator(
                  color: color3,
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          height: 150.h,
                          width: 150.w,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 10.h),
                            child: Text(
                              "Mettez votre Verso Registre de commerce en position horizontale et votre téléphone en position verticale pour prendre une photo",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontFamily: 'Inter',
                                height: 1.1.h,
                                letterSpacing: 0.20.w,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 5.h),
                            child: ElevatedButton(
                              onPressed: () async {
                                takeVerso();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color3,
                                padding: EdgeInsets.symmetric(vertical: 15.h),
                                foregroundColor: Colors.white,
                                minimumSize: Size.fromHeight(30.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                elevation: 20,
                                shadowColor: color3, // Set the shadow color
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
                          )
                        ],
                      ),
                    ),
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
