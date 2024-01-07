import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/main.dart';
import 'package:whowiyati/pages/listofdocuments.dart';
import 'package:http/http.dart' as http;
import 'package:get_ip_address/get_ip_address.dart';
import '../const.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  String _document = "";
  List<String> _mailList = [prefs.getString("mail").toString()];
  final _formKey = GlobalKey<FormState>();
  TextEditingController _mailContr = TextEditingController();
  bool _isloading = false;

  void sendFile() async {
    _isloading = true;
    setState(() {});

    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.icosnet.com/sign/create/'));

    // Iterate through mailList to generate the JSON string
    List<Map<String, dynamic>> usersList = [];
    for (int i = 0; i < _mailList.length; i++) {
      Map<String, dynamic> user = {
        'email': _mailList[i],
        'order': 0,
      };
      usersList.add(user);
    }

    usersList.add({
      'email': prefs.getString("mail").toString(),
      'order': 0,
    });

    // Convert the list of users to a JSON string
    String usersJson = jsonEncode({'users': usersList});

    /// Initialize Ip Address
    var ipAddress = IpAddress(type: RequestType.text);

    /// Get the IpAddress based on requestType.
    dynamic data = await ipAddress.getIpAddress();
    String ip = data.toString();

    request.fields.addAll({
      'ip_address': ip,
      'uploaded_by_email': prefs
          .getString("mail")
          .toString(), // Assuming the first email is used here
      'users_signatures': usersJson,
    });
    request.files.add(await http.MultipartFile.fromPath('file', _document));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);
    if (response.statusCode == 201) {
      print(answerJson);
      _isloading = false;
      setState(() {});
      Navigator.of(context).pop();
    } else {
      print(answerJson);
      _isloading = false;
      setState(() {});
    }
  }

  void getSignedFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false);

    if (result != null) {
      PlatformFile file = result.files.first;
      String? filePath = file.path;
      _document = filePath.toString();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? Center(
            child: CircularProgressIndicator(
              color: color3,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(
                "Signture des documents",
              ),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              // actions: [
              //   IconButton(
              //       onPressed: () {
              //         Navigator.of(context).push(MaterialPageRoute(
              //             builder: (context) => ListOfDocuments()));
              //       },
              //       icon: Icon(
              //         Icons.wallet,
              //         color: color3,
              //         size: 30.sp,
              //       )),
              // ],
            ),
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      // Replace with the actual path to your image file
                      fit: BoxFit.contain,
                      height: 100.h,
                      width: 200.w,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Liste des signatères:   ",
                          style:
                              TextStyle(fontSize: 15.sp, color: Colors.white),
                        ),
                        IconButton(
                            onPressed: () async {
                              await showDialog<void>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        contentPadding: EdgeInsets.zero,
                                        content: Stack(
                                          clipBehavior: Clip.none,
                                          children: <Widget>[
                                            Positioned(
                                              right: -40,
                                              top: -40,
                                              child: InkResponse(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor: Colors.red,
                                                  child: Icon(Icons.close,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                            Form(
                                              key: _formKey,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    TextFormField(
                                                      validator: (val) {
                                                        return validInput(
                                                            val!, 6, 50);
                                                      },
                                                      cursorColor: color3,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      controller: _mailContr,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      // Set text color to white
                                                      decoration:
                                                          InputDecoration(
                                                        label: Text(
                                                          "Email",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        counterStyle: TextStyle(
                                                          color: Colors
                                                              .black, // Change this color to your desired color
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50.r),
                                                          borderSide:
                                                              BorderSide(
                                                            color: color3,
                                                          ),
                                                        ),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                        // Set background color to black
                                                        prefixIcon: Icon(
                                                          Icons.mail_outline,
                                                          color: Colors.black,
                                                        ),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(50
                                                                  .r), // Set border radius
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              color3, // Background color
                                                        ),
                                                        child: const Text(
                                                            'Ajouter personne'),
                                                        onPressed: () {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            _mailList.add(
                                                                _mailContr
                                                                    .text);
                                                            setState(() {});
                                                            Navigator.pop(
                                                                context);
                                                            _mailContr.text =
                                                                "";
                                                          }
                                                        },
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                            },
                            icon: Icon(
                              Icons.group_add_outlined,
                              color: color3,
                              size: 30.sp,
                            )),
                      ],
                    ),
                    Text(
                      "\"Ajoutez uniquement les e-mails des utilisateurs de Whowiyati\"",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      margin: EdgeInsets.all(5.h),
                      child: ListView.builder(
                        itemCount: _mailList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(
                              "${index + 1}",
                              style: TextStyle(color: Colors.white),
                            ),
                            title: Text(
                              _mailList[index],
                              style: TextStyle(color: Colors.white),
                            ),
                            trailing: Icon(
                              Icons.person,
                              color: color3,
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color3, // Background color
                      ),
                      onPressed: _document != ""
                          ? null
                          : () {
                              getSignedFile();
                            },
                      child: Text(
                        "Ajouter un document",
                        style: TextStyle(color: Colors.white, fontSize: 15.sp),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color3, // Background color
                      ),
                      onPressed: _document == ""
                          ? null
                          : () async {
                              var connectivityResult =
                                  await (Connectivity().checkConnectivity());
                              if (connectivityResult ==
                                      ConnectivityResult.mobile ||
                                  connectivityResult ==
                                      ConnectivityResult.wifi) {
                                sendFile();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Vous n'êtes pas connecté à Internet ✋🏻"),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: colorRed,
                                  ),
                                );
                              }
                            },
                      child: Text(
                        "Envoyer aux signatères",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
