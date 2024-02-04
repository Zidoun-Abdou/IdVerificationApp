import 'package:dmrtd/dmrtd.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/widgets/custom_main_button.dart';
import 'package:whowiyati/widgets/custom_title_text.dart';
import '../const.dart';
import 'readnfc.dart';

class WelcomeNfc extends StatefulWidget {
  final String dob;
  final String doe;
  final String idnumber;
  final String face;
  final String front;
  final String back;
  final String signature;

  const WelcomeNfc(
      {Key? key,
      required this.dob,
      required this.doe,
      required this.idnumber,
      required this.face,
      required this.front,
      required this.back,
      required this.signature})
      : super(key: key);

  @override
  State<WelcomeNfc> createState() => _WelcomeNfcState();
}

class _WelcomeNfcState extends State<WelcomeNfc> {
  bool? _is_loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      body: SafeArea(
        child: Center(
          child: _is_loading == true
              ? CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: CustomTitleText(
                          data: "Validation Via NFC",
                          color: Colors.white,
                          size: 16),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.w),
                      child: CustomTitleText(
                          data: "Cette action nécessite l’activation de l’NFC",
                          color: Colors.white,
                          size: 15),
                    ),
                    Image.asset(
                      'assets/images/nfcphone.png',
                      // Replace with the actual path to your image file
                      fit: BoxFit.fill,
                    )
                        .animate()
                        .fade(delay: 1000.ms)
                        .moveY(delay: 1000.ms, end: 1, begin: 500),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      child: CustomMainButton(
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ReadNfc(
                                    dob: widget.dob,
                                    doe: widget.doe,
                                    idnumber: widget.idnumber,
                                    face: widget.face,
                                    back: widget.back,
                                    front: widget.front,
                                    signature: widget.signature,
                                  )));
                        },
                        text: 'Continuer',
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
