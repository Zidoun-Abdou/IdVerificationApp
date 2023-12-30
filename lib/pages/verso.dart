import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dmrtd/dmrtd.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/idinfos.dart';
import 'package:whowiyati/pages/verify_face.dart';
import 'package:whowiyati/pages/welcomenfc.dart';

class Verso extends StatefulWidget {
  final String rectoPath;

  const Verso({super.key, required this.rectoPath});

  @override
  State<Verso> createState() => _VersoState();
}

class _VersoState extends State<Verso> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  static const Duration durationToReverse = Duration(seconds: 3);
  static const Duration durationToForward = Duration(seconds: 1);
  static const Duration durationToChangeWidget = Duration(milliseconds: 50);
  bool? _is_loading = false;

  void takePhotos() async {
    _is_loading = true;
    setState(() {});
    final picker = ImagePicker();
    final versoPath =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

    if (widget.rectoPath != null && versoPath != null) {
      String _token = prefs.getString('mail').toString();

      var headers = {
        'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0=',
        'Content-Type':
            'multipart/form-data; boundary=<calculated when request is sent>'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('https://api.icosnet.com/whowiyati/Whowiyati_KYC/'));
      request.files.add(await http.MultipartFile.fromPath(
        'front_image',
        widget.rectoPath,
      ));

      request.files
          .add(await http.MultipartFile.fromPath('back_image', versoPath.path));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String answer = await response.stream.bytesToString();
      // Parse the JSON string.
      Map<String, dynamic> jsonData = json.decode(answer);
      // Extract the "result" part as a JSON string.
      String resultData = jsonEncode(['result']);
      // Create a new map with "result" as the key.
      Map<String, dynamic> outputMap = {"result": resultData};
      // Convert the map to a JSON string.
      String resultJson = jsonEncode(outputMap);

      var answerJson = jsonDecode(answer);
      if (answerJson["decision"] == true) {
        //"abdelkrim_nachef_121328643_face.png"
        String _face = "Face";
        String _front = "front_card";
        String _back = "back_card";
        String _signature = "signatur";

        print("------------------------------------------------------------");
        print(answerJson);
        print("------------------------------------------------------------");
        List<int> imageBytes_face = base64Decode(answerJson[_face]);
        List<int> imageBytes_front = base64Decode(answerJson[_front]);
        List<int> imageBytes_back = base64Decode(answerJson[_back]);
        List<int> imageBytes_signature = base64Decode(answerJson[_back]);

        await prefs.setString("face", answerJson[_face]);

        final _tempDir_face = await getTemporaryDirectory();
        final _tempDir_front = await getTemporaryDirectory();
        final _tempDir_back = await getTemporaryDirectory();
        final _tempDir_signature = await getTemporaryDirectory();

        final _myFile_face =
            await File('${_tempDir_face.path}/temp_image_face.png')
                .writeAsBytes(imageBytes_face);
        final _myFile_front =
            await File('${_tempDir_front.path}/temp_image_front_card.png')
                .writeAsBytes(imageBytes_front);
        final _myFile_back =
            await File('${_tempDir_back.path}/temp_image_back_card.png')
                .writeAsBytes(imageBytes_back);
        final _myFile_signature =
            await File('${_tempDir_signature.path}/temp_image__signature.png')
                .writeAsBytes(imageBytes_signature);
        //await prefs.setString('idinfos', answerJson["french_name"].toString());
        String name = answerJson["french_name"].toString();
        String surname = answerJson["french_surname"].toString();
        String nin = answerJson["id_number"].toString();
        String creation_date = answerJson["creation_date"].toString();
        String birth_date = answerJson["birth_date"].toString();
        String expiry_date = answerJson["expiration_date"].toString();
        String document_number = answerJson["card_number"].toString();
        await prefs.setString("surname_latin", surname);
        await prefs.setString("name_latin", name);
        await prefs.setString("birth_date", birth_date);
        await prefs.setString("nin", nin);
        await prefs.setString("deliv_date", creation_date);
        await prefs.setString("exp_date", expiry_date);
        await prefs.setString("document_number", document_number);

        NfcStatus status = await NfcProvider.nfcStatus;

        print(status.toString());

        if (status.toString() == "NfcStatus.notSupported") {
          print("NFC Step ignored");
          await prefs.setString("face", _myFile_face.path);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VerifyFace(
                    face: _myFile_face.path,
                    front: _myFile_front.path,
                    back: _myFile_back.path,
                    signature: _myFile_signature.path,
                  )));
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WelcomeNfc(
                face: _myFile_face.path,
                front: _myFile_front.path,
                back: _myFile_back.path,
                dob: birth_date,
                doe: expiry_date,
                idnumber: document_number,
                signature: _myFile_signature.path,
              ),
            ),
          );
        }

        _is_loading = false;
        setState(() {});
      } else {
        print(answerJson.toString());

        print(response.reasonPhrase);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "non valid cards, try again",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
          ),
        );

        _is_loading = false;
        setState(() {});
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      }
      _is_loading = false;
      setState(() {});
    }
    _is_loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    // Create an AnimationController with a duration of 3 seconds
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Create a Tween that goes from 0.0 to 1.0
    final tween = Tween<double>(begin: 0.0, end: 1.0);

    // Apply the tween to the controller
    _animation = tween.animate(_controller);

    // Add a delay of 2 seconds before starting the animation in reverse

    // Listen for animation status changes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // When the animation completes, reverse it
        Future.delayed(durationToReverse, () {
          _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(durationToForward, () {
          _controller.forward();
        });
        // When the animation is dismissed (reversed), start it again
      }
    });
    Future.delayed(durationToForward, () {
      _controller.forward();
    });
    // Start the animation
  }

  @override
  void dispose() {
    // Dispose of the animation controller when not needed
    _controller.dispose();
    super.dispose();
  }

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
              : Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/logo.png',
                                // Replace with the actual path to your image file
                                fit: BoxFit.contain,
                                height: 150.h,
                                width: 150.w,
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30.w),
                                    height: 280.h,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (_animation.value > 0.5)
                                          FadeTransition(
                                              opacity: _animation,
                                              child: Image.asset(
                                                "assets/images/G_PIC_icons.png",
                                                fit: BoxFit.fill,
                                              )),
                                        Transform.rotate(
                                            angle: (_animation.value - 1) *
                                                (0.5) *
                                                -pi,
                                            child: AnimatedCrossFade(
                                              duration: durationToChangeWidget,
                                              firstChild: Image.asset(
                                                "assets/images/Group 101.png",
                                              ),
                                              secondChild: RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Image.asset(
                                                    "assets/images/Group 100.png",
                                                  )),
                                              crossFadeState: _animation.value >
                                                      0.5
                                                  ? CrossFadeState.showFirst
                                                  : CrossFadeState.showSecond,
                                            ))
                                        //
                                      ],
                                    ));
                              },
                            ),
                          ],
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
                                "Mettez votre carte en position horizontale et votre téléphone en position verticale pour prendre une photo",
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
                                  takePhotos();
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
      ),
    );
  }
}
