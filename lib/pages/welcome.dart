import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/widgets/custom_question_show_bottom_sheet.dart';
import 'package:whowiyati/widgets/welcome/custom_bonjour_welcome.dart';
import 'package:whowiyati/widgets/welcome/custom_button_ajoute_compte_pro_welcome.dart';
import 'package:whowiyati/widgets/welcome/custom_identifient_welcome.dart';
import 'package:whowiyati/widgets/welcome/custom_menu_welcome.dart';
import 'package:whowiyati/widgets/welcome/custom_notif_welcome.dart';
import 'package:whowiyati/widgets/welcome/custom_title_welcome.dart';
import 'package:whowiyati/widgets/welcome/custom_welcome_item.dart';
import '../const.dart';
import '../main.dart';
import '../widgets/custom_bottom_text_hint.dart';
import '../widgets/welcome/custom_non_identifie.dart';
import '../widgets/welcome/custom_page_ajoute_compte_pro_welcome.dart';
import '../widgets/welcome/custom_profil_welcome.dart';
import 'compte_pro/mes_comptes_pro.dart';
import 'demande_validation.dart';
import 'homepage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'steps.dart';

import 'idinfos.dart';
import 'listofdocuments.dart';

class Welcome extends StatefulWidget {
  final String token;
  const Welcome({Key? key, required this.token}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  // ******************* Logic *******************
  bool isProfile = false;
  final GlobalKey<State<BottomSheet>> _bottomSheetKey = GlobalKey();
  double initialSize = 0.7;
  ValueNotifier<bool> isDemandeValidationOpen = ValueNotifier(false);

  // Handling Interaction with Notification when application is opened from a terminated state
  getInit() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      if (isDemandeValidationOpen.value == true) {
        setState(() {});
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DemandeValidation(
              isDemandeValidationOpen: isDemandeValidationOpen,
            ),
          ),
        );
        isDemandeValidationOpen.value = true;
      }
    }
  }

  // Handling Foreground messages
  firebaseMessagingConfig() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (isDemandeValidationOpen.value == true) {
          setState(() {});
        }
        Flushbar(
          onTap: (flushbar) {
            // ******* Check If is Not Current Route setState Else Push to DemandeValidation *******
            if (isDemandeValidationOpen.value == true) {
              setState(() {});
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DemandeValidation(
                    isDemandeValidationOpen: isDemandeValidationOpen,
                  ),
                ),
              );
              isDemandeValidationOpen.value = true;
            }
          },
          flushbarPosition: FlushbarPosition.TOP,
          duration: Duration(seconds: 2),
          title: message.notification!.title,
          message: message.notification!.body,
          backgroundColor: color1,
          flushbarStyle: FlushbarStyle.FLOATING,
          icon: Image.asset("assets/images/logo1.png"),
        )..show(context);
      }
    });
  }

  @override
  void initState() {
    isDemandeValidationOpen.addListener(() {
      setState(() {});
    });
    getInit();
    // Handling Interaction with Notification when application is opened from a background state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (isDemandeValidationOpen.value == true) {
        setState(() {});
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DemandeValidation(
              isDemandeValidationOpen: isDemandeValidationOpen,
            ),
          ),
        );
        isDemandeValidationOpen.value = true;
      }
    });
    firebaseMessagingConfig();
    super.initState();
  }

  // ******************* Interface *******************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: WillPopScope(
        onWillPop: () async {
          if (isProfile) {
            isProfile = false;
            setState(() {});
          }
          return false;
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 20.h),
                      height: MediaQuery.of(context).size.height / 2.3,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          // color: color1,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.r),
                              bottomRight: Radius.circular(20.r))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 1,
                              ),
                              CustomIdentifientWelcome(),
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: color7,
                                      isDismissible: true,
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                      builder: (context) {
                                        return CustomMenuWelcome(
                                          onDemandeValid: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DemandeValidation(
                                                  isDemandeValidationOpen:
                                                      isDemandeValidationOpen,
                                                ),
                                              ),
                                            );
                                            isDemandeValidationOpen.value =
                                                true;
                                          },
                                          onLogout: () {
                                            showModalBottomSheet(
                                                backgroundColor: color2,
                                                context: context,
                                                builder: (context) {
                                                  return CustomQuestionShowBottomSheet(
                                                      questionText:
                                                          "Êtes-vous sûr de vouloir quitter Whowiyaty?",
                                                      onAccepte: () async {
                                                        // await prefs.clear();
                                                        await prefs
                                                            .remove("status");
                                                        await prefs.remove(
                                                            "name_latin");
                                                        await prefs.remove(
                                                            "surname_latin");
                                                        await prefs.remove(
                                                            "birth_date");
                                                        await prefs.remove(
                                                            "deliv_date");
                                                        await prefs
                                                            .remove("exp_date");
                                                        await prefs.remove(
                                                            "document_number");
                                                        await prefs
                                                            .remove("user_id");
                                                        await prefs
                                                            .remove("phone");
                                                        await prefs
                                                            .remove("mail");
                                                        await prefs
                                                            .remove("nin");
                                                        await prefs
                                                            .remove("pasword");
                                                        await prefs.setString(
                                                            'login', 'false');
                                                        Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    HomePage()),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                      },
                                                      onRefus: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                });
                                          },
                                        );
                                      });
                                },
                                child: SvgPicture.asset(
                                  "assets/images/menu.svg",
                                  height: 22.h,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomBonjourWelcome(),
                              CustomNotifWelcome(),
                            ],
                          ),
                          Visibility(
                            visible: prefs.getString('status') == "5",
                            child: CustomTitleWelcome(),
                          ),
                          Visibility(
                            visible: prefs.getString('status') != "5",
                            child: CustomNonIdentifie(),
                          ),
                          SizedBox(height: 40.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomButtonAjouteCompteProWelcome(onTap: () {
                                if (prefs.getString('status') == "5") {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      barrierColor: Colors.transparent,
                                      isDismissible: true,
                                      isScrollControlled: true,
                                      useSafeArea: true,
                                      builder: (context) {
                                        return ClipRect(
                                          child: BackdropFilter(
                                            filter: new ImageFilter.blur(
                                                sigmaX: 20.0, sigmaY: 20.0),
                                            child:
                                                CustomPageAjouteCompteProWelcome(),
                                          ),
                                        );
                                      });
                                }
                              }),
                            ],
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      top: 260.h,
                      right: 0,
                      left: 0,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            AnimatedSwitcher(
                              duration: Duration(milliseconds: 300),
                              child: isProfile
                                  ?
                                  // Profile-details
                                  CustomProfilWelcome(
                                      onTap: () {
                                        isProfile = !isProfile;
                                        setState(() {});
                                      },
                                    )
                                  : Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomWelcomeItem(
                                                onTap: () {
                                                  if (prefs.getString(
                                                          'status') ==
                                                      "5") {
                                                    setState(() {
                                                      isProfile = !isProfile;
                                                    });
                                                  }
                                                },
                                                icon: "profil",
                                                title: "Mon\nprofile",
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: CustomWelcomeItem(
                                                onTap: () {
                                                  if (prefs.getString(
                                                          'status') ==
                                                      "5") {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ListOfDocuments(),
                                                      ),
                                                    );
                                                  }
                                                },
                                                icon: "document",
                                                title: "Mes\ndocuments",
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15.h),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomWelcomeItem(
                                                onTap: () {
                                                  if (prefs.getString(
                                                          'status') ==
                                                      "5") {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          MesComptesPro(),
                                                    ));
                                                  }
                                                },
                                                icon: "star",
                                                title: "Mes\ncomptes Pro",
                                              ),
                                            ),
                                            SizedBox(width: 10.w),
                                            Expanded(
                                              child: CustomWelcomeItem(
                                                onTap: () {
                                                  if (prefs.getString(
                                                          'status') ==
                                                      "5") {
                                                    // prefs.getString("name_arabic") ==
                                                    //         null
                                                    //     ? Navigator.of(context)
                                                    //         .push(
                                                    //         MaterialPageRoute(
                                                    //           builder:
                                                    //               (context) =>
                                                    //                   IdInfos(),
                                                    //         ),
                                                    //       )
                                                    //     : Navigator.of(context)
                                                    //         .push(MaterialPageRoute(
                                                    //             builder: (context) =>
                                                    //                 CardNfcInfo()));
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            IdInfos(),
                                                      ),
                                                    );
                                                  }
                                                },
                                                icon: "edit",
                                                title:
                                                    "Signature\nélectronique",
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                            Visibility(
                              visible: prefs.getString('status') != "5",
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 15.h),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Steps(
                                                  token: widget.token,
                                                )));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color3,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 15.h),
                                    foregroundColor: Colors.white,
                                    minimumSize: Size.fromHeight(30.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    elevation: 20,
                                    shadowColor: color3, // Set the shadow color
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Poursuivre mon identification   ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Icon(
                                        Icons.warning_rounded,
                                        size: 25.sp,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                                visible: isProfile,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                )),
                            Container(
                              margin: EdgeInsets.only(top: 20.h),
                              child: CustomBottomTextHint(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
