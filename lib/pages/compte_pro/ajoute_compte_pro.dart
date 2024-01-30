import 'dart:convert';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whowiyati/pages/compte_pro/mes_comptes_pro.dart';
import 'package:whowiyati/widgets/compte_pro/ajoute_compte_pro/custom_bottom_background.dart';
import 'package:whowiyati/widgets/compte_pro/ajoute_compte_pro/custom_top_background.dart';
import 'package:whowiyati/widgets/compte_pro/custom_alert_dialog.dart';
import 'package:whowiyati/widgets/custom_text_form_field.dart';
import '../../const.dart';

import 'package:http/http.dart' as http;

import '../../main.dart';
import '../../widgets/custom_bottom_text_hint.dart';
import '../../widgets/custom_byicosnet_hint.dart';
import '../../widgets/welcome/custom_bonjour_welcome.dart';
import '../../widgets/welcome/custom_button_ajoute_compte_pro_welcome.dart';
import '../../widgets/welcome/custom_cancel_button.dart';
import '../../widgets/welcome/custom_identifient_welcome.dart';
import '../../widgets/welcome/custom_notif_welcome.dart';
import '../../widgets/welcome/custom_title_welcome.dart';
import '../../widgets/welcome/custom_welcome_item.dart';

class AjouteComptePro extends StatefulWidget {
  const AjouteComptePro({super.key});

  @override
  State<AjouteComptePro> createState() => _AjouteCompteProState();
}

class _AjouteCompteProState extends State<AjouteComptePro> {
  // ******************* Logic *******************
  TextEditingController _raisonContr = TextEditingController();
  String _formeJurd = "";
  TextEditingController _rcContr = TextEditingController();
  TextEditingController _nifContr = TextEditingController();
  TextEditingController _nisContr = TextEditingController();
  TextEditingController _adressContr = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void createComptePro() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      isLoading = true;
      setState(() {});

      var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
      var request = http.MultipartRequest('POST',
          Uri.parse('https://api.icosnet.com/sign/wh/create/company/pro/'));

