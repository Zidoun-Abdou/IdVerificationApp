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
import 'package:whowiyati/widgets/custom_main_button.dart';
import 'package:whowiyati/widgets/custom_title_text.dart';
import '../../main.dart';
import '../../widgets/adaptive_circular_progress_indicator.dart';
import '../../widgets/compte_pro/custom_alert_dialog.dart';
import '../../widgets/custom_byicosnet_hint.dart';
import '../../widgets/custom_image_logo.dart';
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
  // ******************* Logic *******************

  bool _is_loading = false;
  String _myToken = "";

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
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
                backgroundColor: colorRed,
              ),
            );
          }
        } else {
          print(response.reasonPhrase);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Une erreur s'est produite, réessayer"),
              duration: Duration(seconds: 3),
              backgroundColor: colorRed,
            ),
          );
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
          duration: Duration(seconds: 3),
          backgroundColor: color3,
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
          duration: Duration(seconds: 3),
          backgroundColor: colorRed,
        ),
      );
    }
  }

  // ******************* Interface *******************
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: color1,
        appBar: AppBar(
          backgroundColor: color1,
          elevation: 0.0,
        ),
        body: WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog();
                });
            return false;
          },
          child: _is_loading == true
              ? Center(
                  child: AdaptiveCircularProgressIndicator(color: color3),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomImageLogo(width: 200),
                      ),
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomTitleText(
                                data:
                                    "Téleverser votre registre commerce\nau format PDF",
                                color: Colors.white,
                                size: 13,
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
                              CustomTitleText(
                                data: "OU",
                                color: Colors.white,
                                size: 15,
                              ),
                              SizedBox(height: 10.h),
                              Padding(
                                padding: EdgeInsets.all(10.w),
                                child: CustomMainButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => RectoRC(
                                        companyId: widget.companyId,
                                        companyUserId: widget.companyUserId,
                                      ),
                                    ));
                                  },
                                  text: 'Prendre une photo registre commerce',
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
                              CustomByIcosnetHint(),
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
