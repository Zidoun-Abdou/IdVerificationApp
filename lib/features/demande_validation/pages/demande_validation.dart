import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/core/utils/snackbar_message.dart';
import '../../../main.dart';
import '../../home/pages/dealpad.dart';
import '../models/demande_validation_model.dart';
import '../../../core/widgets/adaptive_circular_progress_indicator.dart';

import '../../../const.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_subtitle.dart';
import '../widgets/custom_title.dart';

class DemandeValidation extends StatefulWidget {
  final ValueNotifier<bool> isDemandeValidationOpen;
  const DemandeValidation({super.key, required this.isDemandeValidationOpen});

  @override
  State<DemandeValidation> createState() => _DemandeValidationState();
}

class _DemandeValidationState extends State<DemandeValidation> {
  // ************** Logic **************
  getDemandeValidation() async {
    String? userId = prefs.getString('user_id');

    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

    var request = http.Request(
        'GET', Uri.parse('https://api.icosnet.com/sign/wh/requests/$userId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);

    return answerJson;
  }

  updateDemandeStatus(String requestId, String statusCode) async {
    try {
      var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};

      var request = http.MultipartRequest('PUT',
          Uri.parse('https://api.icosnet.com/sign/wh/validate/request/'));

      request.fields.addAll({'id': requestId, 'code': statusCode});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);

      if (answerJson["status"] == true) {
        statusCode == "1"
            ? SnackBarMessage().showSuccessSnackBar(
                message: "Votre demande accepter", context: context)
            : SnackBarMessage().showErrorSnackBar(
                message: "Votre demande refuser", context: context);
      } else {
        SnackBarMessage().showErrorSnackBar(
            message: answerJson["message"].toString(), context: context);
      }
    } on Exception {
      SnackBarMessage().showErrorSnackBar(
          message: "Quelque chose s'est mal passé, réessayez plus tard",
          context: context);
    }
  }

  @override
  void initState() {
    getDemandeValidation();
    super.initState();
  }

