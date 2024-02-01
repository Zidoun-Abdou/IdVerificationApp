import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:whowiyati/const.dart';

class SeeDocument extends StatefulWidget {
  final String myurl;
  final bool is_signed;
  const SeeDocument({super.key, required this.myurl, this.is_signed = true});

  @override
  State<SeeDocument> createState() => _SeeDocumentState();
}

class _SeeDocumentState extends State<SeeDocument> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color2,
        title: const Text('Voir le contrat à signé'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.bookmark,
        //       color: Colors.white,
        //       semanticLabel: 'Bookmark',
        //     ),
        //     onPressed: () {
        //       _pdfViewerKey.currentState?.openBookmarkView();
        //     },
        //   ),
        // ],
      ),
      backgroundColor: Colors.amber,
      body: SafeArea(
        child: SfPdfViewer.network(
          widget.myurl,
          key: _pdfViewerKey,
        ),
      ),
      floatingActionButton: Visibility(
        visible: widget.is_signed,
        child: FloatingActionButton.extended(
          onPressed: () {
            /*
            showModalBottomSheet(
                backgroundColor: color2,
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w, vertical: 20.h),
                        child: Text(
                          "Êtes-vous sûr de vouloir signer ce document?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => DialpadScreen(
                              //       status: 4,
                              //       onPressedAction: () async {
                              //         // signFile(
                              //         //   "${snapshot.data["documents_pending"][i]["id"]}",
                              //         // );
                              //         Navigator.of(context).pop();
                              //       },
                              //     ),
                              //   ),
                              // );
                            },
                            child: Text("Oui"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: color3,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.h, horizontal: 30.w),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                elevation: 10,
                                shadowColor: color3),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Non"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15.h, horizontal: 30.w),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                elevation: 10,
                                shadowColor: Colors.red),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  );
                });*/
            Navigator.of(context).pop();
          },
          label: const Text('Signer ce documents'),
          icon: const Icon(Icons.check_circle_outline_sharp),
          backgroundColor: color3,
        ),
      ),
    );
  }
}
