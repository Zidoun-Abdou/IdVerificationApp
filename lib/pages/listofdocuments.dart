import 'dart:convert';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:whowiyati/pages/seedocument.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/pages/signature_logs.dart';
import '../const.dart';
import '../main.dart';
import 'documents.dart';

class ListOfDocuments extends StatefulWidget {
  const ListOfDocuments({super.key});

  @override
  State<ListOfDocuments> createState() => _ListOfDocumentsState();
}

class _ListOfDocumentsState extends State<ListOfDocuments> {
  bool _isloading = false;

  void seeFile(String id_file, bool is_signed) async {
    _isloading = true;
    setState(() {});

    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.icosnet.com/sign/view-document/'));

    /// Initialize Ip Address
    var ipAddress = IpAddress(type: RequestType.text);

    /// Get the IpAddress based on requestType.
    dynamic data = await ipAddress.getIpAddress();
    String ip = data.toString();

    request.fields.addAll({
      'user_email': prefs.getString("mail").toString(),
      'ip_address': ip,
      'source': '1',
      'action': '1',
      'document_id': id_file
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (response.statusCode == 201) {
      print(answerJson);
      _isloading = false;
      setState(() {});
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SeeDocument(
            myurl: answerJson["link"],
            is_signed: is_signed,
          ),
        ),
      );
    } else {
      print(answerJson);
      _isloading = false;
      setState(() {});
    }
  }