  // ************** Interface **************
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.isDemandeValidationOpen.value = false;
        Navigator.of(context).pop();
        return false;
      },
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Mes Demandes de Validation"),
            centerTitle: true,
            backgroundColor: color1,
            bottom: TabBar(
              indicatorColor: color3,
              tabs: [
                Tab(
                  text: "En attente",
                ),
                Tab(
                  text: "Accepté",
                ),
                Tab(
                  text: "Refusé",
                ),
              ],
            ),
          ),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(15.w),
              color: color1,
              child: TabBarView(
                children: [
                  FutureBuilder(
                      future: getDemandeValidation(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data["status"] == true) {
                            List<DemandeValidationModel> enAttenteList = [];
                            for (var element in snapshot.data["data"]) {
                              if (element["Status"] == "0") {
                                enAttenteList.add(
                                    DemandeValidationModel.fromJson(element));
                              }
                            }
                            if (enAttenteList.isNotEmpty) {
                              return ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 20.h,
                                ),
                                itemCount: enAttenteList.length,
                                itemBuilder: (context, index) => CustomCard(
                                  height:
                                      MediaQuery.of(context).size.height * 0.26,
                                  children: [
                                    CustomTitle(
                                        color: color2,
                                        data: enAttenteList[index]
                                            .requestIdentify!),
                                    Divider(color: color6),
                                    CustomSubtitle(
                                        text: 'Source demande : ',
                                        data: enAttenteList[index]
                                            .sourceDemande!),
                                    CustomSubtitle(
                                        text: 'Créer à : ',
                                        data: enAttenteList[index].createdAt!),
                                    CustomSubtitle(
                                        text: 'Type demande : ',
                                        data:
                                            enAttenteList[index].typeDemande!),
                                    SizedBox(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            // await updateDemandeStatus(
                                            //     enAttenteList[index]
                                            //         .requestIdentify!,
                                            //     "-1");
                                            // setState(() {});
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DialpadScreen(
                                                  status: 4,
                                                  onPressedAction: () async {
                                                    await updateDemandeStatus(
                                                        enAttenteList[index]
                                                            .requestIdentify!,
                                                        "-1");
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFFD32424),
                                            foregroundColor: Colors.white,
                                            fixedSize: Size(100.w, 30.h),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60.r),
                                            ),
                                            elevation: 10,
                                            shadowColor: Color(0xFFD32424),
                                          ),
                                          child: Text(
                                            'Refuser',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            // await updateDemandeStatus(
                                            //     enAttenteList[index]
                                            //         .requestIdentify!,
                                            //     "1");
                                            // setState(() {});
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DialpadScreen(
                                                  status: 4,
                                                  onPressedAction: () async {
                                                    await updateDemandeStatus(
                                                        enAttenteList[index]
                                                            .requestIdentify!,
                                                        "1");
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: color3,
                                            foregroundColor: Colors.white,
                                            fixedSize: Size(100.w, 30.h),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                            ),
                                            elevation: 10,
                                            shadowColor: color3,
                                          ),
                                          child: Text(
                                            'Accepter',
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
                                  ],
                                ),
                              );
                            }
                          }
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: AdaptiveCircularProgressIndicator(
                                color: color3),
                          );
                        }

                        if (snapshot.hasError) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image.asset(
                              //   'assets/images/documentpending.png',
                              // ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                "Vous n'avez pas encore de demandes en attentes",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                    height: 1.h),
                                textAlign: TextAlign.center,
                              )
                            ],
                          );
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   'assets/images/documentpending.png',
                            // ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "Vous n'avez pas encore de demandes en attentes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  height: 1.h),
                            )
                          ],
                        );
                      }),
                  FutureBuilder(
                      future: getDemandeValidation(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data["status"] == true) {
                            List<DemandeValidationModel> accepteList = [];
                            for (var element in snapshot.data["data"]) {
                              if (element["Status"] == "1" ||
                                  element["Status"] == "-2") {
                                accepteList.add(
                                    DemandeValidationModel.fromJson(element));
                              }
                            }

                            if (accepteList.isNotEmpty) {
                              return ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 20.h,
                                ),
                                itemCount: accepteList.length,
                                itemBuilder: (context, index) => CustomCard(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  children: [
                                    CustomTitle(
                                        color: accepteList[index].status == "1"
                                            ? color3
                                            : Colors.grey,
                                        data: accepteList[index]
                                            .requestIdentify!),
                                    Divider(color: color6),
                                    CustomSubtitle(
                                        text: 'Source demande : ',
                                        data:
                                            accepteList[index].sourceDemande!),
                                    CustomSubtitle(
                                        text: 'Créer à : ',
                                        data: accepteList[index].createdAt!),
                                    CustomSubtitle(
                                        text: 'Type demande : ',
                                        data: accepteList[index].typeDemande!),
                                  ],
                                ),
                              );
                            }
                          }
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: AdaptiveCircularProgressIndicator(
                                color: color3),
                          );
                        }

                        if (snapshot.hasError) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image.asset(
                              //   'assets/images/documentpending.png',
                              // ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                "Vous n'avez pas encore des demandes acceptés",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                    height: 1.h),
                              )
                            ],
                          );
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   'assets/images/documentpending.png',
                            // ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "Vous n'avez pas encore des demandes acceptés",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  height: 1.h),
                            )
                          ],
                        );
                      }),
                  FutureBuilder(
                      future: getDemandeValidation(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data["status"] == true) {
                            List<DemandeValidationModel> refuseList = [];
                            for (var element in snapshot.data["data"]) {
                              if (element["Status"] == "-1") {
                                refuseList.add(
                                    DemandeValidationModel.fromJson(element));
                              }
                            }

                            if (refuseList.isNotEmpty) {
                              return ListView.separated(
                                separatorBuilder: (context, index) => SizedBox(
                                  height: 20.h,
                                ),
                                itemCount: refuseList.length,
                                itemBuilder: (context, index) => CustomCard(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  children: [
                                    CustomTitle(
                                        color: Color(0xFFD32424),
                                        data:
                                            refuseList[index].requestIdentify!),
                                    Divider(color: color6),
                                    CustomSubtitle(
                                        text: 'Source demande : ',
                                        data: refuseList[index].sourceDemande!),
                                    CustomSubtitle(
                                        text: 'Créer à : ',
                                        data: refuseList[index].createdAt!),
                                    CustomSubtitle(
                                        text: 'Type demande : ',
                                        data: refuseList[index].typeDemande!),
                                  ],
                                ),
                              );
                            }
                          }
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: AdaptiveCircularProgressIndicator(
                                color: color3),
                          );
                        }

                        if (snapshot.hasError) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Image.asset(
                              //   'assets/images/documentpending.png',
                              // ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                "Vous n'avez pas encore des demandes refusés",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                    color: Colors.white,
                                    height: 1.h),
                              )
                            ],
                          );
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   'assets/images/documentpending.png',
                            // ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Text(
                              "Vous n'avez pas encore des demandes refusés",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                  color: Colors.white,
                                  height: 1.h),
                            )
                          ],
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
