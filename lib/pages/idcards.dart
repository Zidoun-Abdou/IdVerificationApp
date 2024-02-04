import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whowiyati/widgets/custom_main_button.dart';
import 'package:whowiyati/widgets/custom_title_text.dart';
import '../const.dart';
import '../widgets/adaptive_circular_progress_indicator.dart';
import '../widgets/custom_image_logo.dart';
import 'recto.dart';

class IdCards extends StatefulWidget {
  const IdCards({Key? key}) : super(key: key);

  @override
  State<IdCards> createState() => _IdCardsState();
}

class _IdCardsState extends State<IdCards> {
  bool? _is_loading = false;

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
                    children: [
                      Expanded(
                        flex: 1,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            CustomImageLogo(width: 150),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: CustomTitleText(
                                  data:
                                      "Pour vérifier votre carte d’identité la caméra du téléphone va se lancer vous permettant de scanner le recto et le verso  de votre carte d’identité",
                                  color: Colors.white,
                                  size: 15),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Image.asset(
                              'assets/images/id_card.png',
                              // Replace with the actual path to your image file
                              fit: BoxFit.fill,
                            ).animate().fade(delay: 1000.ms),
                            Positioned(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 8.h),
                                child: CustomMainButton(
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Recto()));
                                  },
                                  text: 'Continuer',
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
