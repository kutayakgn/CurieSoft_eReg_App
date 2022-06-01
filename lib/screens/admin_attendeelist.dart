import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/admin_event_detail.dart';
import 'package:flutter_login_ui/screens/newhome.dart';

import 'package:flutter_login_ui/utilities/constants.dart';

class AttendeeList extends StatelessWidget {
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
              _AttendeeListPage(),
            ],
          ),
        ));
  }
}

class _AttendeeListPage extends StatefulWidget {
  @override
  _AttendeeListPageState createState() => _AttendeeListPageState();
}

class _AttendeeListPageState extends State<_AttendeeListPage> {
  CollectionReference? allcoll;
  List<DocumentSnapshot> documents = [];
  _AttendeeListPageState() {
    CollectionReference allCollection =
        FirebaseFirestore.instance.collection('Events');
    allcoll = allCollection.doc('1').collection('AllAttendees');
  }

  void initState() {
    super.initState();
  }

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
              hintText: 'Search Attendee',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: allcoll!.snapshots(),
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
                        .get('Full Name')
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
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20.0, 10, 20, 0),
                          padding: const EdgeInsets.all(10.0),
                          alignment: Alignment.center,
                          decoration: myBoxDecoration(),
                          width: MediaQuery.of(context).size.width / 0.7,
                          height: MediaQuery.of(context).size.height / 10,
                          child: Text(documents[index]['Full Name'],
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
