import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whowiyati/const.dart';
import 'package:whowiyati/pages/verso.dart';

import '../widgets/adaptive_circular_progress_indicator.dart';

class Recto extends StatefulWidget {
  const Recto({super.key});

  @override
  State<Recto> createState() => _RectoState();
}

class _RectoState extends State<Recto> with TickerProviderStateMixin {
  // ******************* Logic *******************
  late AnimationController _controller;
  late Animation<double> _animation;

  static const Duration durationToReverse = Duration(seconds: 3);
  static const Duration durationToForward = Duration(seconds: 1);
  static const Duration durationToChangeWidget = Duration(milliseconds: 50);

  takeRecto() async {
    final picker = ImagePicker();
    final recto = await picker.pickImage(
        source: ImageSource.camera,
        maxHeight: 1080,
        maxWidth: 1920,
        imageQuality: 50);

    if (recto != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Verso(
            rectoPhoto: recto,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    // Create an AnimationController with a duration of 3 seconds
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // Create a Tween that goes from 0.0 to 1.0
    final tween = Tween<double>(begin: 0.0, end: 1.0);

    // Apply the tween to the controller
    _animation = tween.animate(_controller);

    // Add a delay of 2 seconds before starting the animation in reverse

    // Listen for animation status changes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // When the animation completes, reverse it
        Future.delayed(durationToReverse, () {
          _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(durationToForward, () {
          _controller.forward();
        });
        // When the animation is dismissed (reversed), start it again
      }
    });
    Future.delayed(durationToForward, () {
      _controller.forward();
    });
    // Start the animation
  }

  @override
  void dispose() {
    // Dispose of the animation controller when not needed
    _controller.dispose();
    super.dispose();
  }

  bool? _is_loading = false;

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
              : Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            Center(
                              child: Image.asset(
                                'assets/images/logo.png',
                                // Replace with the actual path to your image file
                                fit: BoxFit.contain,
                                width: 150.w,
                              ),
                            ),
                            AnimatedBuilder(
                              animation: _animation,
                              builder: (context, child) {
                                return Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 30.w),
                                    height: 280.h,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        if (_animation.value > 0.5)
                                          FadeTransition(
                                              opacity: _animation,
                                              child: Image.asset(
                                                "assets/images/G_PIC_icons.png",
                                                fit: BoxFit.fill,
                                              )),
                                        Transform.rotate(
                                            angle: (_animation.value - 1) *
                                                (0.5) *
                                                -pi,
                                            child: AnimatedCrossFade(
                                              duration: durationToChangeWidget,
                                              firstChild: Image.asset(
                                                "assets/images/Group 100 (2).png",
                                              ),
                                              secondChild: RotatedBox(
                                                  quarterTurns: 3,
                                                  child: Image.asset(
                                                    "assets/images/Group 100.png",
                                                  )),
                                              crossFadeState: _animation.value >
                                                      0.5
                                                  ? CrossFadeState.showFirst
                                                  : CrossFadeState.showSecond,
                                            ))
                                        //
                                      ],
                                    ));
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 10.h),
                              child: Text(
                                "Mettez votre carte en position horizontale et votre téléphone en position verticale pour prendre une photo",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontFamily: 'Inter',
                                  height: 1.1.h,
                                  letterSpacing: 0.20.w,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 10.h),
                              child: ElevatedButton(
                                onPressed: () async {
                                  takeRecto();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: color3,
                                  padding: EdgeInsets.symmetric(vertical: 15.h),
                                  foregroundColor: Colors.white,
                                  minimumSize: Size.fromHeight(30.w),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  elevation: 20,
                                  shadowColor: color3, // Set the shadow color
                                ),
                                child: Text(
                                  'Continuer',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
