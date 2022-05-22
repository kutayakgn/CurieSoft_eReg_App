import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/QRcodePage/QR_scanning.dart';
import 'package:flutter_login_ui/screens/event_detail.dart';
import 'package:flutter_login_ui/utilities/constants.dart';
import '../utilities/CustomShapeClipper.dart';
import 'QRcodePage/QR_main.dart';

class EventListScreen extends StatelessWidget {
  static var chosenevent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: koyumavi,
          elevation: 0.0,
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: ImageIcon(
                AssetImage("images/QRIcon.png"),
                 ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ScanPage();
                }),
                );
              },
            )
          ],
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
              EventListTopPart(),
              SizedBox(
                height: 40,
              ),
              _ListPage(),

            ],
          ),
        ));
  }
}


class EventListTopPart extends StatelessWidget {
  final _searchevent = TextEditingController();
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
            height: 161.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15.0),
            Text(
              "CurieSoft Events",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Fred',
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              alignment: Alignment.center,
              decoration: kBoxDecorationStyle,
              height: 60.0,
              width: 350,
              child: TextField(
                controller: _searchevent,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'OpenSans',
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 12.0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: 'Search Event',
                  hintStyle: kHintTextStyle,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<_ListPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Events').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading..."),
              );
            } else {
              return Container(
                  alignment: Alignment.center,
                  height: 600,
                  child: ListView(
                    children: snapshot.data!.docs.map((document) {
                      return Center(
                          child: GestureDetector(
                        onTap: () {
                          EventListScreen.chosenevent =
                              document['Program Topic'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EventDetailScreen()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                          padding: const EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          decoration: myBoxDecoration(),
                          width: MediaQuery.of(context).size.width / 0.7,
                          height: MediaQuery.of(context).size.height / 10,
                          child: Text(document['Program Topic'],
                              style: TextStyle(
                                  color: Color.fromARGB(179, 0, 30, 70),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19.0)),
                        ),
                      ));
                    }).toList(),
                  ));
            }
          }),

    );
  }
}

BoxDecoration myBoxDecoration() {
  return BoxDecoration(
    color: Color.fromARGB(255, 197, 223, 245),
    border: Border.all(
      width: 3.0,
      color: Color.fromARGB(255, 197, 223, 245),
    ),
    borderRadius: BorderRadius.all(
        Radius.circular(10.0) //                 <--- border radius here
        ),
  );
}
