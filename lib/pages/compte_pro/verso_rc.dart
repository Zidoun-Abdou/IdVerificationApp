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
import 'package:whowiyati/widgets/compte_pro/custom_text_pro.dart';
import 'package:whowiyati/widgets/custom_main_button.dart';
import 'package:whowiyati/widgets/custom_title_text.dart';
import '../../const.dart';
import '../../widgets/adaptive_circular_progress_indicator.dart';
import '../../widgets/custom_image_logo.dart';
import 'steps_verify_compte_pro.dart';

class VersoRC extends StatefulWidget {
  final String companyId;
  final String companyUserId;
  final String rectoPath;
  const VersoRC(
      {super.key,
      required this.rectoPath,
      required this.companyId,
      required this.companyUserId});

  @override
  State<VersoRC> createState() => _VersoRCState();
}

class _VersoRCState extends State<VersoRC> {
  //// ******************* Logic *******************
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
    final versoPhoto = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1920,
        imageQuality: 80);
    _is_loading = true;
    setState(() {});
    if (versoPhoto != null) {
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
                'https://api.icosnet.com/classifier/nif_nis_rc_classifier?token=${_myToken}&ip_adress=${ip}&document_types=rc.back'));

        request.files.add(
            await http.MultipartFile.fromPath('document', versoPhoto.path));
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
                  "Registre de commerce non valide, réessayez",
                  textAlign: TextAlign.center,
                ),
                duration: Duration(seconds: 3),
                backgroundColor: colorRed,
              ),
            );
          } else {
            await addDoc(versoPhoto.path);
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

  addDoc(String vectoPath) async {
    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.icosnet.com/sign/wh/add/company/doc/'));
    request.fields.addAll({'id_company': widget.companyId, 'doc_type': 'RC'});

    request.files
        .add(await http.MultipartFile.fromPath('file', widget.rectoPath));
    request.files.add(await http.MultipartFile.fromPath('file', vectoPath));

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
                                    "Mettez votre fond registre commerce en position horizontale et votre téléphone en position verticale pour prendre une photo",
                                color: Colors.white,
                                size: 14),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 5.h),
                            child: CustomMainButton(
                              onPressed: () async {
                                takeVerso();
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
