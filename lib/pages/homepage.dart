import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/pages/conditions.dart';
import 'package:whowiyati/pages/login.dart';
import 'package:whowiyati/widgets/custom_main_button.dart';

import '../widgets/custom_bottom_text_welcome_hint.dart';
import '../widgets/custom_image_logo.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color2,
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Expanded(
              flex: 2,
              child: CustomImageLogo(width: 200),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  children: [
                    CustomBottomTextWelcomeHint(),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: CustomMainButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Conditions()));
                        },
                        text: "S\'inscrire",
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: CustomMainButton(
                        onPressed: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        text: 'Déjà identifié',
                        backgroundColor: Colors.grey[850],
                        elevation: 0,
                      ),
                    ),
                  ],
                ))
          ],
        )),
      ),
    );
  }
}
