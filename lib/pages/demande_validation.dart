import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/main.dart';
import 'package:whowiyati/models/demande_validation_model.dart';
import 'package:whowiyati/pages/dealpad.dart';

import '../const.dart';

class DemandeValidation extends StatefulWidget {
  final VoidCallback onPop;
  const DemandeValidation({super.key, required this.onPop});

  @override
  State<DemandeValidation> createState() => _DemandeValidationState();
}

class _DemandeValidationState extends State<DemandeValidation> {
  // ************** Logic **************
  getDemandeValidation() async {
    String? userId = prefs.getString('user_id');

    var request = http.Request(
        'GET', Uri.parse('http://10.0.2.2:8000/wh/requests/$userId'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);
      print(answerJson);
      return answerJson;
    } else {
      print(response.reasonPhrase);
    }
  }

  updateDemandeStatus(String requestId, String statusCode) async {
    var request = http.MultipartRequest(
        'PUT', Uri.parse('http://10.0.2.2:8000/wh/validate/request/'));

    request.fields.addAll({'id': requestId, 'code': statusCode});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);
      print("====================");
      print(answerJson);
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    getDemandeValidation();
    super.initState();
  }

  // ************** UI **************
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onPop();
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
                                itemBuilder: (context, index) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.23,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15.w,
                                    horizontal: 20.w,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(20.r)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'ID : ',
                                              style: TextStyle(
                                                  color: color2,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600)),
                                          TextSpan(
                                              text: enAttenteList[index]
                                                  .requestIdentify,
                                              style: TextStyle(
                                                  color: color2,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600))
                                        ]),
                                      ),
                                      Divider(color: color6),
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'Source demande: ',
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              )),
                                          TextSpan(
                                              text: enAttenteList[index]
                                                  .sourceDemande,
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              ))
                                        ]),
                                      ),
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'Créer à : ',
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              )),
                                          TextSpan(
                                              text: enAttenteList[index]
                                                  .createdAt,
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              ))
                                        ]),
                                      ),
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'type demande : ',
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              )),
                                          TextSpan(
                                              text: enAttenteList[index]
                                                  .typeDemande,
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              ))
                                        ]),
                                      ),
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
                                                    onPressedDemandeValidationAction:
                                                        () async {
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
                                              backgroundColor:
                                                  Color(0xFFD32424),
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
                                                    onPressedDemandeValidationAction:
                                                        () async {
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
                                ),
                              );
                            } else {
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
                                    "Vous n'avez pas encore des demandes en attente",
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
                          }
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: color3,
                            ),
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
                                "Vous n'avez pas encore de documents en attente",
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
                              "Vous n'avez pas encore de documents en attente",
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
                              if (element["Status"] == "1") {
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
                                itemBuilder: (context, index) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15.w,
                                    horizontal: 20.w,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'ID : ',
                                              style: TextStyle(
                                                  color: color3,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600)),
                                          TextSpan(
                                              text: accepteList[index]
                                                  .requestIdentify,
                                              style: TextStyle(
                                                  color: color3,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600))
                                        ]),
                                      ),
                                      Divider(color: color6),
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'Source demande: ',
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              )),
                                          TextSpan(
                                              text: accepteList[index]
                                                  .sourceDemande,
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              ))
                                        ]),
                                      ),
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'Créer à : ',
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              )),
                                          TextSpan(
                                              text:
                                                  accepteList[index].createdAt,
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              ))
                                        ]),
                                      ),
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'type demande : ',
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              )),
                                          TextSpan(
                                              text: accepteList[index]
                                                  .typeDemande,
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              ))
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
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
                                    "Vous n'avez pas encore des demandes accepté",
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
                          }
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: color3,
                            ),
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
                                "Vous n'avez pas encore des demandes accepté",
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
                              "Vous n'avez pas encore des demandes accepté",
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
                                itemBuilder: (context, index) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 15.w,
                                    horizontal: 20.w,
                                  ),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(20.r)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'ID : ',
                                              style: TextStyle(
                                                  color: Color(0xFFD32424),
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600)),
                                          TextSpan(
                                              text: refuseList[index]
                                                  .requestIdentify,
                                              style: TextStyle(
                                                  color: Color(0xFFD32424),
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600))
                                        ]),
                                      ),
                                      Divider(color: color6),
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'Source demande: ',
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              )),
                                          TextSpan(
                                              text: refuseList[index]
                                                  .sourceDemande,
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              ))
                                        ]),
                                      ),
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'Créer à : ',
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              )),
                                          TextSpan(
                                              text: refuseList[index].createdAt,
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              ))
                                        ]),
                                      ),
                                      Text.rich(
                                        TextSpan(children: [
                                          TextSpan(
                                              text: 'type demande : ',
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              )),
                                          TextSpan(
                                              text:
                                                  refuseList[index].typeDemande,
                                              style: TextStyle(
                                                color: color9,
                                                fontSize: 15.sp,
                                              ))
                                        ]),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
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
                                    "Vous n'avez pas encore des demandes refusé",
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
                          }
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: color3,
                            ),
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
                                "Vous n'avez pas encore des demandes refusé",
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
                              "Vous n'avez pas encore des demandes refusé",
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
