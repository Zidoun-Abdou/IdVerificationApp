import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/compte_pro/mes_comptes_pro.dart';
import 'package:whowiyati/pages/compte_pro/verifer_mail.dart';
import 'package:whowiyati/pages/compte_pro/verifer_nif.dart';
import 'package:whowiyati/pages/compte_pro/verifer_phone.dart';
import 'package:whowiyati/pages/compte_pro/verifer_registre.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/widgets/compte_pro/custom_text_pro.dart';
import 'package:whowiyati/widgets/compte_pro/steps_verify_compte_pro/custom_align.dart';
import 'package:whowiyati/widgets/compte_pro/steps_verify_compte_pro/custom_etape.dart';
import 'package:whowiyati/widgets/custom_main_button.dart';

import '../../widgets/adaptive_circular_progress_indicator.dart';
import '../../widgets/custom_byicosnet_hint.dart';
import '../../widgets/custom_image_logo.dart';

class StepsVerifyComptePro extends StatefulWidget {
  final String companyId;
  final String companyUserId;
  const StepsVerifyComptePro(
      {super.key, required this.companyUserId, required this.companyId});

  @override
  State<StepsVerifyComptePro> createState() => _StepsVerifyCompteProState();
}

class _StepsVerifyCompteProState extends State<StepsVerifyComptePro> {
  // ******************* Logic *******************

  getCompteDocs() async {
    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api.icosnet.com/sign/wh/get/company/doc/${widget.companyId}'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    print(answer);

    return answerJson;
  }

  // ******************* Interface *******************
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MesComptesPro(),
        ));
        return false;
      },
      child: Scaffold(
        backgroundColor: color1,
        appBar: AppBar(
          backgroundColor: color1,
          elevation: 0.0,
        ),
        body: SafeArea(
          child: FutureBuilder(
              future: getCompteDocs(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data["success"] == true) {
                    if (!listEquals(snapshot.data["data"], [])) {
                      List docs = snapshot.data["data"];
                      docs.forEach((element) async {
                        if (element["type_document"] == "RC") {
                          await prefs.setString("step", "3");
                        } else if (element["type_document"] == "NIF") {
                          await prefs.setString("step", "4");
                        }
                      });
                    }
                    return Column(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomTextPro(
                                    data: 'Etapes vérifiées',
                                    color: Color(0xFF00FF84),
                                    size: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Column(
                                    children: [
                                      CustomEtape(
                                        condition: int.parse(prefs
                                                .getString("step")
                                                .toString()) >=
                                            1,
                                        title: 'Confirmation par téléphone\n',
                                      ),
                                      CustomAlign(),
                                      CustomEtape(
                                        condition: int.parse(prefs
                                                .getString("step")
                                                .toString()) >=
                                            2,
                                        title: 'Confirmation par mail\n',
                                      ),
                                      CustomAlign(),
                                      CustomEtape(
                                        condition: int.parse(prefs
                                                .getString("step")
                                                .toString()) >=
                                            3,
                                        title:
                                            'Vérification du registre commerce\n',
                                      ),
                                      CustomAlign(),
                                      CustomEtape(
                                        condition: int.parse(prefs
                                                .getString("step")
                                                .toString()) >=
                                            4,
                                        title:
                                            'Vérification de la carte fiscale\n',
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
                                CustomTextPro(
                                  data: prefs.getString("step") == "4"
                                      ? 'Félicitations, vous avez terminé toutes les\nétapes. Vos documents sont maintenant\nen cours de vérification'
                                      : "Suivez ces étapes pour compléter la validation\n de votre compte pro",
                                  color: Colors.white,
                                  size: 14,
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 8.h),
                                  child: CustomMainButton(
                                    onPressed: () {
                                      if (prefs.getString("step") == "0") {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => VeriferPhone(
                                            companyId: widget.companyId,
                                            companyUserId: widget.companyUserId,
                                          ),
                                        ));
                                      } else if (prefs.getString("step") ==
                                          "1") {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => VeriferMail(
                                            companyId: widget.companyId,
                                            companyUserId: widget.companyUserId,
                                          ),
                                        ));
                                      } else if (prefs.getString("step") ==
                                          "2") {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => VeriferRegitre(
                                            companyUserId: widget.companyUserId,
                                            companyId: widget.companyId,
                                          ),
                                        ));
                                      } else if (prefs.getString("step") ==
                                          "3") {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => VeriferNif(
                                            companyUserId: widget.companyUserId,
                                            companyId: widget.companyId,
                                          ),
                                        ));
                                      } else if (prefs.getString("step") ==
                                          "4") {
                                        Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) => MesComptesPro(),
                                        ));
                                      }
                                    },
                                    text: prefs.getString("step") == "4"
                                        ? 'Retourner'
                                        : 'Continuer',
                                  ),
                                ),
                                CustomByIcosnetHint(),
                              ],
                            )),
                      ],
                    );
                  }
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: AdaptiveCircularProgressIndicator(color: color3),
                  );
                }

                return Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: CustomImageLogo(width: 200),
                    ),
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CustomTextPro(
                                data: 'Etapes vérifiées',
                                color: Color(0xFF00FF84),
                                size: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              Column(
                                children: [
                                  CustomEtape(
                                    condition: int.parse(prefs
                                            .getString("step")
                                            .toString()) >=
                                        1,
                                    title: 'Confirmation par téléphone\n',
                                  ),
                                  CustomAlign(),
                                  CustomEtape(
                                    condition: int.parse(prefs
                                            .getString("step")
                                            .toString()) >=
                                        2,
                                    title: 'Confirmation par mail\n',
                                  ),
                                  CustomAlign(),
                                  CustomEtape(
                                    condition: int.parse(prefs
                                            .getString("step")
                                            .toString()) >=
                                        3,
                                    title:
                                        'Vérification du registre commerce\n',
                                  ),
                                  CustomAlign(),
                                  CustomEtape(
                                    condition: int.parse(prefs
                                            .getString("step")
                                            .toString()) >=
                                        4,
                                    title: 'Vérification de la carte fiscale\n',
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
                            CustomTextPro(
                              data: prefs.getString("step") == "4"
                                  ? 'Félicitations, vous avez terminé toutes les\nétapes. Vos documents sont maintenant\nen cours de vérification'
                                  : "Suivez ces étapes pour compléter la validation\n de votre compte pro",
                              color: Colors.white,
                              size: 14,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 8.h),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (prefs.getString("step") == "0") {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => VeriferPhone(
                                        companyId: widget.companyId,
                                        companyUserId: widget.companyUserId,
                                      ),
                                    ));
                                  } else if (prefs.getString("step") == "1") {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => VeriferMail(
                                        companyId: widget.companyId,
                                        companyUserId: widget.companyUserId,
                                      ),
                                    ));
                                  } else if (prefs.getString("step") == "2") {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => VeriferRegitre(
                                        companyUserId: widget.companyUserId,
                                        companyId: widget.companyId,
                                      ),
                                    ));
                                  } else if (prefs.getString("step") == "3") {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => VeriferNif(
                                        companyUserId: widget.companyUserId,
                                        companyId: widget.companyId,
                                      ),
                                    ));
                                  } else if (prefs.getString("step") == "4") {
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) => MesComptesPro(),
                                    ));
                                  }
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
                                    shadowColor: color3),
                                child: Text(
                                  prefs.getString("step") == "4"
                                      ? 'Retourner'
                                      : 'Continuer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            CustomByIcosnetHint(),
                          ],
                        )),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
