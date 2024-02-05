import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/features/compte_pro/widgets/steps_verify_compte_pro/custom_align.dart';
import 'package:whowiyati/features/compte_pro/widgets/steps_verify_compte_pro/custom_etape.dart';
import 'package:whowiyati/core/widgets/custom_main_button.dart';
import 'package:whowiyati/core/widgets/custom_title_text.dart';
import '../../../const.dart';
import '../../../main.dart';
import '../../../core/widgets/custom_image_logo.dart';
import 'email.dart';
import 'idcards.dart';

class Steps extends StatefulWidget {
  final String token;

  const Steps({Key? key, required this.token}) : super(key: key);

  @override
  State<Steps> createState() => _StepsState();
}

class _StepsState extends State<Steps> {
  // ******************* Logic *******************
  bool isLoading = false;
  bool isPhoneNumberValid = false;
  String countryCode = "";

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
        child: Form(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: CustomImageLogo(width: 200),
              ),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 10.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Etapes vérifiées',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF00FF84),
                            fontSize: 14.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Column(
                          children: [
                            CustomEtape(
                              condition:
                                  int.parse(prefs.getString("status")!) >= 2,
                              title: 'Confirmation par téléphone\n',
                            ),
                            CustomAlign(),
                            CustomEtape(
                              condition:
                                  int.parse(prefs.getString("status")!) >= 3,
                              title: 'Confirmation par mail\n',
                            ),
                            CustomAlign(),
                            CustomEtape(
                              condition:
                                  int.parse(prefs.getString("status")!) == 5,
                              title: 'Confirmation par carte d’identité\n',
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomTitleText(
                        data:
                            "Suivez ces étapes pour compléter la validation\n de votre identité",
                        color: Colors.white,
                        size: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 8.h),
                        child: CustomMainButton(
                          onPressed: () {
                            if (int.parse(prefs.getString("status")!) == 2) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Email(
                                        token: widget.token,
                                      )));
                            } else if (int.parse(prefs.getString("status")!) ==
                                    3 ||
                                int.parse(prefs.getString("status")!) == 4) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => IdCards()));
                            }
                            // else if (prefs.getString('idinfos').toString() !=
                            //         "null" &&
                            //     prefs.getString('mail').toString() != "null") {
                            //   Navigator.of(context).push(
                            //     MaterialPageRoute(
                            //       builder: (context) => IdInfos(),
                            //     ),
                            //   );
                            // }
                          },
                          text: 'Continuer',
                        ),
                      ),
                    ],
                  )),
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
