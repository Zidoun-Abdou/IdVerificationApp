import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const.dart';
import '../../../core/widgets/custom_image_background.dart';
import '../../../core/widgets/custom_image_logo.dart';
import '../../../core/widgets/custom_main_button.dart';
import '../widgets/conditions/custom_checkbox_conditions.dart';
import '../widgets/conditions/custom_title_conditions.dart';
import 'phone.dart';

class Conditions extends StatefulWidget {
  const Conditions({Key? key}) : super(key: key);

  @override
  State<Conditions> createState() => _ConditionsState();
}

class _ConditionsState extends State<Conditions> {
  bool _isChecked = false;
  var _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomImageBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomImageLogo(width: 200),
                  ),
                  Expanded(
                      flex: 3,
                      child: ListView(
                        children: [
                          CustomTitleConditions(),
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 8.h),
                            child: CustomCheckboxConditions(
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = !_isChecked;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      )),
                  Expanded(
                      flex: 2,
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 50.h,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 8.h),
                            child: CustomMainButton(
                              onPressed: () {
                                if (_isChecked == true) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => Phone()));
                                }
                              },
                              text: "Continuer",
                              backgroundColor:
                                  _isChecked ? color3 : Colors.grey[850],
                              elevation: _isChecked ? 20 : 0,
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
