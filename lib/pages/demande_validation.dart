import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/main.dart';
import 'package:whowiyati/models/demande_validation_model.dart';

import '../const.dart';

class DemandeValidation extends StatefulWidget {
  const DemandeValidation({super.key});

  @override
  State<DemandeValidation> createState() => _DemandeValidationState();
}

class _DemandeValidationState extends State<DemandeValidation> {
  // ************** Logic **************
  getDemandeValidation() async {
    String? id = prefs.getString('user_id');

    var request = http.Request(
        'GET',
        Uri.parse(
            'https://ibm-p.vazii.com/esb/wh_get_all_requests.php?id=$id'));

    http.StreamedResponse response = await request.send();

    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);

    if (answerJson.isNotEmpty) {
      print(answerJson);
      return answerJson;
    } else {
      print(response.reasonPhrase);
    }
  }

  updateDemandeStatus(String id, String statusCode) async {
    var request = http.MultipartRequest('POST',
        Uri.parse('https://ibm-p.vazii.com/esb/who_user_validation.php'));

    request.fields.addAll({'id': id, 'code': statusCode});

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);
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
    return DefaultTabController(
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
                            if (element["status"] == "0") {
                              enAttenteList.add(
                                  DemandeValidationModel.fromJson(element));
                            }
                          }
                          if (enAttenteList.isNotEmpty) {
                            return ListView.separated(
                              separatorBuilder: (context, index) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Divider(
                                  color: color6,
                                  thickness: 1,
                                ),
                              ),
                              itemCount: enAttenteList.length,
                              itemBuilder: (context, index) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'ID : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: enAttenteList[index].id,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                            ))
                                      ]),
                                    ),
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'Source demande: ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: enAttenteList[index]
                                                .requestSource,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                            ))
                                      ]),
                                    ),
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'Créer à : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text:
                                                enAttenteList[index].createdAt,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                            ))
                                      ]),
                                    ),
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'type demande : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: enAttenteList[index]
                                                .typeRequest,
                                            style: TextStyle(
                                              color: Colors.white,
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
                                            await updateDemandeStatus(
                                                enAttenteList[index].id!, "-1");
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFFD32424),
                                            foregroundColor: Colors.white,
                                            fixedSize: Size(100.w, 30.h),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60.r),
                                            ),
                                            elevation: 20,
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
                                            await updateDemandeStatus(
                                                enAttenteList[index].id!, "1");
                                            setState(() {});
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: color3,
                                            foregroundColor: Colors.white,
                                            fixedSize: Size(100.w, 30.h),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.r),
                                            ),
                                            elevation: 20,
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                            if (element["status"] == "1") {
                              accepteList.add(
                                  DemandeValidationModel.fromJson(element));
                            }
                          }

                          if (accepteList.isNotEmpty) {
                            return ListView.separated(
                              separatorBuilder: (context, index) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Divider(
                                  color: color6,
                                  thickness: 1,
                                ),
                              ),
                              itemCount: accepteList.length,
                              itemBuilder: (context, index) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'ID : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: accepteList[index].id,
                                            style: TextStyle(
                                              color: color3,
                                              fontSize: 15.sp,
                                            ))
                                      ]),
                                    ),
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'Source demande: ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: accepteList[index]
                                                .requestSource,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                            ))
                                      ]),
                                    ),
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'Créer à : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: accepteList[index].createdAt,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                            ))
                                      ]),
                                    ),
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'type demande : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text:
                                                accepteList[index].typeRequest,
                                            style: TextStyle(
                                              color: Colors.white,
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                            if (element["status"] == "-1") {
                              refuseList.add(
                                  DemandeValidationModel.fromJson(element));
                            }
                          }

                          if (refuseList.isNotEmpty) {
                            return ListView.separated(
                              separatorBuilder: (context, index) => Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Divider(
                                  color: color6,
                                  thickness: 1,
                                ),
                              ),
                              itemCount: refuseList.length,
                              itemBuilder: (context, index) => Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.23,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'ID : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: refuseList[index].id,
                                            style: TextStyle(
                                              color: Color(0xFFD32424),
                                              fontSize: 15.sp,
                                            ))
                                      ]),
                                    ),
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'Source demande: ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text:
                                                refuseList[index].requestSource,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                            ))
                                      ]),
                                    ),
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'Créer à : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: refuseList[index].createdAt,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                            ))
                                      ]),
                                    ),
                                    Text.rich(
                                      TextSpan(children: [
                                        TextSpan(
                                            text: 'type demande : ',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600)),
                                        TextSpan(
                                            text: refuseList[index].typeRequest,
                                            style: TextStyle(
                                              color: Colors.white,
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
    );
  }
}
