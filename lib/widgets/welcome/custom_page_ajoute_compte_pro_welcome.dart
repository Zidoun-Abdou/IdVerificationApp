import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/widgets/custom_main_button.dart';
import 'package:whowiyati/widgets/custom_title_text.dart';
import 'package:whowiyati/widgets/welcome/custom_cancel_button.dart';

import '../../const.dart';
import '../../pages/compte_pro/ajoute_compte_pro.dart';
import '../custom_byicosnet_hint.dart';

class CustomPageAjouteCompteProWelcome extends StatelessWidget {
  const CustomPageAjouteCompteProWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration:
            BoxDecoration(border: Border(top: BorderSide(color: color4))),
        child: Padding(
          padding: EdgeInsets.all(15.h),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: CustomCancelButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Positioned(
                top: 90.h,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    CustomTitleText(
                      data:
                          "Souhaitez-vous ajouter un  compte\nprofessionnel ?",
                      color: Colors.white,
                      size: 14,
                    ),
                    SizedBox(height: 30.h),
                    CustomMainButton(
                      onPressed: () {
                        // Navigator to ajouter compte pro
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const AjouteComptePro(),
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              var tween = Tween<Offset>(
                                      begin: const Offset(0.0, 1.0),
                                      end: Offset.zero)
                                  .chain(CurveTween(curve: Curves.easeInOut));

                              var offestAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offestAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                      text: 'Ajouter un compte PRO',
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomByIcosnetHint(),
              ),
            ],
          ),
        ));
  }
}
