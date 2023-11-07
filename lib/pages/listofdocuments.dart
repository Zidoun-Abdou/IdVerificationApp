import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../const.dart';

class ListOfDocuments extends StatefulWidget {
  const ListOfDocuments({super.key});

  @override
  State<ListOfDocuments> createState() => _ListOfDocumentsState();
}

class _ListOfDocumentsState extends State<ListOfDocuments> {
  Future<void> _launchUrl(mylink) async {
    if (!await launchUrl(mylink, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $mylink';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mes Documents"),
          centerTitle: true,
          backgroundColor: Colors.blueGrey[900],
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Non Signé",
              ),
              Tab(
                text: "Signé déja",
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              ListView(
                children: [
                  Card(
                    child: ListTile(
                      title: Text("Contrat de Travail"),
                      trailing: Wrap(
                        spacing: 12, // space between two icons
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Uri _url = Uri.parse(
                                  "https://docuseal.s3.amazonaws.com/2w68an7s4mrnqd67tqavmsz8kp8e");
                              _launchUrl(_url);
                            },
                            icon: Icon(
                              Icons.download,
                              color: color3,
                              size: 25.sp,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.check,
                              color: color3,
                              size: 25.sp,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.block_rounded,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Text("tab2"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
