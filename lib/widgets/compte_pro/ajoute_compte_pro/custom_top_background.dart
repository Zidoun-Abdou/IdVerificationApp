import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../welcome/custom_bonjour_welcome.dart';
import '../../welcome/custom_button_ajoute_compte_pro_welcome.dart';
import '../../welcome/custom_identifient_welcome.dart';
import '../../welcome/custom_notif_welcome.dart';
import '../../welcome/custom_title_welcome.dart';

class CustomTopBackground extends StatelessWidget {
  const CustomTopBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      height: MediaQuery.of(context).size.height / 2.3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          // color: color1,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.r),
              bottomRight: Radius.circular(20.r))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 1,
              ),
              CustomIdentifientWelcome(),
              SvgPicture.asset(
                "assets/images/menu.svg",
                height: 22.h,
              )
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomBonjourWelcome(),
              CustomNotifWelcome(),
            ],
          ),
          CustomTitleWelcome(),
          SizedBox(
            height: 40.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButtonAjouteCompteProWelcome(),
            ],
          )
        ],
      ),
    );
  }
}
