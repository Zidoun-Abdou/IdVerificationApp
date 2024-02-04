import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:dmrtd/dmrtd.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../const.dart';
import '../main.dart';
import '../widgets/adaptive_circular_progress_indicator.dart';
import '../widgets/custom_image_logo.dart';
import '../widgets/custom_main_button.dart';
import '../widgets/custom_title_text.dart';
import 'verify_face.dart';
import 'welcomenfc.dart';

class Verso extends StatefulWidget {
  final XFile rectoPhoto;

  const Verso({super.key, required this.rectoPhoto});

  @override
  State<Verso> createState() => _VersoState();
}

class _VersoState extends State<Verso> with TickerProviderStateMixin {
  // ******************* Logic *******************
  late AnimationController _controller;
  late Animation<double> _animation;

  static const Duration durationToReverse = Duration(seconds: 3);
  static const Duration durationToForward = Duration(seconds: 1);
  static const Duration durationToChangeWidget = Duration(milliseconds: 50);
  bool? _is_loading = false;

  Future<File> cropImage(
      String imagePath, List response, String imageNamePath) async {
    int x = response[0];
    int y = response[1];
    int width = response[2] - x;
    int height = response[3] - y;

    File imageFile = File(imagePath);

    ui.Image decodedImage =
        await decodeImageFromList(imageFile.readAsBytesSync());

    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);

    Rect src = Rect.fromPoints(Offset(x.toDouble(), y.toDouble()),
        Offset((x + width).toDouble(), (y + height).toDouble()));
    Rect dst = Rect.fromPoints(
        Offset(0, 0), Offset(width.toDouble(), height.toDouble()));

    canvas.drawImageRect(decodedImage, src, dst, Paint());

    ui.Picture picture = recorder.endRecording();
    ui.Image croppedImage = await picture.toImage(width, height);

    return await saveCroppedImage(croppedImage, imageNamePath);
  }

  Future<File> saveCroppedImage(ui.Image croppedImage, String imageName) async {
    ByteData? byteData =
        await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List buffer = byteData!.buffer.asUint8List();

    Directory tempDir = await getTemporaryDirectory();
    File tempFile = File('${tempDir.path}/$imageName.png');
    print("file path = ${tempFile.path}");
    await tempFile.writeAsBytes(buffer);

    return tempFile;
  }

  Future<bool> verifyNin(String nin) async {
    var headers2 = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

    var request2 = http.MultipartRequest(
        'PUT', Uri.parse('https://api.icosnet.com/sign/wh/verify/nin/'));

    request2.fields.addAll({
      'phone': prefs.getString('phone').toString(),
      'user_id': prefs.getString('user_id').toString(),
      'email': prefs.getString('mail').toString(),
      'nin': nin
    });

    request2.headers.addAll(headers2);

    http.StreamedResponse response2 = await request2.send();

    try {
      String answer2 = await response2.stream.bytesToString();

      var answerJs2 = jsonDecode(answer2);

      return answerJs2["status"];
    } catch (e) {
      return false;
    }
  }

  void takePhotos() async {
    _is_loading = true;
    setState(() {});
    final picker = ImagePicker();
    final versoPhoto = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1920,
        imageQuality: 80);

    if (versoPhoto != null) {
      var headers = {
        'Authorization': 'Basic ZHNpX3NlbGZjYXJlOmRzaV9zZWxmY2FyZQ==',
        'Content-Type':
            'multipart/form-data; boundary=<calculated when request is sent>'
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('https://api.icosnet.com/whowiyati/Whowiyati_KYC/'));
      request.files.add(await http.MultipartFile.fromPath(
          'front_image', widget.rectoPhoto.path));

      request.files.add(
          await http.MultipartFile.fromPath('back_image', versoPhoto.path));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String answer = await response.stream.bytesToString();
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

        // ==========================
        final _myFile_front = await cropImage(widget.rectoPhoto.path,
            answerJson[_front], "temp_image_front_card");
        print(_myFile_front.path);

        final _myFile_face = await cropImage(
            _myFile_front.path, answerJson[_face], "temp_image_face");
        print(_myFile_face.path);

        final _myFile_back = await cropImage(
            versoPhoto.path, answerJson[_back], "temp_image_back_card");
        print(_myFile_back.path);

        // final _myFile_signature = await cropImage(
        //     _myFile_back.path, answerJson[_signature], "temp_image__signature");
        // print(_myFile_signature.path);
        // ==========================

        // **************************
        // List<int> imageBytes_face = base64Decode(answerJson[_face]);
        // List<int> imageBytes_front = base64Decode(answerJson[_front]);
        // List<int> imageBytes_back = base64Decode(answerJson[_back]);
        List<int> imageBytes_signature = base64Decode(answerJson[_signature]);

        // await prefs.setString("face", answerJson[_face]);

        // final _tempDir_face = await getTemporaryDirectory();
        // final _tempDir_front = await getTemporaryDirectory();
        // final _tempDir_back = await getTemporaryDirectory();
        final _tempDir_signature = await getTemporaryDirectory();

        // final _myFile_face =
        //     await File('${_tempDir_face.path}/temp_image_face.png')
        //         .writeAsBytes(imageBytes_face);
        // print(_myFile_face.path);
        // final _myFile_front =
        //     await File('${_tempDir_front.path}/temp_image_front_card.png')
        //         .writeAsBytes(imageBytes_front);
        // print(_myFile_front.path);
        // final _myFile_back =
        //     await File('${_tempDir_back.path}/temp_image_back_card.png')
        //         .writeAsBytes(imageBytes_back);
        // print(_myFile_back.path);
        final _myFile_signature =
            await File('${_tempDir_signature.path}/temp_image__signature.png')
                .writeAsBytes(imageBytes_signature);
        print(_myFile_signature.path);
        // **************************

        //await prefs.setStrin.pathg('idinfos', answerJson["french_name"].toString());
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

        // ******** send Phone and UserId and Email and Nin & Set Status 4
        bool _isSuccess = false;
        if (prefs.getString("status").toString() == "3") {
          _isSuccess = await verifyNin(nin);
        } else if (prefs.getString("status").toString() == "4") {
          _isSuccess = true;
        }

        if (_isSuccess == true) {
          await prefs.setString("status", "4");
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
          print(response.reasonPhrase);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Utilisateur non trouvé",
                textAlign: TextAlign.center,
              ),
              duration: Duration(seconds: 3),
              backgroundColor: colorRed,
            ),
          );

          _is_loading = false;
          setState(() {});
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        }
      } else {
        print(answerJson.toString());

        print(response.reasonPhrase);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Cartes non valides, réessayez",
              textAlign: TextAlign.center,
            ),
            duration: Duration(seconds: 3),
            backgroundColor: colorRed,
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
              : Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            CustomImageLogo(width: 150),
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
                              child: CustomTitleText(
                                data:
                                    "Mettez votre carte en position horizontale et votre téléphone en position verticale pour prendre une photo",
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 5.h),
                                child: CustomMainButton(
                                  onPressed: () async {
                                    takePhotos();
                                  },
                                  text: 'Continuer',
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
