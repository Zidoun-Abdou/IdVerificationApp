import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:whowiyati/const.dart';

class SignaturesLogs extends StatefulWidget {
  final String base64code;
  const SignaturesLogs({super.key, required this.base64code});

  @override
  State<SignaturesLogs> createState() => _SignaturesLogsState();
}

class _SignaturesLogsState extends State<SignaturesLogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color1,
        title: Text(
          "Signature Logs",
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Image.memory(
            width: MediaQuery.of(context).size.width,
            base64Decode(widget.base64code),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
