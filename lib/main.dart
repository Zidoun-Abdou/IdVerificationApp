import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/pages/homepage.dart';
import 'package:whowiyati/pages/dealpad.dart';
import 'package:flutter/services.dart';
import 'package:whowiyati/pages/verify_face.dart';
import 'package:whowiyati/pages/welcomenfc.dart';

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    getToken();
    requestPermissionNotification();
  }

  // Get Token
  String _myToken = "";
  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      _myToken = value.toString();
      print("token : " + _myToken);
    });
  }

  // Notification Permission for ios
  requestPermissionNotification() async {
    // ignore: unused_local_variable
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: prefs.getString('login').toString() == "null" ||
                    prefs.getString('login') == "false"
                ? HomePage()
                : prefs.getString('pasword').toString() == "null"
                    ? DialpadScreen(
                        status: 1,
                      )
                    : DialpadScreen(
                        status: 3,
                      ),
            theme: ThemeData(
              bottomSheetTheme: BottomSheetThemeData(
                  backgroundColor: Colors.black.withOpacity(0.5)),
              fontFamily: "Rubik",
              canvasColor: Colors.white,
              accentColor: color3,
            ),
          );
        });
  }
}
