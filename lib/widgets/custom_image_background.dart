import 'package:flutter/material.dart';

class CustomImageBackground extends StatelessWidget {
  const CustomImageBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
      child: Image.asset(
        "assets/images/background.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }
}
