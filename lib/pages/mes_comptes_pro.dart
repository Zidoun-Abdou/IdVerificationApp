import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../const.dart';

class MesComptesPro extends StatefulWidget {
  const MesComptesPro({super.key});

  @override
  State<MesComptesPro> createState() => _MesComptesProState();
}

class _MesComptesProState extends State<MesComptesPro> {
  bool _isSelect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color1,
      appBar: AppBar(
        backgroundColor: color1,
        centerTitle: true,
        elevation: 0,
        title: Text("Mes Comptes Pro"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Text(
              "Naviguer vers les comptes professionnels\nou Ajouter un compte professionnel",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                height: 1.1.h,
                letterSpacing: 0.20.w,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              decoration: BoxDecoration(
                color: color7,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SvgPicture.asset(
                        "assets/images/menu.svg",
                        height: 22.h,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(
                        "Profile 1",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          height: 1.1.h,
                          letterSpacing: 0.20.w,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isSelect = !_isSelect;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: _isSelect ? Colors.blue : Colors.grey,
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 40.h),
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                "assets/images/Plus_circle.png",
                height: 50.h,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
