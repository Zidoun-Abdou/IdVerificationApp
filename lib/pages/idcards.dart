import 'dart:convert';
import 'dart:io';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/idinfos.dart';
import 'package:whowiyati/pages/recto.dart';
import 'package:whowiyati/pages/verify_face.dart';

class IdCards extends StatefulWidget {
  final String token;

  const IdCards({Key? key, required this.token}) : super(key: key);

  @override
  State<IdCards> createState() => _IdCardsState();
}

class _IdCardsState extends State<IdCards> {
  bool? _is_loading = false;

  // void takePhotos() async {
  //   _is_loading = true;
  //   setState(() {});
  //   final picker = ImagePicker();
  //   final pickedFile1 = await picker.pickImage(
  //     source: ImageSource.camera,
  //   );
  //   final pickedFile2 = await picker.pickImage(
  //     source: ImageSource.camera,
  //   );

  //   if (pickedFile1 != null && pickedFile2 != null) {
  //     String _token = prefs.getString('mail').toString();

  //     var headers = {'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0='};
  //     var request = http.MultipartRequest(
  //         'POST',
  //         Uri.parse(
  //             'https://api.icosnet.com/kyc/algerian_id_card_detection_and_data_extraction_2_images_type_file?token=$_token'));
  //     request.files.add(await http.MultipartFile.fromPath(
  //       'front_image',
  //       pickedFile1.path,
  //     ));

  //     request.files.add(
  //         await http.MultipartFile.fromPath('back_image', pickedFile2.path));

  //     request.headers.addAll(headers);

  //     http.StreamedResponse response = await request.send();
  //     String answer = await response.stream.bytesToString();
  //     var answerJson = jsonDecode(answer);
  //     if (answerJson["mrz"]["decision"] == "mrz") {
  //       //"abdelkrim_nachef_121328643_face.png"
  //       String _base64img = "${answerJson["folder_name"]}_face.png";

  //       List<int> imageBytes = base64Decode(answerJson[_base64img]);
  //       final _tempDir = await getTemporaryDirectory();
  //       final _myFile = await File('${_tempDir.path}/temp_image.png')
  //           .writeAsBytes(imageBytes);
  //       await prefs.setString(
  //           'idinfos', answerJson["mrz"]["result"]["name"].toString());
  //       String name = answerJson["mrz"]["result"]["name"].toString();
  //       String surname = answerJson["mrz"]["result"]["surname"].toString();

  //       String country = answerJson["mrz"]["result"]["country"].toString();
  //       String nationality =
  //           answerJson["mrz"]["result"]["nationality"].toString() == "dza"
  //               ? "Algerien"
  //               : answerJson["mrz"]["result"]["nationality"].toString();
  //       String birth_date =
  //           answerJson["mrz"]["result"]["birth_date"].toString();
  //       String expiry_date =
  //           answerJson["mrz"]["result"]["expiry_date"].toString();
  //       String sex = answerJson["mrz"]["result"]["sex"].toString();
  //       String document_type =
  //           answerJson["mrz"]["result"]["document_type"].toString();
  //       String document_number =
  //           answerJson["mrz"]["result"]["document_number"].toString();
  //       //await prefs.setString('nin', document_number);
  //       // await _addtoportaone(document_number);

  //       /*Navigator.of(context).push(MaterialPageRoute(
  //           builder: (context) => IdInfo(
  //                 name: name,
  //                 surname: surname,
  //                 country: country,
  //                 nationality: nationality,
  //                 birth_date: birth_date,
  //                 expiry_date: expiry_date,
  //                 sex: sex,
  //                 document_type: document_type,
  //                 document_number: document_number,
  //                 token: widget.token,
  //               )));*/
  //       print("-------------------------------------------");
  //       print(_myFile.path);
  //       print("-------------------------------------------");
  //       Navigator.of(context).push(MaterialPageRoute(
  //           builder: (context) => VerifyFace(
  //                 face: _myFile.path,
  //               )));
  //       _is_loading = false;
  //       setState(() {});
  //     } else {
  //       print(answerJson.toString());

  //       print(response.reasonPhrase);
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(
  //             "non valid cards, try again",
  //             textAlign: TextAlign.center,
  //           ),
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //       _is_loading = false;
  //       setState(() {});
  //     }
  //     _is_loading = false;
  //     setState(() {});
  //   }
  //   _is_loading = false;
  //   setState(() {});
  // }

  /* Future<int> _addtoportaone(String idcard) async {
    _is_loading = true;
    setState(() {});
    var headers = {
      'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
    };
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://api.icosnet.com/ibmpp/esb/pbflow_account_create.php'));
    request.fields.addAll({'token': widget.token, 'type': 'nin', 'value': idcard});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (answerJson["success"] == true) {
      print(answerJson.toString());
      _is_loading = false;
      setState(() {});
      return 1;
    } else {
      print(answerJson.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            answerJson.toString(),
            textAlign: TextAlign.center,
          ),
          duration: Duration(seconds: 3),
        ),
      );
      _is_loading = false;
      setState(() {});
      return 0;
    }
    _is_loading = false;
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: Center(
          child: _is_loading == true
              ? CircularProgressIndicator()
              : Form(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            Center(
                              child: Image.asset(
                                'assets/images/logo.png',
                                // Replace with the actual path to your image file
                                fit: BoxFit.contain,
                                height: 150.h,
                                width: 150.w,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: Text(
                                "Pour vérifier votre carte d’identité la caméra du téléphone va se lancer vous permettant de scanner le recto et le verso  de votre carte d’identité",
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
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset(
                              'assets/images/id_card.png',
                              // Replace with the actual path to your image file
                              fit: BoxFit.fill,
                            ).animate().fade(delay: 1000.ms),
                            Positioned(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 8.h),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Recto()));
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
      ),
    );
  }
}
