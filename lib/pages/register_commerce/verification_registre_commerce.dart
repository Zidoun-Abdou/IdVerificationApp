import 'package:flutter/material.dart';

class VerificationRegistreCommerce extends StatefulWidget {
  final ValueNotifier<int> currentEtapeValueNotifier;
  final ValueNotifier<bool> etape3ValueNotifier;
  const VerificationRegistreCommerce(
      {super.key,
      required this.currentEtapeValueNotifier,
      required this.etape3ValueNotifier});

  @override
  State<VerificationRegistreCommerce> createState() =>
      _VerificationRegistreCommerceState();
}

class _VerificationRegistreCommerceState
    extends State<VerificationRegistreCommerce> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
