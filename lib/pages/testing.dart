import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          RiveAnimation.asset("assets/images/animation.riv"),
    );
  }
}
