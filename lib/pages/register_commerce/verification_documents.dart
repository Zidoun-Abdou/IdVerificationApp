import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../const.dart';

class VerificationDocuments extends StatefulWidget {
  final ValueNotifier<int> currentEtapeValueNotifier;
  final ValueNotifier<bool> etape3ValueNotifier;
  final ValueNotifier<bool> etape4ValueNotifier;
  const VerificationDocuments(
      {super.key,
      required this.currentEtapeValueNotifier,
      required this.etape3ValueNotifier,
      required this.etape4ValueNotifier});

  @override
  State<VerificationDocuments> createState() => _VerificationDocumentsState();
}

class _VerificationDocumentsState extends State<VerificationDocuments> {
  bool _isPortfaille = true;
  bool _isChoice = false;
  String _ajouter = "";
  String _verifier = "";
  String _etape = "";

  @override
  void initState() {
    widget.currentEtapeValueNotifier.addListener(() {
      setState(() {});
    });
    widget.etape3ValueNotifier.addListener(() {
      setState(() {});
    });
    widget.etape4ValueNotifier.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/images/registre_commerce.png",
          height: 90.h,
          width: 90.w,
          fit: BoxFit.contain,
        ),
        SizedBox(height: 20.h),
        Visibility(
          visible: _isPortfaille,
          child: Column(
            children: [
              Text(
                "Votre portefeuille ne contient pas encore de\ndocument",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.1.h,
                  letterSpacing: 0.20.w,
                ),
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: () {
                  if (widget.etape3ValueNotifier.value == false) {
                    setState(() {
                      _isPortfaille = false;
                      _isChoice = true;
                      _ajouter = "rc";
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.etape3ValueNotifier.value == false
                      ? color3
                      : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  foregroundColor: Colors.white,
                  minimumSize: Size.fromHeight(30.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  elevation: widget.etape3ValueNotifier.value == false ? 20 : 0,
                  shadowColor: widget.etape3ValueNotifier.value == false
                      ? color3
                      : Colors.grey,
                ),
                child: Text(
                  'Ajouter un registre de commerce',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              ElevatedButton(
                onPressed: () {
                  if (widget.etape4ValueNotifier.value == false) {
                    setState(() {
                      _isPortfaille = false;
                      _isChoice = true;
                      _ajouter = "nif";
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.etape4ValueNotifier.value == false
                      ? color3
                      : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  foregroundColor: Colors.white,
                  minimumSize: Size.fromHeight(30.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  elevation: widget.etape4ValueNotifier.value == false ? 20 : 0,
                  shadowColor: widget.etape4ValueNotifier.value == false
                      ? color3
                      : Colors.grey,
                ),
                child: Text(
                  'Ajouter une carte fiscale',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Ajouter Document ou Images
        Visibility(
          visible: _isChoice,
          child: Column(
            children: [
              Text(
                "Téleverser votre document au format PDF",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.1.h,
                  letterSpacing: 0.20.w,
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  // Telecharger Doc and Verifié with IA
                  // verifieDoc();
                  setState(() {
                    _isChoice = false;
                    _verifier = "doc";
                  });
                },
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Image.asset(
                    "assets/images/upload_file.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "OU",
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
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.all(10.w),
                child: ElevatedButton(
                  onPressed: () {
                    if (_ajouter == "rc") {
                      setState(() {
                        _isChoice = false;
                        _verifier = "recto_rc";
                      });
                    } else if (_ajouter == "nif") {
                      setState(() {
                        _isChoice = false;
                        _verifier = "nif";
                      });
                    }
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
                    shadowColor: color3,
                  ),
                  child: Text(
                    'Prendre une photo de votre document',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Verifié Recto Registre Commerce Image
        Visibility(
          visible: _verifier == "recto_rc",
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              children: [
                Positioned(
                  top: 30.h,
                  right: 0,
                  left: 0,
                  child: Text(
                    "Mettez votre Front Registre de commerce en\nposition horizontale et votre téléphone en\nposition verticale pour prendre une photo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      height: 1.1.h,
                      letterSpacing: 0.20.w,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50.h,
                  right: 0,
                  left: 0,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    child: ElevatedButton(
                      onPressed: () async {
                        // takeRecto();
                        setState(() {
                          _verifier = "vecto_rc";
                        });
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
                  ),
                )
              ],
            ),
          ),
        ),
        // Verifié Verso Registre Commerce Image
        Visibility(
          visible: _verifier == "vecto_rc",
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              children: [
                Positioned(
                  top: 30.h,
                  right: 0,
                  left: 0,
                  child: Text(
                    "Mettez votre Verso Registre de commerce en\nposition horizontale et votre téléphone en\nposition verticale pour prendre une photo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      height: 1.1.h,
                      letterSpacing: 0.20.w,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50.h,
                  right: 0,
                  left: 0,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    child: ElevatedButton(
                      onPressed: () async {
                        // takeVecto();
                        setState(() {
                          _verifier = "";
                          _etape = "rc";
                        });
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
                  ),
                )
              ],
            ),
          ),
        ),
        // Verifié Cart Fiscal Image
        Visibility(
          visible: _verifier == "nif",
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              children: [
                Positioned(
                  top: 30.h,
                  right: 0,
                  left: 0,
                  child: Text(
                    "Mettez votre Cart Fiscal en position horizontale\net votre téléphone en position verticale pour\nprendre une photo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      height: 1.1.h,
                      letterSpacing: 0.20.w,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50.h,
                  right: 0,
                  left: 0,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    child: ElevatedButton(
                      onPressed: () async {
                        // takeNif();
                        setState(() {
                          _verifier = "";
                          _etape = "nif";
                        });
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
                  ),
                )
              ],
            ),
          ),
        ),
        // Verifié Documents
        Visibility(
          visible: _verifier == "doc",
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Stack(
              children: [
                Positioned(
                  top: 30.h,
                  right: 0,
                  left: 0,
                  child: Text(
                    "Votre fichier a été téléchargé avec succès",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontFamily: 'Inter',
                      height: 1.1.h,
                      letterSpacing: 0.20.w,
                    ),
                  ),
                ),
                Positioned(
                  top: 80.h,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsets.all(10.w),
                    child: Image.asset(
                      "assets/images/pdf_telecharher.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50.h,
                  right: 0,
                  left: 0,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                    child: ElevatedButton(
                      onPressed: () async {
                        // uploadDoc();
                        setState(() {
                          _verifier = "";
                          if (_ajouter == "rc") {
                            _etape = "rc";
                          } else if (_ajouter == "nif") {
                            _etape = "nif";
                          }
                        });
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
                  ),
                )
              ],
            ),
          ),
        ),
        // Registre Commerce Etape
        Visibility(
          visible: _etape == "rc",
          child: Column(
            children: [
              Text(
                "Renseignez les informations mentionnées sur votre\nregistre de commerce",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.1.h,
                  letterSpacing: 0.20.w,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  // controller: _emailContr,
                  cursorColor: color3,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                    hintText: "N° Registre de commerce",
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: BorderSide(
                        color: color3,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(50.r), // Set border radius
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "N° Registre de commerce non valide";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  // controller: _emailContr,
                  cursorColor: color3,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                    hintText: "Raison social",
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: BorderSide(
                        color: color3,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(50.r), // Set border radius
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Raison social non valide";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  // controller: _emailContr,
                  cursorColor: color3,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                    hintText: "Adresse",
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: BorderSide(
                        color: color3,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(50.r), // Set border radius
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Adresse non valide";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  // controller: _emailContr,
                  cursorColor: color3,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                    hintText: "Activité",
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: BorderSide(
                        color: color3,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(50.r), // Set border radius
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Activité non valide";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: ElevatedButton(
                  onPressed: () {
                    widget.etape3ValueNotifier.value = true;
                    setState(() {
                      _etape = '';
                      _ajouter = "";
                      _isPortfaille = true;
                    });
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
                    shadowColor: color3,
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
              ),
            ],
          ),
        ),
        // Cart Fiscal Etape
        Visibility(
          visible: _etape == "nif",
          child: Column(
            children: [
              Text(
                "Renseignez les informations mentionnées sur votre\nregistre de commerce",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 1.1.h,
                  letterSpacing: 0.20.w,
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  // controller: _emailContr,
                  cursorColor: color3,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                    hintText: "N° Carte fiscal",
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: BorderSide(
                        color: color3,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(50.r), // Set border radius
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "N° Carte fiscal non valide";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  // controller: _emailContr,
                  cursorColor: color3,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                    hintText: "Raison social",
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: BorderSide(
                        color: color3,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(50.r), // Set border radius
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Raison social non valide";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                child: TextFormField(
                  autofocus: false,
                  textInputAction: TextInputAction.next,
                  // controller: _emailContr,
                  cursorColor: color3,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Color(0xFF6D6D6D)),
                    hintText: "Sigle",
                    prefixIcon: Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.r),
                      borderSide: BorderSide(
                        color: color3,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(50.r), // Set border radius
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(50.r),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Sigle non valide";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.all(20.w),
                child: ElevatedButton(
                  onPressed: () {
                    widget.etape4ValueNotifier.value = true;
                    setState(() {
                      _etape = '';
                      _ajouter = "";
                      _isPortfaille = true;
                    });
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
                    shadowColor: color3,
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}
