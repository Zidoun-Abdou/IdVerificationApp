import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const.dart';

class EtapeVerificationComptePro extends StatefulWidget {
  final ValueNotifier<int> currentEtapeValueNotifier;
  final ValueNotifier<bool> etape1ValueNotifier;
  final ValueNotifier<bool> etape2ValueNotifier;
  final ValueNotifier<bool> etape3ValueNotifier;
  final ValueNotifier<bool> etape4ValueNotifier;

  const EtapeVerificationComptePro({
    super.key,
    required this.etape1ValueNotifier,
    required this.etape2ValueNotifier,
    required this.etape3ValueNotifier,
    required this.etape4ValueNotifier,
    required this.currentEtapeValueNotifier,
  });

  @override
  State<EtapeVerificationComptePro> createState() =>
      _EtapeVerificationCompteProState();
}

class _EtapeVerificationCompteProState
    extends State<EtapeVerificationComptePro> {
  @override
  void initState() {
    widget.currentEtapeValueNotifier.addListener(() {
      setState(() {});
    });
    widget.etape1ValueNotifier.addListener(() {
      setState(() {});
    });
    widget.etape2ValueNotifier.addListener(() {
      setState(() {});
    });
    widget.etape3ValueNotifier.addListener(() {
      setState(() {});
    });
    widget.etape4ValueNotifier.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Column(
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
                      child: CircleAvatar(
                        backgroundColor: widget.etape1ValueNotifier.value
                            ? color3
                            : Colors.grey,
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 30.sp,
                        ),
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
                                color: widget.etape1ValueNotifier.value
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.20,
                              ),
                            ),
                            TextSpan(
                              text: widget.etape1ValueNotifier.value
                                  ? 'Vérifié'
                                  : 'Non Vérifié',
                              style: TextStyle(
                                color: widget.etape1ValueNotifier.value
                                    ? color3
                                    : Colors.grey,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30.h,
                    padding: EdgeInsets.only(left: 31.w),
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        backgroundColor: widget.etape2ValueNotifier.value
                            ? color3
                            : Colors.grey,
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 30.sp,
                        ),
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
                                color: widget.etape2ValueNotifier.value
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.20,
                              ),
                            ),
                            TextSpan(
                              text: widget.etape2ValueNotifier.value
                                  ? 'Vérifié'
                                  : 'Non Vérifié',
                              style: TextStyle(
                                color: widget.etape2ValueNotifier.value
                                    ? color3
                                    : Colors.grey,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30.h,
                    padding: EdgeInsets.only(left: 31.w),
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        backgroundColor: widget.etape3ValueNotifier.value
                            ? color3
                            : Colors.grey,
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 30.sp,
                        ),
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
                                color: widget.etape3ValueNotifier.value
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.20,
                              ),
                            ),
                            TextSpan(
                              text: widget.etape3ValueNotifier.value
                                  ? 'Vérifié'
                                  : 'Non Vérifié',
                              style: TextStyle(
                                color: widget.etape3ValueNotifier.value
                                    ? color3
                                    : Colors.grey,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 30.h,
                    padding: EdgeInsets.only(left: 31.w),
                    child: VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CircleAvatar(
                        backgroundColor: widget.etape4ValueNotifier.value
                            ? color3
                            : Colors.grey,
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 30.sp,
                        ),
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
                                color: widget.etape4ValueNotifier.value
                                    ? Colors.white
                                    : Colors.grey,
                                fontSize: 14.sp,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.20,
                              ),
                            ),
                            TextSpan(
                              text: widget.etape4ValueNotifier.value
                                  ? 'Vérifié'
                                  : 'Non Vérifié',
                              style: TextStyle(
                                color: widget.etape4ValueNotifier.value
                                    ? color3
                                    : Colors.grey,
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
            ),
          ),
          Positioned(
            bottom: 20.h,
            right: 0,
            left: 0,
            child: ElevatedButton(
              onPressed: () {
                if (widget.etape1ValueNotifier.value == false) {
                  widget.currentEtapeValueNotifier.value = 1;
                } else if (widget.etape2ValueNotifier.value == false) {
                  widget.currentEtapeValueNotifier.value = 2;
                } else if (widget.etape3ValueNotifier.value == false ||
                    widget.etape4ValueNotifier.value == false) {
                  widget.currentEtapeValueNotifier.value = 3;
                }
                // else if (widget.etape4ValueNotifier.value == false) {
                //   widget.currentEtapeValueNotifier.value = 3;
                // }
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
                'Continuer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
