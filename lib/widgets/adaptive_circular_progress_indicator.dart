import 'dart:io';
import 'package:flutter/material.dart';

class AdaptiveCircularProgressIndicator extends StatelessWidget {
  final Color color;
  const AdaptiveCircularProgressIndicator({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Platform.isAndroid
          ? CircularProgressIndicator(
              color: color,
            )
          : CircularProgressIndicator.adaptive(
              backgroundColor: color,
            ),
    );
  }
}
