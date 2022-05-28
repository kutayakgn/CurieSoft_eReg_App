import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/login_screen.dart';
import 'package:flutter_login_ui/screens/resetPW.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NavBar extends StatefulWidget {



  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {

  final String _collection = 'collectionName';


  var currentemail;

  Future getInfo(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    currentemail = preferences.getString('email');

  }


  //var email = "asd";

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    User? useremail = auth.currentUser;
    String? emmail = useremail?.email;
    String fullname = "";

    Future logOut(BuildContext context) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove('email');
      pref.remove('isAdmin');
      FirebaseAuth.instance.signOut();
    }

    FirebaseFirestore.instance
        .collection('Attendees')
        .doc('$emmail')
        .get()
        .then((DocumentSnapshot doc) {
      print(doc.get('Full Name')) ;
      String fullname1 = '' + doc.get('Full Name');
      print(fullname1);
      fullname = fullname1.toString();
      print(fullname);
    });


    return Drawer(

      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(fullname),
            accountEmail: Text(emmail!),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage('images/forest.jpg')),
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => null,
          ),
          ListTile(
            leading: Icon(Icons.password),
            title: Text('Reset Password'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return resetPW();
              }),
            ),
          ),
          Divider(),
          ListTile(
            title: Text('Exit'),
            leading: Icon(Icons.exit_to_app),
            onTap: () {
              logOut(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
           );
            },
          ),
        ],
      ),
    );



    // TODO: implement build
    throw UnimplementedError();
  }

}



  //State<StatefulWidget> createState() {

  //  final FirebaseAuth auth = FirebaseAuth.instance;

//  throw UnimplementedError();
//}
//}
//class NavBar extends StatefulWidget {
//
//
//
//
//    Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => LoginScreen()),
//    );
//  }
//
//
//  @override
//  Widget build(BuildContext context) {
//    final User user = auth.currentUser;
//    final uid = user.uid;

//  }
//
//  @override
//


