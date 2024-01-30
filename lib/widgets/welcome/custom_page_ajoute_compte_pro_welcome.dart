import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                    Text(
                      "Souhaitez-vous ajouter un  compte\nprofessionnel ?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.20,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    ElevatedButton(
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color3,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        foregroundColor: Colors.white,
                        minimumSize: Size.fromHeight(30.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        elevation: 20,
                        shadowColor: color3,
                      ),
                      child: Text(
                        'Ajouter un compte PRO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
