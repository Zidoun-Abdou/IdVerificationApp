import 'package:flutter/material.dart';

class CustomByIcosnetHint extends StatelessWidget {
  const CustomByIcosnetHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: [
        TextSpan(
            text: 'WHOWIATY',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600)),
        TextSpan(
          text: ' by icosnet',
          style: TextStyle(fontFamily: 'Inter', color: Colors.white),
        ),
      ]),
    );
  }
}
