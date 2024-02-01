import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dmrtd/dmrtd.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:logging/logging.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whowiyati/const.dart';
import 'package:dmrtd/dmrtd.dart';
import 'package:dmrtd/extensions.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:whowiyati/pages/verify_face.dart';

import '../main.dart';
import '../widgets/adaptive_circular_progress_indicator.dart';

class MrtdData {
  EfCardAccess? cardAccess;
  EfCardSecurity? cardSecurity;
  EfCOM? com;
  EfSOD? sod;
  EfDG1? dg1;
  EfDG2? dg2;
  EfDG3? dg3;
  EfDG4? dg4;
  EfDG5? dg5;
  EfDG6? dg6;
  EfDG7? dg7;
  EfDG8? dg8;
  EfDG9? dg9;
  EfDG10? dg10;
  EfDG11? dg11;
  EfDG12? dg12;
  EfDG13? dg13;
  EfDG14? dg14;
  EfDG15? dg15;
  EfDG16? dg16;
  Uint8List? aaSig;
}

String formatProgressMsg(String message, int percentProgress) {
  final p = (percentProgress / 20).round();
  final full = "🟢 " * p;
  final empty = "⚪️ " * (5 - p);
  return message + "\n\n" + full + empty;
}

class ReadNfc extends StatefulWidget {
  final String dob;
  final String doe;
  final String idnumber;
  final String face;
  final String front;
  final String back;
  final String signature;

  const ReadNfc(
      {Key? key,
      required this.dob,
      required this.doe,
      required this.idnumber,
      required this.face,
      required this.front,
      required this.back,
      required this.signature})
      : super(key: key);

  @override
  State<ReadNfc> createState() => _ReadNfcState();
}

