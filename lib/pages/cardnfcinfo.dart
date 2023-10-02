import 'package:flutter/material.dart';

import '../main.dart';
import '../widgets/base64img.dart';

class CardNfcInfo extends StatefulWidget {
  const CardNfcInfo({super.key});

  @override
  State<CardNfcInfo> createState() => _CardNfcInfoState();
}

class _CardNfcInfoState extends State<CardNfcInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Divider(
              color: Colors.blue,
              thickness: 1,
            ),
            Text("Personal Data"),
            Divider(
              color: Colors.blue,
              thickness: 1,
            ),
            Base64ImageWidget(
              base64String: prefs.getString('face').toString(),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              prefs.getString('surname_latin').toString() +
                  ' ' +
                  prefs.getString('name_latin').toString() +
                  '       ' +
                  prefs.getString('surname_arabic').toString() +
                  ' ' +
                  prefs.getString('name_arabic').toString(),
            ),
            SizedBox(
              height: 10,
            ),
            Text(prefs.getString('birthplace_latin').toString() +
                '       ' +
                prefs.getString('birthplace_arabic').toString()),
            SizedBox(
              height: 10,
            ),
            Text(prefs.getString('birth_date').toString() +
                '       ' +
                prefs.getString('blood_type').toString()),
            SizedBox(
              height: 10,
            ),
            Text(prefs.getString('sexe_latin').toString() +
                '       ' +
                prefs.getString('sex_arabic').toString()),
            SizedBox(
              height: 10,
            ),
            Text(prefs.getString('nin').toString()),
            SizedBox(
              height: 10,
            ),
            Base64ImageWidget(
              base64String: prefs.getString('signature').toString(),
            ),
            Divider(
              color: Colors.blue,
              thickness: 1,
            ),
            Text("Card Data"),
            Divider(
              color: Colors.blue,
              thickness: 1,
            ),
            SizedBox(
              height: 10,
            ),
            Text(prefs.getString('daira').toString()),
            SizedBox(
              height: 10,
            ),
            Text(prefs.getString('baladia_latin').toString() +
                '       ' +
                prefs.getString('baladia_arab').toString() +
                ' '),
            SizedBox(
              height: 10,
            ),
            Text(prefs.getString('deliv_date').toString()),
            SizedBox(
              height: 10,
            ),
            Text(prefs.getString('exp_date').toString()),
            SizedBox(
              height: 10,
            ),
          ]),
        ],
      )),
    );
  }
}
