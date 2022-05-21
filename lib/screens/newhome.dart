import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/utilities/constants.dart';

import '../utilities/CustomShapeClipper.dart';

class EventListScreen extends StatelessWidget {
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          EventListTopPart(),
          FlightCard(),
          FlightCard(),
          FlightCard(),
          FlightCard(),
        ],
      ),
    );
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

class FlightCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              border: Border.all(color: Colors.black),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'Event Name: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        "Event 1",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: -8.0,
                    children: <Widget>[
                      Text(
                        "Speaker",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey),
                      ),
                      Text(
                        "Date",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 10.0,
            right: 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(
                'Time',
                style: TextStyle(
                    color: acikmavi,
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold),
              ),
              decoration: BoxDecoration(
                color: acikmavi,
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
