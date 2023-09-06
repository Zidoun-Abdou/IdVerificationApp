import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whowiyati/pages/conditions.dart';
import 'package:whowiyati/pages/email.dart';
import 'package:whowiyati/pages/homepage.dart';
import 'package:whowiyati/pages/idcards.dart';
import 'package:whowiyati/pages/login.dart';
import 'package:whowiyati/pages/nif.dart';
import 'package:whowiyati/pages/otp.dart';
import 'package:whowiyati/pages/phone.dart';
import 'package:whowiyati/pages/phone_ok.dart';
import 'package:whowiyati/pages/recto.dart';
import 'package:whowiyati/pages/register.dart';
import 'package:whowiyati/pages/steps.dart';
import 'package:whowiyati/pages/test.dart';
import 'package:whowiyati/pages/testing.dart';
import 'package:whowiyati/pages/verification_code.dart';
import 'package:whowiyati/pages/verify_face.dart';
import 'package:whowiyati/pages/verso.dart';
import 'package:whowiyati/pages/welcome.dart';
import 'package:flutter/services.dart';

late SharedPreferences prefs;
late List<CameraDescription> cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  prefs = await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: IdCards(token: "11111111111"),
          );
        });
  }
}
