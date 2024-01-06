import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/compte_pro/steps_verify_compte_pro.dart';
import '../../const.dart';

class NifRC extends StatefulWidget {
  final String companyId;
  final String companyUserId;
  const NifRC({
    super.key,
    required this.companyId,
    required this.companyUserId,
  });

  @override
  State<NifRC> createState() => _NifRCState();
}

class _NifRCState extends State<NifRC> {
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

  void takeNif() async {
    final picker = ImagePicker();
    final nifPhoto =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    _is_loading = true;
    setState(() {});
    if (nifPhoto != null) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
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
                'https://api.icosnet.com/classifier/nif_nis_rc_classifier?token=${_myToken}&ip_adress=${ip}&document_types=nif'));

        request.files
            .add(await http.MultipartFile.fromPath('document', nifPhoto.path));
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String answer = await response.stream.bytesToString();

          Map<String, dynamic> answerJson = jsonDecode(answer);

          Map<String, dynamic> detailData = answerJson["detail"];

          List validityList = detailData['validity'];

          if (listEquals(validityList, [])) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Carte fiscale non valide, réessayez",
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 5),
                backgroundColor: colorRed,
              ),
            );
          } else {
            await addDoc(nifPhoto.path);
          }
        } else {
          print(response.reasonPhrase);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Une erreur s'est produite, réessayer"),
              duration: Duration(seconds: 5),
              backgroundColor: colorRed,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Veillez vérifier votre connection internet"),
            duration: Duration(seconds: 5),
            backgroundColor: colorRed,
          ),
        );
      }
    }
    _is_loading = false;
    setState(() {});
  }

  addDoc(String nifPath) async {
    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.icosnet.com/sign/wh/add/company/doc/'));
    request.fields.addAll({'id_company': widget.companyId, 'doc_type': 'NIF'});

    request.files.add(await http.MultipartFile.fromPath('file', nifPath));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    print(answer);

    if (answerJson["success"] == true) {
      await prefs.setString("step", "4");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Votre carte fiscale est ajouté"),
          duration: Duration(seconds: 5),
          backgroundColor: color3,
        ),
      );
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => StepsVerifyComptePro(
          companyId: widget.companyId,
          companyUserId: widget.companyUserId,
        ),
      ));
    } else {
      print(response.reasonPhrase);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Votre carte fiscale n'est pas ajouté, réessayez"),
          duration: Duration(seconds: 5),
          backgroundColor: colorRed,
        ),
      );
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
                      flex: 1,
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                          height: 150.h,
                          width: 200.w,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 10.h),
                            child: Text(
                              "Mettez votre carte fiscale en position horizontale et votre téléphone en position verticale pour prendre une photo",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
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
                                takeNif();
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
