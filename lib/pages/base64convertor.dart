import 'dart:convert';

import 'package:flutter/material.dart';

class Base64ImageWidget extends StatelessWidget {
  final String base64String;

  Base64ImageWidget({required this.base64String});

  @override
  Widget build(BuildContext context) {
    return Image.memory(width: 100,
      base64Decode(base64String),
      fit: BoxFit.contain,
    );
  }
}