  void seeLogFile(String id_file) async {
    _isloading = true;
    setState(() {});

    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
    var request = http.MultipartRequest(
        'GET', Uri.parse('https://api.icosnet.com/sign/log-document/'));
    request.fields.addAll({'document_id': id_file});

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (response.statusCode == 200) {
      print(answerJson);
      _isloading = false;
      setState(() {});
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SignaturesLogs(
                base64code: answerJson["base64_images"][0],
              )));
    } else {
      print(answerJson);
      _isloading = false;
      setState(() {});
    }
  }

  void seeSignedFile(String id_file) async {
    _isloading = true;
    setState(() {});

    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
    var request = http.MultipartRequest('POST',
        Uri.parse('https://api.icosnet.com/sign/view-signed-document/'));

    /// Initialize Ip Address
    var ipAddress = IpAddress(type: RequestType.text);

    /// Get the IpAddress based on requestType.
    dynamic data = await ipAddress.getIpAddress();
    String ip = data.toString();

    request.fields.addAll({
      'user_email': prefs.getString("mail").toString(),
      'ip_address': ip,
      'source': '1',
      'action': '1',
      'document_id': id_file
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (response.statusCode == 201) {
      print(answerJson);
      _isloading = false;
      setState(() {});
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SeeDocument(
                myurl: answerJson["link"],
                is_signed: false,
              )));
    } else {
      print(answerJson);
      _isloading = false;
      setState(() {});
    }
  }

  String xorDecrypt(String encryptedBase64) {
    String encryptionKey = "Rg4vhNDsLmTqB8N84HjDgs23i+wlfTDOjeJvPmO8/Co=";
    try {
      List<int> encryptedBytes = base64.decode(encryptedBase64);
      String decryptedText = '';

      for (int i = 0; i < encryptedBytes.length; i++) {
        int decryptedByte = encryptedBytes[i] ^
            encryptionKey.codeUnitAt(i % encryptionKey.length);
        decryptedText += String.fromCharCode(decryptedByte);
      }

      return decryptedText;
    } catch (e) {
      print("An error occurred during decryption: $e");
      // Handle the error as per your requirements, e.g., return an error message.
      return "Decryption failed";
    }
  }

  void signFile(String id_file) async {
    _isloading = true;
    setState(() {});

    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.icosnet.com/sign/sign-document/'));
    request.fields.addAll({
      'signer_email': prefs.getString("mail").toString(),
      'document_id': id_file
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (response.statusCode == 201) {
      print(answerJson);
      _isloading = false;
      setState(() {});
    } else {
      print(answerJson);
      _isloading = false;
      setState(() {});
    }
  }

  void verifyQrCode(String link) async {
    _isloading = true;
    setState(() {});
    try {
      var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
      var request = http.Request('GET', Uri.parse(link));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      String answer = await response.stream.bytesToString();
      var answerJson = jsonDecode(answer);

      if (response.statusCode == 200 && answerJson["valid"] == true) {
        Alert(
          context: context,
          title: "Success",
          desc: "This Document is verified succesfully",
          image: Image.asset("assets/images/success.png"),
        ).show();
      } else {
        Alert(
          context: context,
          title: "Failed",
          desc: "This Document is not verified",
          image: Image.asset("assets/images/failed.png"),
        ).show();
      }
      _isloading = false;
      setState(() {});
    } catch (e) {
      Alert(
        context: context,
        title: "Failed",
        desc: "This Document is not verified",
        image: Image.asset("assets/images/failed.png"),
      ).show(); // Handle the error as needed, e.g., show an error message to the user.

      _isloading = false;
      setState(() {});
    }
  }

  void cancelFile(String id_file) async {
    _isloading = true;
    setState(() {});

    /// Initialize Ip Address
    var ipAddress = IpAddress(type: RequestType.text);

    /// Get the IpAddress based on requestType.
    dynamic data = await ipAddress.getIpAddress();
    String ip = data.toString();

    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.icosnet.com/sign/cancel-document/'));
    request.fields.addAll({
      'user_email': prefs.getString("mail").toString(),
      'document_id': id_file,
      'ip_address': ip,
      'source': '4'
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (response.statusCode == 201) {
      print(answerJson);
      _isloading = false;
      setState(() {});
    } else {
      print(answerJson);
      _isloading = false;
      setState(() {});
    }
  }

  getDocuments() async {
    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.icosnet.com/sign/documents/'));
    request.fields.addAll({'user_email': prefs.getString("mail").toString()});

    request.headers.addAll(headers);
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

  @override
  void initState() {
    getDocuments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mes Documents"),
          actions: [
            IconButton(
                onPressed: () async {
                  var codeSanner =
                      await BarcodeScanner.scan(); //barcode scanner
                  String _qrCodeResult = codeSanner.rawContent;
                  String link = await xorDecrypt(_qrCodeResult);
                  verifyQrCode(link);
                },
                icon: Icon(Icons.qr_code_2_rounded)),
            IconButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Documents(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.add,
                )),
          ],
          centerTitle: true,
          backgroundColor: color1,
          bottom: TabBar(
            indicatorColor: color3,
            tabs: [
              Tab(
                text: "En attente",
              ),
              Tab(
                text: "Signé déja",
              ),
              Tab(
                text: "Refusé",
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: _isloading
              ? Center(
                  child: CircularProgressIndicator(
                  color: color3,
                ))
              : TabBarView(
                  children: [
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: FutureBuilder(
                          future: getDocuments(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot
                                  .data["documents_pending"].isNotEmpty) {
                                return ListView.builder(
                                    itemCount: snapshot
                                        .data["documents_pending"].length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      return InkWell(
                                        onTap: () {
                                          seeFile(
                                              snapshot.data["documents_pending"]
                                                      [i]["id"]
                                                  .toString(),
                                              true);
                                        },
                                        child: Card(
                                          elevation: 1,
                                          child: ListTile(
                                            title: Text(
                                              "${snapshot.data["documents_pending"][i]["title"]}",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                            trailing: Wrap(
                                              spacing:
                                                  12, // space between two icons
                                              children: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        backgroundColor: color2,
                                                        context: context,
                                                        builder: (context) {
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal: 20
                                                                            .w,
                                                                        vertical:
                                                                            20.h),
                                                                child: Text(
                                                                  "Êtes-vous sûr de vouloir signer ce document?",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      signFile(
                                                                        "${snapshot.data["documents_pending"][i]["id"]}",
                                                                      );
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        "Oui"),
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: color3,
                                                                        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
                                                                        foregroundColor: Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.r),
                                                                        ),
                                                                        elevation: 10,
                                                                        shadowColor: color3),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        "Non"),
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: Colors.red,
                                                                        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
                                                                        foregroundColor: Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.r),
                                                                        ),
                                                                        elevation: 10,
                                                                        shadowColor: Colors.red),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Text("Signer"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: color3,
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        backgroundColor: color2,
                                                        context: context,
                                                        builder: (context) {
                                                          return Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal: 20
                                                                            .w,
                                                                        vertical:
                                                                            20.h),
                                                                child: Text(
                                                                  "Êtes-vous sûr de vouloir refusé ce document?",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      cancelFile(
                                                                        "${snapshot.data["documents_pending"][i]["id"]}",
                                                                      );
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        "Oui"),
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: color3,
                                                                        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
                                                                        foregroundColor: Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.r),
                                                                        ),
                                                                        elevation: 10,
                                                                        shadowColor: color3),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        "Non"),
                                                                    style: ElevatedButton.styleFrom(
                                                                        backgroundColor: Colors.red,
                                                                        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 30.w),
                                                                        foregroundColor: Colors.white,
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5.r),
                                                                        ),
                                                                        elevation: 10,
                                                                        shadowColor: Colors.red),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              )
                                                            ],
                                                          );
                                                        });
                                                  },
                                                  child: Text("Refuser"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                              "Crée par: ${snapshot.data["documents_pending"][i]["uploaded_by_email"]}",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
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
                                  Image.asset(
                                    'assets/images/documentpending.png',
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    "Vous n'avez pas encore de documents en attente",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              );
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/documentpending.png',
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  "Vous n'avez pas encore de documents en attente",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                      height: 1.h),
                                )
                              ],
                            );
                          }),
                    ),
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: FutureBuilder(
                          future: getDocuments(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot
                                  .data["documents_signed_all"].isNotEmpty) {
                                print(snapshot.data["documents_signed_all"]);
                                return ListView.builder(
                                    itemCount: snapshot
                                        .data["documents_signed_all"].length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      return InkWell(
                                        onTap: () {
                                          seeSignedFile(snapshot
                                              .data["documents_signed_all"][i]
                                                  ["id"]
                                              .toString());
                                        },
                                        child: Card(
                                          elevation: 1,
                                          child: ListTile(
                                            title: Text(
                                              "${snapshot.data["documents_signed_all"][i]["title"]}",
                                              style: TextStyle(
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                            trailing: Wrap(
                                              spacing:
                                                  12, // space between two icons
                                              children: <Widget>[
                                                IconButton(
                                                  onPressed: () {
                                                    seeLogFile(snapshot.data[
                                                            "documents_signed_all"]
                                                            [i]["id"]
                                                        .toString());
                                                  },
                                                  icon: Icon(
                                                    Icons.receipt_long_rounded,
                                                    color: color3,
                                                    size: 25.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                              "Crée par: ${snapshot.data["documents_signed_all"][i]["uploaded_by_email"]}",
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    });
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
                                  Image.asset(
                                    'assets/images/documents.png',
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    "Vous n'avez pas encore de documents signé",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              );
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/documents.png',
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  "Vous n'avez pas encore de documents signé",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                      height: 1.h),
                                )
                              ],
                            );
                          }),
                    ),
                    Container(
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: FutureBuilder(
                          future: getDocuments(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot
                                  .data["documents_canceled"].isNotEmpty) {
                                return ListView.builder(
                                    itemCount: snapshot
                                        .data["documents_canceled"].length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, i) {
                                      return Card(
                                        elevation: 1,
                                        child: ListTile(
                                          title: Text(
                                            "${snapshot.data["documents_canceled"][i]["title"]}",
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          trailing: Wrap(
                                            spacing:
                                                12, // space between two icons
                                            children: <Widget>[
                                              IconButton(
                                                onPressed: () {
                                                  seeFile(
                                                      snapshot.data[
                                                              "documents_canceled"]
                                                              [i]["id"]
                                                          .toString(),
                                                      false);
                                                },
                                                icon: Icon(
                                                  Icons.remove_red_eye_outlined,
                                                  color: color3,
                                                  size: 25.sp,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                            "Crée par: ${snapshot.data["documents_canceled"][i]["uploaded_by_email"]}",
                                            style: TextStyle(
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      );
                                    });
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
                                  Image.asset(
                                    'assets/images/documentrefused.png',
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    "Vous n'avez pas encore de documents refusé",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15.sp),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              );
                            }

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/documentrefused.png',
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  "Vous n'avez pas encore de documents refusé",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                      height: 1.h),
                                )
                              ],
                            );
                          }),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
