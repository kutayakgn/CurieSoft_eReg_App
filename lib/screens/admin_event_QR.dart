import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/event_detail.dart';
import 'package:flutter_login_ui/screens/newhome.dart';
import 'package:flutter_login_ui/utilities/constants.dart';

class AdminEventQR extends StatelessWidget {
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  Future<QuerySnapshot> getImages() {
    return fb
        .collection("Events")
        .where('Program Topic', isEqualTo: EventListScreen.chosenevent)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          backgroundColor: koyumavi,
          elevation: 0.0,
          centerTitle: true,
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Container(
                height: 500,
                color: acikmavi,
                padding: EdgeInsets.all(10.0),
                child: FutureBuilder(
                  future: getImages(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemExtent: 500,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(
                              snapshot.data!.docs[index]["QR code image"],
                              width: 200,
                              height: 200,
                            );
                          });
                    } else if (snapshot.connectionState ==
                        ConnectionState.none) {
                      return Text("No data");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
