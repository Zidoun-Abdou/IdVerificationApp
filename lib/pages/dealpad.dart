import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:whowiyati/pages/welcome.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_image_logo.dart';

class DialpadScreen extends StatefulWidget {
  final int status;
  final String password;
  final Future<void> Function()? onPressedAction;

  const DialpadScreen(
      {Key? key,
      required this.status,
      this.password = "******",
      this.onPressedAction})
      : super(key: key);

  @override
  _DialpadScreenState createState() => _DialpadScreenState();
}

class _DialpadScreenState extends State<DialpadScreen> {
  // ******************* Logic *******************
  List<String> dialpadNumbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0'
  ];

  String displayedNumber = '******'; // Initial value with 6 '*'

  String _myToken = "";

  void getToken() {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      _myToken = value.toString();
      print(_myToken);
    });
  }

  @override
  void initState() {
    super.initState();
    // Shuffle the dialpad numbers randomly at the beginning
    dialpadNumbers.shuffle();
  }

  Future<bool> addCode(String code) async {
    var headers = {'Authorization': 'Basic c2lnbmF0dXJlOnNpZ25hdHVyZQ=='};
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://api.icosnet.com/sign/wh/user/passcode/'));
    request.fields.addAll(
        {'user_id': prefs.getString('user_id').toString(), 'pass_code': code});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    String answer = await response.stream.bytesToString();
    var answerJson = jsonDecode(answer);

    return answerJson["success"];
  }

  // ******************* Interface *******************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color2,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageLogo(width: 200),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Bonjour ${prefs.getString("name_latin") ?? ""}",
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              widget.status == 1
                  ? 'Veuillez saisir votre nouveau code PIN'
                  : widget.status == 2
                      ? 'Veuillez confirmer votre nouveau code PIN'
                      : 'Veuillez saisir votre code PIN',
              style: TextStyle(fontSize: 15.0, color: Colors.grey),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    displayedNumber[0] == "*"
                        ? Icons.circle_outlined
                        : Icons.circle_rounded,
                    size: 15.h,
                    color: Colors.white,
                  ),
                  Icon(
                    displayedNumber[1] == "*"
                        ? Icons.circle_outlined
                        : Icons.circle_rounded,
                    size: 15.h,
                    color: Colors.white,
                  ),
                  Icon(
                    displayedNumber[2] == "*"
                        ? Icons.circle_outlined
                        : Icons.circle_rounded,
                    size: 15.h,
                    color: Colors.white,
                  ),
                  Icon(
                    displayedNumber[3] == "*"
                        ? Icons.circle_outlined
                        : Icons.circle_rounded,
                    size: 15.h,
                    color: Colors.white,
                  ),
                  Icon(
                    displayedNumber[4] == "*"
                        ? Icons.circle_outlined
                        : Icons.circle_rounded,
                    size: 15.h,
                    color: Colors.white,
                  ),
                  Icon(
                    displayedNumber[5] == "*"
                        ? Icons.circle_outlined
                        : Icons.circle_rounded,
                    size: 15.h,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            _buildDialpad(),
            SizedBox(height: 20.0),
            // _buildClearButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDialpad() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDialpadButton(0),
              _buildDialpadButton(1),
              _buildDialpadButton(2),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDialpadButton(3),
              _buildDialpadButton(4),
              _buildDialpadButton(5),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDialpadButton(6),
              _buildDialpadButton(7),
              _buildDialpadButton(8),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Text(""),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20.0),
                    shape: CircleBorder(),
                    backgroundColor: color2),
              ),
              _buildDialpadButton(9),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    displayedNumber = '******'; // Reset to the initial value
                    // Shuffle the dialpad numbers randomly when the clear button is pressed
                    dialpadNumbers.shuffle();
                  });
                },
                child: Icon(
                  Icons.backspace_rounded,
                  color: color3,
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(20.0),
                    shape: CircleBorder(),
                    backgroundColor: color1),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDialpadButton(int index) {
    if (index < dialpadNumbers.length) {
      return ElevatedButton(
        onPressed: () async {
          setState(() {
            if (displayedNumber.contains('*')) {
              // Replace the first '*' with the pressed number
              displayedNumber =
                  displayedNumber.replaceFirst('*', dialpadNumbers[index]);
            }
          });

          if (displayedNumber.substring(displayedNumber.length - 1) != "*") {
            /////////////////////////////////////////////////////////////////////////
            if (widget.status == 1 &&
                displayedNumber.substring(displayedNumber.length - 1) != "*") {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DialpadScreen(
                    status: 2,
                    password: displayedNumber,
                  ),
                ),
              );
            } else if (widget.status == 1 &&
                displayedNumber.substring(displayedNumber.length - 1) == "*") {
              Fluttertoast.showToast(
                  msg: "Code PIN incomplet",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }

            /////////////////////////////////////////////////////////////////////////
            if (widget.status == 2 &&
                widget.password == displayedNumber &&
                displayedNumber.substring(displayedNumber.length - 1) != "*") {
              if (await addCode(displayedNumber) == true) {
                await prefs.setString('pasword', displayedNumber);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Welcome(
                      token: _myToken,
                    ),
                  ),
                );
              } else {
                Fluttertoast.showToast(
                    msg: "utilisateur n'existe pas",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            } else if (widget.status == 2 &&
                widget.password != displayedNumber &&
                displayedNumber.substring(displayedNumber.length - 1) != "*") {
              Fluttertoast.showToast(
                  msg: "Mot de non identique",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (widget.status == 2 &&
                displayedNumber.substring(displayedNumber.length - 1) == "*") {
              Fluttertoast.showToast(
                  msg: "Mot de incomplet",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }

            /////////////////////////////////////////////////////////////////////

            if (widget.status == 3 &&
                displayedNumber == prefs.getString('pasword').toString()) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Welcome(
                    token: _myToken,
                  ),
                ),
              );
            } else if (widget.status == 3 &&
                displayedNumber.substring(displayedNumber.length - 1) == "*") {
              Fluttertoast.showToast(
                  msg: "Code PIN incomplet",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (widget.status == 3 &&
                displayedNumber != prefs.getString('pasword').toString()) {
              Fluttertoast.showToast(
                  msg: "Code PIN incorrect",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);

              setState(() {
                displayedNumber = '******'; // Reset to the initial value
                // Shuffle the dialpad numbers randomly when the clear button is pressed
                dialpadNumbers.shuffle();
              });
            }

            /////////////////////////////////////////////////////////////////////

            if (widget.status == 4 &&
                displayedNumber == prefs.getString('pasword').toString()) {
              await widget.onPressedAction!();
              Navigator.of(context).pop();
            } else if (widget.status == 4 &&
                displayedNumber.substring(displayedNumber.length - 1) == "*") {
              Fluttertoast.showToast(
                  msg: "Code PIN incomplet",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            } else if (widget.status == 4 &&
                displayedNumber != prefs.getString('pasword').toString()) {
              Fluttertoast.showToast(
                  msg: "Code PIN incorrect",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);

              setState(() {
                displayedNumber = '******'; // Reset to the initial value
                // Shuffle the dialpad numbers randomly when the clear button is pressed
                dialpadNumbers.shuffle();
              });
            }
          }

          // if (displayedNumber.length == 6 &&
          //     displayedNumber == "666666" &&
          //     displayedNumber != "******") {
          //   print(true);
          // } else if (displayedNumber.length == 6 &&
          //     displayedNumber != "666666" &&
          //     displayedNumber.substring(displayedNumber.length - 1) != "*") {
          //   print(false);

          //   setState(() {
          //     displayedNumber = '******'; // Reset to the initial value
          //     // Shuffle the dialpad numbers randomly when the clear button is pressed
          //     dialpadNumbers.shuffle();
          //   });
          //   Fluttertoast.showToast(
          //       msg: "Code PIN incorrect, réessayez!",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.CENTER,
          //       timeInSecForIosWeb: 1,
          //       backgroundColor: Colors.red,
          //       textColor: Colors.white,
          //       fontSize: 16.0);
          // }
        },
        child: Text(
          dialpadNumbers[index],
          style: TextStyle(fontSize: 24.0, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(20.0),
            shape: CircleBorder(),
            backgroundColor: color1),
      );
    } else {
      return Container(); // Return an empty container if the index is out of range
    }
  }

  Widget _buildClearButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50.w, vertical: 8.h),
      child: ElevatedButton(
        onPressed: () async {
          print(prefs.getString('pasword'));
          if (widget.status == 1 &&
              displayedNumber.substring(displayedNumber.length - 1) != "*") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => DialpadScreen(
                  status: 2,
                  password: displayedNumber,
                ),
              ),
            );
          } else if (widget.status == 1 &&
              displayedNumber.substring(displayedNumber.length - 1) == "*") {
            Fluttertoast.showToast(
                msg: "Code PIN incomplet",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }

          /////////////////////////////////////////////////////////////////////////
          if (widget.status == 2 &&
              widget.password == displayedNumber &&
              displayedNumber.substring(displayedNumber.length - 1) != "*") {
            if (await addCode(displayedNumber) == true) {
              await prefs.setString('pasword', displayedNumber);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Welcome(
                    token: _myToken,
                  ),
                ),
              );
            } else {
              Fluttertoast.showToast(
                  msg: "utilisateur n'existe pas",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          } else if (widget.status == 2 &&
              widget.password != displayedNumber &&
              displayedNumber.substring(displayedNumber.length - 1) != "*") {
            Fluttertoast.showToast(
                msg: "Mot de non identique",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (widget.status == 2 &&
              displayedNumber.substring(displayedNumber.length - 1) == "*") {
            Fluttertoast.showToast(
                msg: "Mot de incomplet",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }

          /////////////////////////////////////////////////////////////////////

          if (widget.status == 3 &&
              displayedNumber == prefs.getString('pasword').toString()) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Welcome(
                  token: _myToken,
                ),
              ),
            );
          } else if (widget.status == 3 &&
              displayedNumber.substring(displayedNumber.length - 1) == "*") {
            Fluttertoast.showToast(
                msg: "Code PIN incomplet",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (widget.status == 3 &&
              displayedNumber != prefs.getString('pasword').toString()) {
            Fluttertoast.showToast(
                msg: "Code PIN incorrect",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

            setState(() {
              displayedNumber = '******'; // Reset to the initial value
              // Shuffle the dialpad numbers randomly when the clear button is pressed
              dialpadNumbers.shuffle();
            });
          }

          /////////////////////////////////////////////////////////////////////

          if (widget.status == 4 &&
              displayedNumber == prefs.getString('pasword').toString()) {
            await widget.onPressedAction!();
            Navigator.of(context).pop();
          } else if (widget.status == 4 &&
              displayedNumber.substring(displayedNumber.length - 1) == "*") {
            Fluttertoast.showToast(
                msg: "Code PIN incomplet",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          } else if (widget.status == 4 &&
              displayedNumber != prefs.getString('pasword').toString()) {
            Fluttertoast.showToast(
                msg: "Code PIN incorrect",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);

            setState(() {
              displayedNumber = '******'; // Reset to the initial value
              // Shuffle the dialpad numbers randomly when the clear button is pressed
              dialpadNumbers.shuffle();
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color3,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          foregroundColor: Colors.white,
          minimumSize: Size.fromHeight(5.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
          elevation: 20,
          shadowColor: color3, // Set the shadow color
        ),
        child: Text(
          widget.status == 1
              ? 'Ajouter code PIN'
              : widget.status == 2
                  ? 'Confirmer code PIN'
                  : 'Insérer code PIN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
