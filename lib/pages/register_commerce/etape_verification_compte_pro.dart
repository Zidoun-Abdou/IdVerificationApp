import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const.dart';

class EtapeVerificationComptePro extends StatelessWidget {
  const EtapeVerificationComptePro({
    super.key,
    required this.etape1,
    required this.etape2,
    required this.etape3,
    required this.etape4,
  });

  final bool etape1;
  final bool etape2;
  final bool etape3;
  final bool etape4;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Etapes vérifiées pour crée un compte Pro",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            letterSpacing: 0.20,
          ),
        ),
        SizedBox(height: 30.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                Icons.verified_outlined,
                color: etape1 ? color3 : Colors.grey,
                size: 50.sp,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              flex: 3,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Confirmation par téléphone\n',
                      style: TextStyle(
                        color: etape1 ? Colors.white : Colors.grey,
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20,
                      ),
                    ),
                    TextSpan(
                      text: etape1 ? 'Vérifié' : 'Non Vérifié',
                      style: TextStyle(
                        color: etape1 ? color3 : Colors.grey,
                        fontSize: 12.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                Icons.verified_outlined,
                color: etape2 ? color3 : Colors.grey,
                size: 50.sp,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              flex: 3,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Confirmation par e-mail\n',
                      style: TextStyle(
                        color: etape2 ? Colors.white : Colors.grey,
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20,
                      ),
                    ),
                    TextSpan(
                      text: etape2 ? 'Vérifié' : 'Non Vérifié',
                      style: TextStyle(
                        color: etape2 ? color3 : Colors.grey,
                        fontSize: 12.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                Icons.verified_outlined,
                color: etape3 ? color3 : Colors.grey,
                size: 50.sp,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              flex: 3,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Vérification du registre commerce\n',
                      style: TextStyle(
                        color: etape3 ? Colors.white : Colors.grey,
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20,
                      ),
                    ),
                    TextSpan(
                      text: etape3 ? 'Vérifié' : 'Non Vérifié',
                      style: TextStyle(
                        color: etape3 ? color3 : Colors.grey,
                        fontSize: 12.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                Icons.verified_outlined,
                color: etape4 ? color3 : Colors.grey,
                size: 50.sp,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              flex: 3,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Vérification de la carte fiscale\n',
                      style: TextStyle(
                        color: etape4 ? Colors.white : Colors.grey,
                        fontSize: 14.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20,
                      ),
                    ),
                    TextSpan(
                      text: etape4 ? 'Vérifié' : 'Non Vérifié',
                      style: TextStyle(
                        color: etape4 ? color3 : Colors.grey,
                        fontSize: 12.sp,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.20,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
