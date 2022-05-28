import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/QRcodePage/QR_scanning.dart';
import 'package:flutter_login_ui/screens/event_detail.dart';
import 'package:flutter_login_ui/screens/login_screen.dart';
import 'package:flutter_login_ui/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/CustomShapeClipper.dart';
import 'QRcodePage/QR_main.dart';

class EventList extends StatefulWidget {
  @override
  EventListScreen createState() => EventListScreen();
}

class EventListScreen extends State<EventList> {
  Future logOut(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('email');
    pref.remove('isAdmin');
    FirebaseAuth.instance.signOut();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  static var chosenevent;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ScanPage();
                }),
              );
            },
          )
        ],
        leading: InkWell(
          child: Icon(Icons.logout),
          onTap: () {
            logOut(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          EventListTop(),
          _ListPage(),
        ],
      ),
    );
  }
}

class EventListTop extends StatefulWidget {
  @override
  EventListTopPart createState() => EventListTopPart();
}

class EventListTopPart extends State<EventListTop> {
  static String searchtext = "";
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
            height: 100.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "CurieSoft Events",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Fred',
              ),
            ),
            SizedBox(
              height: 50,
            )
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
  CollectionReference allCollection =
      FirebaseFirestore.instance.collection('Events');
  List<DocumentSnapshot> documents = [];

  TextEditingController _searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          width: 350,
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
                print(value);
              });
            },
            controller: _searchController,
            keyboardType: TextInputType.text,
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
        SingleChildScrollView(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: allCollection.snapshots(),
              builder: (ctx, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue,
                  ));
                }
                documents = streamSnapshot.data!.docs;
                //todo Documents list added to filterTitle
                if (searchText.length > 0) {
                  documents = documents.where((element) {
                    return element
                        .get('Program Topic')
                        .toString()
                        .toLowerCase()
                        .contains(searchText.toLowerCase());
                  }).toList();
                }
                return Container(
                  alignment: Alignment.center,
                  height: 440,
                  margin: EdgeInsets.all(20),
                  child: ListView.separated(
                    itemCount: documents.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          EventListScreen.chosenevent =
                              documents[index]['Program Topic'];
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
                          height: MediaQuery.of(context).size.height / 12,
                          child: Text(documents[index]['Program Topic'],
                              style: TextStyle(
                                  color: Color.fromARGB(179, 0, 30, 70),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19.0)),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        )
      ],
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
