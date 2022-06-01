import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/admin_attendeelist.dart';
import 'package:flutter_login_ui/screens/event_detail.dart';

import '../../utilities/constants.dart';

class AdminEventDetailScreen extends StatelessWidget {
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
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              EventDetailTopPart(),
              DetailPage(),
              AttendeeListButton(),
            ],
          ),
        ));
  }
}

class AttendeeListButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: koyumavi),
        child: TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AttendeeList()),
            );
          },
          icon: Icon(
            Icons.person,
            size: 25,
            color: Colors.white,
          ),
          label: Text(
            "Attendees",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'Fred'),
          ),
        ),
      ),
      SizedBox(width: 20),
      Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: koyumavi),
        child: TextButton.icon(
          onPressed: () {
            // Respond to button press
          },
          icon: Icon(
            Icons.qr_code,
            size: 25,
            color: Colors.white,
          ),
          label: Text(
            "Event QR",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'Fred'),
          ),
        ),
      )
    ]);
  }
}
