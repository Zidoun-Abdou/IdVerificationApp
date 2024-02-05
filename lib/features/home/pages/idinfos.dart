import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../const.dart';
import '../../../core/widgets/adaptive_circular_progress_indicator.dart';
import '../../../core/widgets/custom_bottom_text_welcome_hint.dart';
import '../../../core/widgets/custom_main_button.dart';
import '../widgets/idinfos.dart/custom_back.dart';
import '../widgets/idinfos.dart/custom_front.dart';

class IdInfos extends StatefulWidget {
  const IdInfos({
    Key? key,
  }) : super(key: key);

  @override
  State<IdInfos> createState() => _IdInfosState();
}

class _IdInfosState extends State<IdInfos> {
  // ******************* Logic *******************
  bool? _is_loading = false;
  GlobalKey<FlipCardState> _cardKey = GlobalKey<FlipCardState>();

  // ******************* Interface *******************
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color1,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Center(
          child: _is_loading == true
              ? AdaptiveCircularProgressIndicator(color: color3)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(
                                height: 50.h,
                              ),
                              Container(
                                height: 400.h,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/fingerprint.png'),
                                      fit: BoxFit.fitHeight,
                                      alignment: Alignment.centerRight),
                                ),
                              )
                            ],
                          ),
                          Positioned(
                            top: 150.h,
                            child: FlipCard(
                                key: _cardKey,
                                flipOnTouch: true,
                                direction: FlipDirection.HORIZONTAL,
                                speed: 500,
                                front: CustomFront(),
                                back: CustomBack()),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 20.h),
                            child: CustomBottomTextWelcomeHint(),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 20.w),
                            child: CustomMainButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                              text: 'Retourner',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
