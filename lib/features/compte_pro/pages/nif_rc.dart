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
import 'package:whowiyati/features/compte_pro/widgets/custom_text_pro.dart';
import 'package:whowiyati/core/widgets/custom_main_button.dart';

import '../../../const.dart';
import '../../../core/utils/snackbar_message.dart';
import '../../../core/widgets/adaptive_circular_progress_indicator.dart';
import '../../../core/widgets/custom_image_logo.dart';
import 'steps_verify_compte_pro.dart';

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

  void takeNif() async {
    final picker = ImagePicker();
    final nifPhoto = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1920,
        imageQuality: 80);
    _is_loading = true;
    setState(() {});
    if (nifPhoto != null) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
        try {
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

          request.files.add(
              await http.MultipartFile.fromPath('document', nifPhoto.path));
          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {
            String answer = await response.stream.bytesToString();

            Map<String, dynamic> answerJson = jsonDecode(answer);

            Map<String, dynamic> detailData = answerJson["detail"];

            List validityList = detailData['validity'];

            if (listEquals(validityList, [])) {
              SnackBarMessage().showErrorSnackBar(
                  message: "Carte fiscale non valide, réessayez",
                  context: context);
            } else {
              await addDoc(nifPhoto.path);
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

  addDoc(String nifPath) async {
    try {
      var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

      var request = http.MultipartRequest('POST',
          Uri.parse('https://api.icosnet.com/sign/wh/add/company/doc/'));
      request.fields
          .addAll({'id_company': widget.companyId, 'doc_type': 'NIF'});

      request.files.add(await http.MultipartFile.fromPath('file', nifPath));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);
      print(answer);

      if (answerJson["success"] == true) {
        await prefs.setString("step", "4");
        SnackBarMessage().showSuccessSnackBar(
            message: "Votre carte fiscale est ajouté", context: context);
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
        SnackBarMessage().showErrorSnackBar(
            message: "Votre carte fiscale n'est pas ajouté, réessayez",
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
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color1,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Center(
          child: _is_loading == true
              ? AdaptiveCircularProgressIndicator(color: color3)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomImageLogo(width: 200),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.w, vertical: 10.h),
                            child: CustomTextPro(
                              data:
                                  "Mettez votre carte fiscale en position horizontale et votre téléphone en position verticale pour prendre une photo",
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 5.h),
                            child: CustomMainButton(
                              onPressed: () async {
                                takeNif();
                              },
                              text: 'Continuer',
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
