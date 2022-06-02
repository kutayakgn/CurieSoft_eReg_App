import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/newhome.dart';
import 'package:flutter_login_ui/screens/signaturePage/signature.dart';
import 'package:flutter_login_ui/utilities/CustomShapeClipper.dart';
import 'package:signature/signature.dart';
import '../newqrscan.dart';
import '../utilities/constants.dart';
import 'QRcodePage/QR_scanning.dart';

class EventDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: koyumavi,
          elevation: 0.0,
          centerTitle: true,
          leading: InkWell(
            child: Icon(Icons.arrow_back),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EventList()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              EventDetailTopPart(),
              DetailPage(),
              SignButton(),
            ],
          ),
        ));
  }
}

class SignButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: koyumavi,
      child: Ink(
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: ImageIcon(
            AssetImage("images/Signature.png"),
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return QRScanPage();
              }),
            );
          },
        ),
      ),
    );
  }
}

class EventDetailTopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        ClipPath(
          clipper: CustomShapeClipper(),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [koyumavi, koyumavi])),
            height: 120.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15.0),
            Text(
              EventListScreen.chosenevent,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Fred',
              ),
            ),
            SizedBox(height: 50.0),
          ],
        )
      ],
    );
  }
}

class DetailPage extends StatefulWidget {
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Events')
              .where('Program Topic', isEqualTo: EventListScreen.chosenevent)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              return Container(
                  alignment: Alignment.center,
                  height: 450,
                  child: ListView(
                    children: snapshot.data!.docs.map((document) {
                      return Center(
                        child: Container(
                            margin: const EdgeInsets.all(20.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: eventBoxDecoration(),
                            width: MediaQuery.of(context).size.width / 0.7,
                            height: MediaQuery.of(context).size.height / 2,
                            child: Column(children: <Widget>[
                              Container(
                                margin:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: Text(
                                    "Program Coordinator: " +
                                        document['Program Coordinator'],
                                    style: TextStyle(
                                        color: Color.fromARGB(179, 0, 30, 70),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19.0)),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: Text(
                                    "Program Host: " + document['Program Host'],
                                    style: TextStyle(
                                        color: Color.fromARGB(179, 0, 30, 70),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19.0)),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: Text(
                                    "Speakers: " +
                                        document['Speakers'].toString(),
                                    style: TextStyle(
                                        color: Color.fromARGB(179, 0, 30, 70),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19.0)),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: Text(
                                    "Place: " +
                                        document['Address Name'].toString() +
                                        "\n\n" +
                                        document['Address1'].toString() +
                                        "\n" +
                                        document['Address2'].toString() +
                                        "\n" +
                                        document['Address State'].toString() +
                                        "\n" +
                                        document['Address City'].toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 10, 0, 54),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 19.0)),
                              )
                            ])),
                      );
                    }).toList(),
                  ));
            }
          }),
    );
  }
}

BoxDecoration eventBoxDecoration() {
  return BoxDecoration(
    color: Color.fromARGB(255, 177, 200, 221),
    border: Border.all(
      width: 3.0,
      color: Color.fromARGB(255, 177, 200, 221),
    ),
    borderRadius: BorderRadius.all(
        Radius.circular(10.0) //                 <--- border radius here
        ),
  );
}
