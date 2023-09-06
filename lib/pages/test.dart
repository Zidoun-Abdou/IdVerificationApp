import 'dart:math';

import 'package:flutter/material.dart';

class Testing2 extends StatefulWidget {
  const Testing2({super.key});

  @override
  State<Testing2> createState() => _Testing2State();
}

class _Testing2State extends State<Testing2> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  static const Duration durationToReverse = Duration(seconds: 3);
  static const Duration durationToForward = Duration(seconds: 1);
  static const Duration durationToChangeWidget = Duration(milliseconds: 50);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    height: 500,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_animation.value > 0.5)
                          FadeTransition(
                              opacity: _animation,
                              child:
                                  Image.asset("assets/images/G_PIC_icons.png")),
                        Transform.rotate(
                            angle: (_animation.value - 1) * (0.5) * -pi,
                            child: AnimatedCrossFade(
                              duration: durationToChangeWidget,
                              firstChild: Image.asset(
                                "assets/images/Group 100 (2).png",
                                fit: BoxFit.cover,
                              ),
                              secondChild: RotatedBox(
                                  quarterTurns: 3,
                                  child: Image.asset(
                                      "assets/images/Group 100.png")),
                              crossFadeState: _animation.value > 0.5
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                            ))
                        //
                      ],
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
