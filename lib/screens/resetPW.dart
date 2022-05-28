

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/attendeeNavBar.dart';
import 'package:flutter_login_ui/utilities/constants.dart';

class resetPW extends StatefulWidget {
  @override
  resetPassword createState() => resetPassword();
}

class resetPassword extends State<resetPW> {

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
          _bodyResetPW(),
        ],
      ),
    );
  }
}

class _bodyResetPW extends StatefulWidget {
  @override

  _bbodyresetPW createState() => _bbodyresetPW();
}

class _bbodyresetPW extends State<_bodyResetPW> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;


  Widget build(BuildContext context) {
    User? useremail = _firebaseAuth.currentUser;
    String? emmail = useremail?.email;
    TextEditingController Password1 = new TextEditingController();
    TextEditingController Password2 = new TextEditingController();


    return Container(
        padding: const EdgeInsets.all(20.0),
        child: Column (

          children: [
          TextButton(
              onPressed: ()=>{resetPW(emmail!)},
            child: const Text("Send Reset Password Email")
        ),
          TextField(

            controller: Password1,
            decoration: const InputDecoration(border: OutlineInputBorder(),hoverColor: koyumavi,hintText: "Enter New Password"),
          ),
            SizedBox(height: 10),

            TextField( controller: Password2,
              decoration: const InputDecoration(border: OutlineInputBorder(),hoverColor: koyumavi,hintText: "Repeat New Password"),

            ),
            SizedBox(height: 10),
            TextButton(
                onPressed: ()=>{savePW(emmail!)},
                child: const Text("Save PW")
            ),


   ],
     ),

      );

  }
  @override
  Future<void> resetPW(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  savePW(String s) {}
}