      if (_nisContr.text.isNotEmpty) {
        request.fields.addAll({
          'raison_social': _raisonContr.text,
          'rc': _rcContr.text,
          'nif': _nifContr.text,
          'nis': _nisContr.text,
          'legal_status': _formeJurd,
          'address': _adressContr.text,
          'user_id': prefs.getString('user_id').toString()
        });
      } else {
        request.fields.addAll({
          'raison_social': _raisonContr.text,
          'rc': _rcContr.text,
          'nif': _nifContr.text,
          'legal_status': _formeJurd,
          'address': _adressContr.text,
          'user_id': prefs.getString('user_id').toString()
        });
      }

      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      // print(await response.stream.bytesToString());
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);
      print(answer);

      if (answerJson["Success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(answerJson["message"].toString()),
            duration: Duration(seconds: 3),
            backgroundColor: color3,
          ),
        );
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MesComptesPro(),
        ));
      } else {
        print(response.reasonPhrase);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(answerJson["message"].toString()),
            duration: Duration(seconds: 3),
            backgroundColor: colorRed,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veillez vérifier votre connection internet"),
          duration: Duration(seconds: 3),
          backgroundColor: colorRed,
        ),
      );
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _raisonContr.dispose();
    _rcContr.dispose();
    _nifContr.dispose();
    _nisContr.dispose();
    _adressContr.dispose();
    super.dispose();
  }

  // ******************* Interface *******************
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return CustomAlertDialog();
                });
            return false;
          },
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      CustomTopBackground(),
                      Positioned(
                        top: 260.h,
                        right: 0,
                        left: 0,
                        child: CustomBottomBackground(),
                      ),
                      ClipRect(
                        child: BackdropFilter(
                          filter:
                              new ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                          child: Container(
                            color: Colors.transparent,
                            height: MediaQuery.of(context).size.height,
                            padding: EdgeInsets.all(15.h),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: CustomCancelButton(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CustomAlertDialog();
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Positioned(
                                  top: 50.h,
                                  right: 0,
                                  left: 0,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Renseignez les informations mentionnées pour\ncréer votre compte pro",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.1.h,
                                          letterSpacing: 0.20.w,
                                        ),
                                      ),
                                      SizedBox(height: 20.h),
                                      Form(
                                        key: formKey,
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: CustomTextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: _raisonContr,
                                                keyboardType:
                                                    TextInputType.text,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Raison social non valide";
                                                  }
                                                  return null;
                                                },
                                                hintText: "Raison social",
                                                hintStyle: TextStyle(
                                                    color: Color(0xFF6D6D6D)),
                                                fillColor: Colors.white,
                                                prefixIcon: Icon(
                                                  Icons.description_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: DropdownButtonFormField(
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: Color(0xFF6D6D6D)),
                                                  hintText: "Forme juridique",
                                                  prefixIcon: Icon(
                                                    Icons.description_outlined,
                                                    color: Colors.black,
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.r),
                                                    borderSide: BorderSide(
                                                      color: color3,
                                                    ),
                                                  ),
                                                  filled: true,
                                                  fillColor: Colors.white,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(50
                                                            .r), // Set border radius
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Colors.red),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.r),
                                                  ),
                                                ),
                                                value: "EURL",
                                                items: [
                                                  DropdownMenuItem(
                                                      value: "EURL",
                                                      child: Text("EURL")),
                                                  DropdownMenuItem(
                                                      value: "SARL",
                                                      child: Text("SARL")),
                                                  DropdownMenuItem(
                                                      value: "SPA",
                                                      child: Text("SPA")),
                                                  DropdownMenuItem(
                                                      value: "SNC",
                                                      child: Text("SNC")),
                                                  DropdownMenuItem(
                                                      value: "SCS",
                                                      child: Text("SCS")),
                                                  DropdownMenuItem(
                                                      value: "SCA",
                                                      child: Text("SCA")),
                                                  DropdownMenuItem(
                                                      value: "GR",
                                                      child: Text("GR")),
                                                ],
                                                onChanged: (String? value) {
                                                  _formeJurd = value!;
                                                  print(_formeJurd);
                                                },
                                              ),
                                              // TextFormField(
                                              //   autofocus: false,
                                              //   textInputAction:
                                              //       TextInputAction.next,
                                              //   controller: _formeJurdContr,
                                              //   cursorColor: color3,
                                              //   style: TextStyle(
                                              //       color: Colors.black),
                                              //   decoration: InputDecoration(
                                              //     hintStyle: TextStyle(
                                              //         color: Color(0xFF6D6D6D)),
                                              //     hintText: "Forme juridique",
                                              //     prefixIcon: Icon(
                                              //       Icons.description_outlined,
                                              //       color: Colors.black,
                                              //     ),
                                              //     focusedBorder:
                                              //         OutlineInputBorder(
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               50.r),
                                              //       borderSide: BorderSide(
                                              //         color: color3,
                                              //       ),
                                              //     ),
                                              //     filled: true,
                                              //     fillColor: Colors.white,
                                              //     border: OutlineInputBorder(
                                              //       borderRadius:
                                              //           BorderRadius.circular(50
                                              //               .r), // Set border radius
                                              //     ),
                                              //     errorBorder:
                                              //         OutlineInputBorder(
                                              //       borderSide: BorderSide(
                                              //           color: Colors.red),
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               50.r),
                                              //     ),
                                              //   ),
                                              //   validator: (value) {
                                              //     if (value == null ||
                                              //         value.isEmpty) {
                                              //       return "Forme juridique non valide";
                                              //     }
                                              //     return null;
                                              //   },
                                              // ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: CustomTextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: _rcContr,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "N° Registre de commerce non valide";
                                                  }
                                                  return null;
                                                },
                                                hintText:
                                                    "N° Registre de commerce",
                                                hintStyle: TextStyle(
                                                    color: Color(0xFF6D6D6D)),
                                                fillColor: Colors.white,
                                                prefixIcon: Icon(
                                                  Icons.description_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: CustomTextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: _nifContr,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "N° d'identification fiscale non valide";
                                                  }
                                                  return null;
                                                },
                                                hintText:
                                                    "N° d'identification fiscale",
                                                hintStyle: TextStyle(
                                                    color: Color(0xFF6D6D6D)),
                                                fillColor: Colors.white,
                                                prefixIcon: Icon(
                                                  Icons.description_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: CustomTextFormField(
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: _nisContr,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "N° d'identification statistique non valide";
                                                  }
                                                  return null;
                                                },
                                                hintText:
                                                    "N° d'identification statistique",
                                                hintStyle: TextStyle(
                                                    color: Color(0xFF6D6D6D)),
                                                fillColor: Colors.white,
                                                prefixIcon: Icon(
                                                  Icons.description_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: CustomTextFormField(
                                                textInputAction:
                                                    TextInputAction.done,
                                                controller: _adressContr,
                                                keyboardType:
                                                    TextInputType.text,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Adresse du siège non valide";
                                                  }
                                                  return null;
                                                },
                                                hintText:
                                                    "Adresse du siège de la société",
                                                hintStyle: TextStyle(
                                                    color: Color(0xFF6D6D6D)),
                                                fillColor: Colors.white,
                                                prefixIcon: Icon(
                                                  Icons.description_outlined,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  bottom: 40.h,
                                  left: 0,
                                  right: 0,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate() &&
                                          _formeJurd.isNotEmpty) {
                                        createComptePro();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: color3,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 15.h),
                                      foregroundColor: Colors.white,
                                      minimumSize: Size.fromHeight(30.w),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50.r),
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
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: CustomByIcosnetHint(),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
