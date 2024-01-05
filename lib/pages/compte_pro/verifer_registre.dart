import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/pages/compte_pro/recto_rc.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import 'steps_verify_compte_pro.dart';

class VeriferRegitre extends StatefulWidget {
  final String companyId;
  final String companyUserId;
  const VeriferRegitre(
      {super.key, required this.companyId, required this.companyUserId});

  @override
  State<VeriferRegitre> createState() => _VeriferRegitreState();
}

class _VeriferRegitreState extends State<VeriferRegitre> {
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

  void takeDoc() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);
    _is_loading = true;
    setState(() {});
    if (result != null) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        PlatformFile file = result.files.first;
        String? filePath = file.path;
        String document = filePath.toString();

        var ipAddress = IpAddress(type: RequestType.text);
        dynamic data = await ipAddress.getIpAddress();
        String ip = data.toString();

        var headers = {
          'Authorization': 'Basic ZHNpX3NlbGZjYXJlOmRzaV9zZWxmY2FyZQ==',
          'Content-Type':
              'multipart/form-data; boundary=<calculated when request is sent>',
        };

        var request = http.MultipartRequest(
            'POST',
            Uri.parse(
                'https://api.icosnet.com/classifier/nif_nis_rc_classifier?token=${_myToken}&ip_adress=${ip}&document_types=rc.front-rc.back'));

        request.files
            .add(await http.MultipartFile.fromPath('document', document));
        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          String answer = await response.stream.bytesToString();

          Map<String, dynamic> answerJson = jsonDecode(answer);

          Map<String, dynamic> detailData = answerJson["detail"];

          List validityList = detailData['validity'];

          if (listEquals(validityList, ["rc.front", "rc.back"])) {
            await addDoc(document);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Registre commerce non valide, réessayez",
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 3),
              ),
            );
          }
        } else {
          print(response.reasonPhrase);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Une erreur s'est produite, réessayer"),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Veillez vérifier votre connection internet"),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
    _is_loading = false;
    setState(() {});
  }

  addDoc(String docPath) async {
    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.icosnet.com/sign/wh/add/company/doc/'));
    request.fields.addAll({'id_company': widget.companyId, 'doc_type': 'RC'});

    request.files.add(await http.MultipartFile.fromPath('file', docPath));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    print(answer);

    if (answerJson["success"] == true) {
      await prefs.setString("step", "3");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Votre regitre commerce est ajouté"),
          duration: Duration(seconds: 5),
        ),
      );
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
          content: Text("Votre regitre commerce n'est pas ajouté, réessayez"),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: color1,
        body: WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: color4.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.r))),
                    content: Text(
                      'Si vous quittez maintenant, les modifications\neffectuées ne seront pas enregistrées',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
                    actionsAlignment: MainAxisAlignment.center,
                    actionsPadding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          fixedSize: Size(100.w, 40.h),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD32424),
                          foregroundColor: Colors.white,
                          fixedSize: Size(100.w, 40.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          elevation: 20,
                          shadowColor: Color(0xFFD32424),
                        ),
                        child: Text(
                          'Quitter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  );
                });
            return false;
          },
          child: _is_loading == true
              ? Center(
                  child: CircularProgressIndicator(
                    color: color3,
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            // Replace with the actual path to your image file
                            fit: BoxFit.contain,
                            height: 100.h,
                            width: 200
                                .w, // Adjust the image's fit property as needed
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Téleverser votre registre commerce\nau format PDF",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  height: 1.1.h,
                                  letterSpacing: 0.20.w,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              GestureDetector(
                                onTap: () {
                                  takeDoc();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(10.w),
                                  child: Image.asset(
                                    "assets/images/upload_file.png",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                "OU",
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
                              SizedBox(height: 10.h),
                              Padding(
                                padding: EdgeInsets.all(10.w),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => RectoRC(
                                        companyId: widget.companyId,
                                        companyUserId: widget.companyUserId,
                                      ),
                                    ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color3,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.h),
                                    foregroundColor: Colors.white,
                                    minimumSize: Size.fromHeight(30.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    elevation: 20,
                                    shadowColor: color3,
                                  ),
                                  child: Text(
                                    'Prendre une photo registre commerce',
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
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text.rich(
                                TextSpan(children: [
                                  TextSpan(
                                      text: 'WHOWIATY',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600)),
                                  TextSpan(
                                    text: ' by icosnet',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Colors.white),
                                  ),
                                ]),
                              ),
                              SizedBox(height: 20.h),
                            ],
                          )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
