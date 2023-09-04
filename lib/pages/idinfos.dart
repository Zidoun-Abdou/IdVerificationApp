import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/pages/steps.dart';
import 'package:whowiyati/pages/welcome.dart';

class IdInfo extends StatefulWidget {
  final String name;
  final String surname;
  final String country;
  final String nationality;
  final String birth_date;
  final String expiry_date;
  final String sex;
  final String document_type;
  final String document_number;
  final String token;

  const IdInfo(
      {Key? key,
      required this.name,
      required this.surname,
      required this.country,
      required this.nationality,
      required this.birth_date,
      required this.expiry_date,
      required this.sex,
      required this.document_type,
      required this.document_number,
      required this.token})
      : super(key: key);

  @override
  State<IdInfo> createState() => _IdInfoState();
}

class _IdInfoState extends State<IdInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("name: ${widget.name}"),
            Text("surname: ${widget.surname}"),
            Text("country: ${widget.country}"),
            Text("nationality: ${widget.nationality}"),
            Text("birth_date: ${widget.birth_date}"),
            Text("expiry_date: ${widget.expiry_date}"),
            Text("sex: ${widget.sex}"),
            Text("document_type: ${widget.document_type}"),
            SizedBox(
              height: 30.h,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Steps(token: widget.token,)),
                      (Route<dynamic> route) => false);
                },
                child: Text("Go home"))
          ],
        ),
      )),
    );
  }
}
