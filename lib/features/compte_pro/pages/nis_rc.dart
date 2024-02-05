import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whowiyati/core/utils/snackbar_message.dart';

import '../../../const.dart';
import '../../../core/widgets/adaptive_circular_progress_indicator.dart';
import '../../../core/widgets/custom_image_logo.dart';
import '../../../core/widgets/custom_main_button.dart';
import '../../../main.dart';
import '../widgets/custom_text_pro.dart';
import 'steps_verify_compte_pro.dart';

class NisRC extends StatefulWidget {
  final String companyId;
  final String companyUserId;
  const NisRC({
    super.key,
    required this.companyId,
    required this.companyUserId,
  });

  @override
  State<NisRC> createState() => _NisRCState();
}

class _NisRCState extends State<NisRC> {
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

  void takeNis() async {
    final picker = ImagePicker();
    final nisPhoto = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1920,
        imageQuality: 80);
    _is_loading = true;
    setState(() {});
    if (nisPhoto != null) {
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
                  'https://api.icosnet.com/classifier/nif_nis_rc_classifier?token=${_myToken}&ip_adress=${ip}&document_types=nis'));

          request.files.add(
              await http.MultipartFile.fromPath('document', nisPhoto.path));
          request.headers.addAll(headers);

          http.StreamedResponse response = await request.send();

          if (response.statusCode == 200) {
            String answer = await response.stream.bytesToString();

            Map<String, dynamic> answerJson = jsonDecode(answer);

            Map<String, dynamic> detailData = answerJson["detail"];

            List validityList = detailData['validity'];

            if (listEquals(validityList, [])) {
              SnackBarMessage().showErrorSnackBar(
                  message: "Carte statistique non valid, réessayez",
                  context: context);
            } else {
              await addDoc(nisPhoto.path);
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

  addDoc(String nisPath) async {
    try {
      var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

      var request = http.MultipartRequest('POST',
          Uri.parse('https://api.icosnet.com/sign/wh/add/company/doc/'));

      request.fields
          .addAll({'id_company': widget.companyId, 'doc_type': 'NIS'});

      request.files.add(await http.MultipartFile.fromPath('file', nisPath));

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
                                  "Mettez votre carte statistique en position horizontale et votre téléphone en position verticale pour prendre une photo",
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 5.h),
                            child: CustomMainButton(
                              onPressed: () async {
                                takeNis();
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
