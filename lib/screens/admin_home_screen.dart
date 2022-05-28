import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/admin_event_detail.dart';
import 'package:flutter_login_ui/screens/QRcodePage/QR_scanning.dart';
import 'package:flutter_login_ui/screens/event_detail.dart';
import 'package:flutter_login_ui/screens/login_screen.dart';
import 'package:flutter_login_ui/screens/newhome.dart';
import 'package:flutter_login_ui/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/CustomShapeClipper.dart';
import 'QRcodePage/QR_main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminHome extends StatefulWidget {
  @override
  AdminHomeScreen createState() => AdminHomeScreen();
}

class AdminHomeScreen extends State<AdminHome> {
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
        title: Text(
          "Admin Panel",
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
          ),
        ),
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
          _AdminListPage(),
        ],
      ),
    );
  }
}

class _AdminListPage extends StatefulWidget {
  @override
  _AdminListPageState createState() => _AdminListPageState();
}

class _AdminListPageState extends State<_AdminListPage> {
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
                                builder: (context) => AdminEventDetailScreen()),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                          padding: const EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          decoration: myBoxDecoration(),
                          width: MediaQuery.of(context).size.width / 0.7,
                          height: MediaQuery.of(context).size.height / 12,
                          child: Row(
                            children: [
                              Text(documents[index]['Program Topic'],
                                  style: TextStyle(
                                      color: Color.fromARGB(179, 0, 30, 70),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 19.0))
                            ],
                          ),
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
