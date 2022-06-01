import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/QRcodePage/QR_scanning.dart';
import 'package:flutter_login_ui/screens/attendeeNavBar.dart';
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
  static var chosenevent;
  static var choseneventid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: koyumavi,
        elevation: 0.0,
        centerTitle: true,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () => Scaffold.of(context).openDrawer()),
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
              "CMGO Events",
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

String _email = '';

class _ListPageState extends State<_ListPage> {
  getcurrentuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = (prefs.getString('currentemail'))!;
    });
  }

  void initState() {
    super.initState();
    getcurrentuser();
    print("this is executing");
    print(_email);
  }

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
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            width: 350,
            child: Row(
              children: [
                Container(
                  width: 290,
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
                IconButton(
                  iconSize: 40,
                  icon: ImageIcon(
                    AssetImage("images/QRIcon.png"),
                    color: Colors.white,
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
            )),
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
                documents = documents.where((element) {
                  return element
                      .get('Katilimci')
                      .toString()
                      .toLowerCase()
                      .contains(_email);
                }).toList();
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
                          EventListScreen.choseneventid = documents[index].id;
                          print(EventListScreen.choseneventid);
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