class _ReadNfcState extends State<ReadNfc> {
  // ******************* Logic *******************
  var _alertMessage = "";
  final _log = Logger("mrtdeg.app");
  var _isNfcAvailable = false;
  var _isReading = false;
  bool _isLoading = false;
  String _myToken = "";

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      _myToken = value.toString();
      print(_myToken);
    });
  }

  MrtdData? _mrtdData;

  final NfcProvider _nfc = NfcProvider();

  // ignore: unused_field
  late Timer _timerStateUpdater;
  final _scrollController = ScrollController();
  bool? _is_loading = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _initPlatformState();
    _timerStateUpdater = Timer.periodic(Duration(seconds: 2), (Timer t) {
      _initPlatformState();
    });
    getToken();
  }

  Future<void> _initPlatformState() async {
    bool isNfcAvailable;
    try {
      NfcStatus status = await NfcProvider.nfcStatus;
      isNfcAvailable = status == NfcStatus.enabled;
    } on PlatformException {
      isNfcAvailable = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isNfcAvailable = isNfcAvailable;
    });
  }

  DateTime? _getDOBDate() {
    if (widget.dob == null) {
      return null;
    }
    return DateFormat.yMd().parse(widget.dob);
  }

  DateTime? _getDOEDate() {
    if (widget.doe == null) {
      return null;
    }
    return DateFormat.yMd().parse(widget.doe);
  }

  void _readMRTD() async {
    try {
      setState(() {
        _mrtdData = null;
        _alertMessage =
            "Veuillez placer votre carte d'identité derrière votre téléphone";
        _isReading = true;
      });

      await _nfc.connect(
          // iosAlertMessage: "Hold your phone near Biometric IdCard",
          );
      final passport = Passport(_nfc);

      setState(() {
        _alertMessage = "Lecture de la Carte d'Identité en cours ...";
      });

      final mrtdData = MrtdData();

      _nfc.setIosAlertMessage("Trying to read EF.CardAccess ...");

      try {
        mrtdData.cardAccess = await passport.readEfCardAccess();
      } on PassportError {
        //if (e.code != StatusWord.fileNotFound) rethrow;
      }

      _nfc.setIosAlertMessage("Trying to read EF.CardSecurity ...");

      try {
        mrtdData.cardSecurity = await passport.readEfCardSecurity();
      } on PassportError {
        //if (e.code != StatusWord.fileNotFound) rethrow;
      }

      _nfc.setIosAlertMessage("Initiating session ...");
      final bacKeySeed =
          DBAKeys(widget.idnumber, _getDOBDate()!, _getDOEDate()!);
      await passport.startSession(bacKeySeed);

      _nfc.setIosAlertMessage(formatProgressMsg("Reading EF.COM ...", 0));
      mrtdData.com = await passport.readEfCOM();

      _nfc.setIosAlertMessage(formatProgressMsg("Reading Data Groups ...", 20));

      if (mrtdData.com!.dgTags.contains(EfDG1.TAG)) {
        mrtdData.dg1 = await passport.readEfDG1();
      }

      if (mrtdData.com!.dgTags.contains(EfDG2.TAG)) {
        mrtdData.dg2 = await passport.readEfDG2();
      }

      // To read DG3 and DG4 session has to be established with CVCA certificate (not supported).
      // if(mrtdData.com!.dgTags.contains(EfDG3.TAG)) {
      //   mrtdData.dg3 = await passport.readEfDG3();
      // }

      // if(mrtdData.com!.dgTags.contains(EfDG4.TAG)) {
      //   mrtdData.dg4 = await passport.readEfDG4();
      // }

      if (mrtdData.com!.dgTags.contains(EfDG5.TAG)) {
        mrtdData.dg5 = await passport.readEfDG5();
      }

      if (mrtdData.com!.dgTags.contains(EfDG6.TAG)) {
        mrtdData.dg6 = await passport.readEfDG6();
      }

      if (mrtdData.com!.dgTags.contains(EfDG7.TAG)) {
        mrtdData.dg7 = await passport.readEfDG7();
      }

      if (mrtdData.com!.dgTags.contains(EfDG8.TAG)) {
        mrtdData.dg8 = await passport.readEfDG8();
      }

      if (mrtdData.com!.dgTags.contains(EfDG9.TAG)) {
        mrtdData.dg9 = await passport.readEfDG9();
      }

      if (mrtdData.com!.dgTags.contains(EfDG10.TAG)) {
        mrtdData.dg10 = await passport.readEfDG10();
      }

      if (mrtdData.com!.dgTags.contains(EfDG11.TAG)) {
        mrtdData.dg11 = await passport.readEfDG11();
      }

      if (mrtdData.com!.dgTags.contains(EfDG12.TAG)) {
        mrtdData.dg12 = await passport.readEfDG12();
      }

      if (mrtdData.com!.dgTags.contains(EfDG13.TAG)) {
        mrtdData.dg13 = await passport.readEfDG13();
      }

      if (mrtdData.com!.dgTags.contains(EfDG14.TAG)) {
        mrtdData.dg14 = await passport.readEfDG14();
      }

      if (mrtdData.com!.dgTags.contains(EfDG15.TAG)) {
        mrtdData.dg15 = await passport.readEfDG15();
        _nfc.setIosAlertMessage(formatProgressMsg("Doing AA ...", 60));
        mrtdData.aaSig = await passport.activeAuthenticate(Uint8List(8));
      }

      if (mrtdData.com!.dgTags.contains(EfDG16.TAG)) {
        mrtdData.dg16 = await passport.readEfDG16();
      }

      _nfc.setIosAlertMessage(formatProgressMsg("Reading EF.SOD ...", 80));
      mrtdData.sod = await passport.readEfSOD();

      setState(() {
        _mrtdData = mrtdData;
      });

      setState(() {
        _alertMessage = "";
      });

      /*_scrollController.animateTo(300.0,
        duration: Duration(milliseconds: 10000), curve: Curves.ease
      );*/
    } on Exception catch (e) {
      final se = e.toString().toLowerCase();
      String alertMsg =
          "Une erreur s'est produite lors de la lecture de la carte d'identité!, Veuillez réessayer";
      if (e is PassportError) {
        if (se.contains("security status not satisfied")) {
          alertMsg =
              "Failed to initiate session with IdCard.\nCheck input data!";
        }
        _log.error("IdCardError: ${e.message}");
      } else {
        _log.error(
            "An exception was encountered while trying to read IdCard: $e");
      }

      if (se.contains('timeout')) {
        alertMsg = "Délai de lecture écoulé, veuillez réessayer";
      } else if (se.contains("tag was lost")) {
        alertMsg = "Tag was lost. Please try again!";
      } else if (se.contains("invalidated by user")) {
        alertMsg = "";
      }

      setState(() {
        _alertMessage = alertMsg;
      });
    } finally {
      if (_alertMessage.isNotEmpty) {
        await _nfc.disconnect(iosErrorMessage: _alertMessage);
      } else {
        await _nfc.disconnect(
            iosAlertMessage: formatProgressMsg("Finished", 100));
      }
      setState(() {
        _isReading = false;
      });
    }

    if (_mrtdData != null) {
      await sendInfo();
    }
  }

  Future sendInfo() async {
    _isLoading = true;
    setState(() {});
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic YXBpc3J2OmxvcmVtaXBzdW0='
    };
    var request = http.Request(
        'POST',
        Uri.parse(
            'https://api.icosnet.com/kyc/decode_dg_idcard?token=${_myToken}'));
    request.body = json.encode({
      "dg11": _mrtdData!.dg11!.toBytes().hex(),
      "dg12": _mrtdData!.dg12!.toBytes().hex(),
      "dg7": _mrtdData!.dg7!.toBytes().hex(),
      "dg2": _mrtdData!.dg2!.toBytes().hex()
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);

    if (answerJson["dg12"]["result"] == "True") {
      print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      print("succes");
      print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

      await prefs.setString("daira", answerJson["dg12"]["daira"]);
      await prefs.setString(
          "baladia_latin", answerJson["dg12"]["baladia_latin"]);
      await prefs.setString("baladia_arab", answerJson["dg12"]["baladia_arab"]);
      await prefs.setString("deliv_date", answerJson["dg12"]["deliv_date"]);
      await prefs.setString("exp_date", answerJson["dg12"]["exp_date"]);

      // print(answerJson["dg12"]["daira"].toString());
    } else {
      print("---------------------------------------------------------------");
      print(response.reasonPhrase);
    }
    if (answerJson["dg11"]["result"] == "True") {
      print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      await prefs.setString(
          "surname_latin", answerJson["dg11"]["surname_latin"]);
      await prefs.setString(
          "surname_arabic", answerJson["dg11"]["surname_arabic"]);
      await prefs.setString("name_latin", answerJson["dg11"]["name_latin"]);
      await prefs.setString("name_arabic", answerJson["dg11"]["name_arabic"]);
      await prefs.setString(
          "birthplace_latin", answerJson["dg11"]["birthplace_latin"]);
      await prefs.setString(
          "birthplace_arabic", answerJson["dg11"]["birthplace_arabic"]);
      await prefs.setString("birth_date", answerJson["dg11"]["birth_date"]);
      await prefs.setString("sexe_latin", answerJson["dg11"]["sexe_latin"]);
      await prefs.setString("sexe_arabic", answerJson["dg11"]["sex_arabic"]);
      await prefs.setString("blood_type", answerJson["dg11"]["blood_type"]);
      await prefs.setString("nin", answerJson["dg11"]["nin"]);
      await prefs.setString('idinfos', answerJson["dg11"]["nin"]);

      print(answerJson["dg12"]["daira"].toString());
    } else {
      print("---------------------------------------------------------------");
      print(response.reasonPhrase);
    }
    if (answerJson["dg2"]["result"] == "True") {
      print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      await prefs.setString("face", answerJson["dg2"]["face"]);

      // print(answerJson["dg12"]["daira"].toString());
    } else {
      print("---------------------------------------------------------------");
      print(response.reasonPhrase);
    }
    if (answerJson["dg7"]["result"] == "True") {
      print("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      await prefs.setString("signature", answerJson["dg7"]["signature"]);

      // print(answerJson["dg12"]["daira"].toString());
    } else {
      print("---------------------------------------------------------------");
      print(response.reasonPhrase);
    }
    if (answerJson["dg12"]["result"] == "True" &&
        answerJson["dg11"]["result"] == "True" &&
        answerJson["dg2"]["result"] == "True" &&
        answerJson["dg7"]["result"] == "True") {
      Timer(Duration(seconds: 1), () {});
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => CardNfcInfo()),
      // );

      List<int> imageBytes_face = base64Decode(answerJson["dg2"]["face"]);
      final _tempDir_face = await getTemporaryDirectory();
      final _myFile_face =
          await File('${_tempDir_face.path}/temp_image_face.png')
              .writeAsBytes(imageBytes_face);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => VerifyFace(
                face: _myFile_face.path,
                front: widget.front,
                back: widget.back,
                signature: widget.signature,
              )));
      _isLoading = false;
      setState(() {});
    }
  }

  void _openNFCSettings() {
    final intent = AndroidIntent(
      action: 'android.settings.NFC_SETTINGS',
    );
    intent.launch();
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
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Text(
                            "Validation Via NFC",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.20.w,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Text(
                            "Cette action nécessite l’activation de l’NFC",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.20.w,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: !_isNfcAvailable,
                          child: GestureDetector(
                            onTap: () {
                              _openNFCSettings();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 5.h),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Text(
                                _isNfcAvailable
                                    ? " "
                                    : "Veuillez activer votre NFC ici",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.20.w,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/nfcphone.png',
                          fit: BoxFit.fill,
                        ),
                        Visibility(
                          visible: _isNfcAvailable,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 8.h),
                            child: ElevatedButton(
                              onPressed: _readMRTD,
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
                                  _isReading ? 'Reading ...' : 'Read IdCard'),
                            ),
                          ),
                        ),
                        Text(_alertMessage,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(
                          height: 30.h,
                        ),
                      ],
                    ),
                    Positioned(
                        top: 200.h,
                        child: Container(
                          height: 150.h,
                          width: 300.w,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.r),
                              color: Colors.grey.withOpacity(0.5)),
                          child: Center(
                            child: LoadingAnimationWidget.beat(
                              color: _isNfcAvailable ? color3 : Colors.white,
                              size: 40.sp,
                            ),
                          ),
                        ))
                  ],
                ),
        ),
      ),
    );
  }
}
