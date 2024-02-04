import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/widgets/custom_main_button.dart';

import '../../const.dart';
import '../../widgets/custom_bottom_text_hint.dart';
import '../../widgets/custom_title_text.dart';

class Reinitialisation extends StatelessWidget {
  const Reinitialisation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color1,
        elevation: 0.0,
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    "Réinitialisation\nterminée !",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.1.h,
                      letterSpacing: 0.20.w,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomTitleText(
                        data:
                            "Votre mot de passe a été réinitialisé avec succès.\nVous pouvez maintenant vous connecter à votre\ncompte en utilisant le nouveau mot de passe.",
                        color: Colors.grey,
                        size: 13),
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 2,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: CustomMainButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        text: "Connexion",
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomBottomTextHint(),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
