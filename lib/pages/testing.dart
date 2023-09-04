import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:whowiyati/const.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:http/http.dart' as http;
import 'package:whowiyati/main.dart';
import 'dart:convert';
import 'package:whowiyati/pages/otp.dart';

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  bool _isFirstWidget = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _toggleWidget();
  }

  bool _loop = true;
  void _toggleWidget() {
    setState(() {
      _isFirstWidget = !_isFirstWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                ScaleTransition(child: child, scale: animation),
            child: _isFirstWidget
                ? Container(
                    key: ValueKey(1),
                    width: 100,
                    height: 200,
                    color: Colors.blue,
                    child: Center(
                      child: Text('First Widget',
                          style: TextStyle(color: Colors.white)),
                    ),
                  )
                : Container(
                    key: ValueKey(2),
                    width: 200,
                    height: 100,
                    color: Colors.red,
                    child: Center(
                      child: Text('Second Widget',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _toggleWidget,
            child: Text('Switch Widget'),
          ),
        ],
      ),
    );
  }
}
