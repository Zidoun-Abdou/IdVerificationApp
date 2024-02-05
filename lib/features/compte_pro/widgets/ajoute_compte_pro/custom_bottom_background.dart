import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_bottom_text_hint.dart';
import '../../../home/widgets/welcome/custom_welcome_item.dart';

class CustomBottomBackground extends StatelessWidget {
  const CustomBottomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomWelcomeItem(
                      icon: "profil",
                      title: "Mon\nprofile",
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomWelcomeItem(
                      icon: "document",
                      title: "Mes\ndocuments",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Row(
                children: [
                  Expanded(
                    child: CustomWelcomeItem(
                      icon: "star",
                      title: "Mes\ncomptes Pro",
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomWelcomeItem(
                      icon: "edit",
                      title: "Signature\nélectronique",
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20.h),
            child: CustomBottomTextHint(),
          ),
        ],
      ),
    );
  }
}
