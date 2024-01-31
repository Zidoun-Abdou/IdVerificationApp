import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/compte_pro/steps_verify_compte_pro.dart';
import '../../const.dart';
import 'package:http/http.dart' as http;

import '../../widgets/adaptive_circular_progress_indicator.dart';

class MesComptesPro extends StatefulWidget {
  const MesComptesPro({super.key});

  @override
  State<MesComptesPro> createState() => _MesComptesProState();
}

class _MesComptesProState extends State<MesComptesPro> {
  // ******************* Logic *******************

  bool _isVerify = false;

  getCompanies() async {
    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
    var request = http.MultipartRequest(
        'GET',
        Uri.parse(
            'https://api.icosnet.com/sign/wh/companies/${prefs.getString('user_id').toString()}/'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);

    // print(answerJson["user_companies"]);

    return answerJson;
  }

  @override
  void initState() {
    getCompanies();
    super.initState();
  }

  // ******************* Interface *******************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color1,
        centerTitle: true,
        elevation: 0,
        title: Text("Mes Comptes Pro"),
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Text(
                "Naviguer vers les comptes professionnels\nou Ajouter un compte professionnel",
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
              SizedBox(height: 10.h),
              Expanded(
                flex: 2,
                child: FutureBuilder(
                  future: getCompanies(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (!listEquals(snapshot.data["user_companies"], [])) {
                        List companies = [];
                        companies.addAll(snapshot.data["user_companies"]);

                        return ListView.separated(
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(),
                          itemCount: companies.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () async {
                              if (companies[index]["company_user"]["status"]
                                      .toString() ==
                                  "1") {
                              } else {
                                if (companies[index]["company_user"]["phone"] ==
                                    "") {
                                  await prefs.setString("step", "0");
                                } else if (companies[index]["company_user"]
                                        ["email"] ==
                                    "") {
                                  await prefs.setString("step", "1");
                                } else {
                                  await prefs.setString("step", "2");
                                }
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => StepsVerifyComptePro(
                                          companyUserId: companies[index]
                                                      ["company_user"]
                                                  ["company_user_id"]
                                              .toString(),
                                          companyId: companies[index]
                                                  ["company_user"]["company"]
                                              .toString(),
                                        )));
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 20.w),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 20.w),
                              decoration: BoxDecoration(
                                color: color7,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/menu.svg",
                                        height: 22.h,
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Text(
                                        companies[index]["company_name"]
                                            .toString()
                                            .toUpperCase(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.sp,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          height: 1.1.h,
                                          letterSpacing: 0.20.w,
                                        ),
                                      ),
                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: companies[index]
                                                    ["company_user"]["status"]
                                                .toString() ==
                                            "1"
                                        ? color3
                                        : companies[index]["company_user"]
                                                        ["status"]
                                                    .toString() ==
                                                "0"
                                            ? Colors.orange
                                            : Colors.grey,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: AdaptiveCircularProgressIndicator(color: color3),
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
                            "Vous n'avez pas encore des comptes pro",
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
                          "Vous n'avez pas encore des comptes pro",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              color: Colors.white,
                              height: 1.h),
                          textAlign: TextAlign.center,
                        )
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
