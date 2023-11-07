import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../const.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  String _document = "";

  void getDeclarationOfLoss() async {
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Signture des documents",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
              ),
              Text(
                "Files to join:",
                style: TextStyle(fontSize: 15.sp),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color3, // Background color
                ),
                onPressed: _document != ""
                    ? null
                    : () {
                        getDeclarationOfLoss();
                      },
                child: Text(
                  "Declaration of loss",
                  style: TextStyle(color: Colors.white, fontSize: 15.sp),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color1, // Background color
                ),
                onPressed: _document == ""
                    ? null
                    : () async {
                        var connectivityResult =
                            await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi) {
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("You are not connected to internet ✋🏻"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                child: Text(
                  "Send",
                  style: TextStyle(
                    color: Colors.white,
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
