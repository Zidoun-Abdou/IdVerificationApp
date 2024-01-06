import 'dart:convert';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/pages/compte_pro/mes_comptes_pro.dart';
import '../../const.dart';

import 'package:http/http.dart' as http;

import '../../main.dart';

class AjouteComptePro extends StatefulWidget {
  const AjouteComptePro({super.key});

  @override
  State<AjouteComptePro> createState() => _AjouteCompteProState();
}

class _AjouteCompteProState extends State<AjouteComptePro> {
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
            duration: Duration(seconds: 5),
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
            duration: Duration(seconds: 5),
            backgroundColor: colorRed,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Veillez vérifier votre connection internet"),
          duration: Duration(seconds: 5),
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
                  return AlertDialog(
                    backgroundColor: color4.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.r))),
                    content: Text(
                      'Si vous quittez maintenant, les modifications\neffectuées ne seront pas enregistrées',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 12.sp),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
                    actionsAlignment: MainAxisAlignment.center,
                    actionsPadding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          fixedSize: Size(100.w, 40.h),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                        child: Text(
                          'Annuler',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD32424),
                          foregroundColor: Colors.white,
                          fixedSize: Size(100.w, 40.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          elevation: 20,
                          shadowColor: Color(0xFFD32424),
                        ),
                        child: Text(
                          'Quitter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  );
                });
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
                                Text(
                                  "Mon compte",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFA2A2B5),
                                    fontSize: 16.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.20,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.logout,
                                      color: Colors.grey,
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            'Bonjour\n${prefs.getString('name_latin').toString()[0].toUpperCase()}${prefs.getString('name_latin').toString().substring(1).toLowerCase()}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '.',
                                        style: TextStyle(
                                          color: Color(0xFF1FD15C),
                                          fontSize: 40,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 10.h,
                                      left: 15.w,
                                      bottom: 10.h,
                                      right: 10.w),
                                  alignment: Alignment.center,
                                  decoration: ShapeDecoration(
                                    color: Colors.white
                                        .withOpacity(0.10000000149011612),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.notifications_none_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        height: 20.h,
                                        child: CircleAvatar(
                                          backgroundColor: color5,
                                          child: Text("0"),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25.w, vertical: 10.h),
                                  decoration: ShapeDecoration(
                                    color: Colors.white
                                        .withOpacity(0.10000000149011612),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 0.50),
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                  ),
                                  child: Text(
                                    'Ajoutez Compte PRO',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
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
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              10.h -
                                              10.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 10.h),
                                          decoration: BoxDecoration(
                                              color: color4.withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(15.r)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(8.sp),
                                                  decoration: BoxDecoration(
                                                      color: color5,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r)),
                                                  child: Icon(
                                                    Icons
                                                        .person_outline_outlined,
                                                    color: Colors.white,
                                                  )),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Text(
                                                "Mon\nprofile",
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              10.h -
                                              10.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 10.h),
                                          decoration: BoxDecoration(
                                              color: color4.withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(15.r)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(8.sp),
                                                  decoration: BoxDecoration(
                                                      color: color5,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r)),
                                                  child: Icon(
                                                    Icons.folder_open,
                                                    color: Colors.white,
                                                  )),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Text(
                                                "Mes\ndocuments",
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              10.h -
                                              10.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 10.h),
                                          decoration: BoxDecoration(
                                              color: color4.withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(15.r)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(8.sp),
                                                  decoration: BoxDecoration(
                                                      color: color5,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r)),
                                                  child: Icon(
                                                    Icons.phone,
                                                    color: Colors.white,
                                                  )),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Text(
                                                "Mes\ncomptes Pro",
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              10.h -
                                              10.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.w, vertical: 10.h),
                                          decoration: BoxDecoration(
                                              color: color4.withOpacity(0.8),
                                              borderRadius:
                                                  BorderRadius.circular(15.r)),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(8.sp),
                                                  decoration: BoxDecoration(
                                                      color: color5,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.r)),
                                                  child: Icon(
                                                    Icons.edit_outlined,
                                                    color: Colors.white,
                                                  )),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Text(
                                                "Signature\nélectronique",
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20.h),
                                child: Text(
                                  'Votre application d’indentification',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF666680),
                                    fontSize: 12.h,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            backgroundColor:
                                                color4.withOpacity(0.8),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.r))),
                                            content: Text(
                                              'Si vous quittez maintenant, les modifications\neffectuées ne seront pas enregistrées',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 30.h,
                                                    horizontal: 20.w),
                                            actionsAlignment:
                                                MainAxisAlignment.center,
                                            actionsPadding: EdgeInsets.only(
                                                top: 10.h, bottom: 20.h),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  foregroundColor: Colors.white,
                                                  fixedSize: Size(100.w, 40.h),
                                                  shape: RoundedRectangleBorder(
                                                    side: BorderSide(
                                                        color: Colors.white),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.r),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Annuler',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.sp,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color(0xFFD32424),
                                                  foregroundColor: Colors.white,
                                                  fixedSize: Size(100.w, 40.h),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50.r),
                                                  ),
                                                  elevation: 20,
                                                  shadowColor:
                                                      Color(0xFFD32424),
                                                ),
                                                child: Text(
                                                  'Quitter',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.sp,
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white
                                          .withOpacity(0.10000000149011612),
                                      child: Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 17.sp,
                                      ),
                                    ),
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
                                              child: TextFormField(
                                                autofocus: false,
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: _raisonContr,
                                                cursorColor: color3,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: Color(0xFF6D6D6D)),
                                                  hintText: "Raison social",
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
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Raison social non valide";
                                                  }
                                                  return null;
                                                },
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
                                              child: TextFormField(
                                                autofocus: false,
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: _rcContr,
                                                cursorColor: color3,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: Color(0xFF6D6D6D)),
                                                  hintText:
                                                      "N° Registre de commerce",
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
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "N° Registre de commerce non valide";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: TextFormField(
                                                autofocus: false,
                                                textInputAction:
                                                    TextInputAction.next,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                controller: _nifContr,
                                                cursorColor: color3,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: Color(0xFF6D6D6D)),
                                                  hintText:
                                                      "N° d'identification fiscale",
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
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "N° d'identification fiscale non valide";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: TextFormField(
                                                autofocus: false,
                                                keyboardType: TextInputType
                                                    .visiblePassword,
                                                textInputAction:
                                                    TextInputAction.next,
                                                controller: _nisContr,
                                                cursorColor: color3,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: Color(0xFF6D6D6D)),
                                                  hintText:
                                                      "N° d'identification statistique",
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
                                              ),
                                            ),
                                            SizedBox(height: 10.h),
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.w),
                                              child: TextFormField(
                                                autofocus: false,
                                                textInputAction:
                                                    TextInputAction.done,
                                                controller: _adressContr,
                                                cursorColor: color3,
                                                style: TextStyle(
                                                    color: Colors.black),
                                                decoration: InputDecoration(
                                                  hintStyle: TextStyle(
                                                      color: Color(0xFF6D6D6D)),
                                                  hintText:
                                                      "Adresse du siège de la société",
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
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Adresse du siège non valide";
                                                  }
                                                  return null;
                                                },
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
                                  child: Text.rich(
                                    TextSpan(children: [
                                      TextSpan(
                                          text: 'WHOWIATY',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600)),
                                      TextSpan(
                                        text: ' by icosnet',
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Colors.white),
                                      ),
                                    ]),
                                  ),
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
