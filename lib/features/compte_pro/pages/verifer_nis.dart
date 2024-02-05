import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:whowiyati/const.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/snackbar_message.dart';
import '../../../core/widgets/adaptive_circular_progress_indicator.dart';
import '../../../core/widgets/custom_byicosnet_hint.dart';
import '../../../core/widgets/custom_image_logo.dart';
import '../../../core/widgets/custom_main_button.dart';
import '../../../core/widgets/custom_title_text.dart';
import '../../../main.dart';
import '../widgets/custom_alert_dialog.dart';
import 'nis_rc.dart';
import 'steps_verify_compte_pro.dart';

class VeriferNis extends StatefulWidget {
  final String companyId;
  final String companyUserId;
  const VeriferNis(
      {super.key, required this.companyId, required this.companyUserId});

  @override
  State<VeriferNis> createState() => _VeriferNisState();
}

class _VeriferNisState extends State<VeriferNis> {
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
        try {
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
                  'https://api.icosnet.com/classifier/nif_nis_rc_classifier?token=${_myToken}&ip_adress=${ip}&document_types=nis'));

          request.files
              .add(await http.MultipartFile.fromPath('document', document));
          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {
            String answer = await response.stream.bytesToString();

            Map<String, dynamic> answerJson = jsonDecode(answer);

            Map<String, dynamic> detailData = answerJson["detail"];

            List validityList = detailData['validity'];

            if (listEquals(validityList, [])) {
              SnackBarMessage().showErrorSnackBar(
                  message: "Carte statistique non valide, réessayez",
                  context: context);
            } else {
              await addDoc(document);
            }
          } else {
            print(response.reasonPhrase);
            SnackBarMessage().showErrorSnackBar(
                message: "Une erreur s'est produite, réessayer",
                context: context);
          }
        } on Exception {
          SnackBarMessage().showErrorSnackBar(
              message: "Quelque chose s'est mal passé, réessayez plus tard",
              context: context);
        }
      } else {
        SnackBarMessage().showErrorSnackBar(
            message: "Veillez vérifier votre connection internet",
            context: context);
      }
    }
    _is_loading = false;
    setState(() {});
  }

  addDoc(String docPath) async {
    try {
      var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

      var request = http.MultipartRequest('POST',
          Uri.parse('https://api.icosnet.com/sign/wh/add/company/doc/'));
      request.fields
          .addAll({'id_company': widget.companyId, 'doc_type': 'NIS'});

      request.files.add(await http.MultipartFile.fromPath('file', docPath));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);
      print(answer);

      if (answerJson["success"] == true) {
        await prefs.setString("step", "5");
        SnackBarMessage().showSuccessSnackBar(
            message: "Votre carte statistique est ajouté", context: context);
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => StepsVerifyComptePro(
            companyId: widget.companyId,
            companyUserId: widget.companyUserId,
          ),
        ));
      } else {
        print(response.reasonPhrase);
        SnackBarMessage().showErrorSnackBar(
            message: "Votre carte statistique n'est pas ajouté, réessayez",
            context: context);
      }
    } on Exception {
      SnackBarMessage().showErrorSnackBar(
          message: "Quelque chose s'est mal passé, réessayez plus tard",
          context: context);
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
                                    "Téleverser votre carte statistique\nau format PDF",
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
                                      builder: (context) => NisRC(
                                        companyId: widget.companyId,
                                        companyUserId: widget.companyUserId,
                                      ),
                                    ));
                                  },
                                  text:
                                      'Prendre une photo de la carte statistique',
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10.w),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // AJOUTER VALEUR
                                    Navigator.pop(context);
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          StepsVerifyComptePro(
                                        companyId: widget.companyId,
                                        companyUserId: widget.companyUserId,
                                      ),
                                    ));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.h),
                                    foregroundColor: Colors.white,
                                    minimumSize: Size.fromHeight(30.w),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(color: color3),
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Passer cette étape',
                                    style: TextStyle(
                                      color: color3,
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
