import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/login_screen.dart';
import 'package:flutter_login_ui/screens/resetPW.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NavBar extends StatefulWidget {



  @override
  _NavBar createState() => _NavBar();
}

class _NavBar extends State<NavBar> {
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
    String emails = emmail.toString();
    Future logOut(BuildContext context) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove('email');
      pref.remove('isAdmin');
      FirebaseAuth.instance.signOut();
    }
    //Navigator.push(
    //  context,
    //  MaterialPageRoute(builder: (context) => LoginScreen()),
    //);
    final dbRef = FirebaseFirestore.instance
        .collection("Attendees")
        .doc(emmail);
    var dbRef2 = FirebaseFirestore.instance
        .collection("Attendees")
        .doc(emmail).get().toString();
    print(dbRef2);
    CollectionReference allCollection =
    FirebaseFirestore.instance.collection('Attendees');
    Future<String> getSpecie(String petId) async {
      DocumentReference documentReference = allCollection.doc(emmail);
      String specie = "";
      await documentReference.get().then((snapshot) {

        //specie = snapshot.data.toString();
      });
      return specie;
    }

    final docRef = FirebaseFirestore.instance.collection("Attendees").doc(emmail);
    docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        Iterable dataa = data.values;
        // ...
      },
      onError: (e) => print("Error getting document: $e"),
    );

    print(getSpecie("any"));
    String any = getSpecie("any").toString();
    List<DocumentSnapshot> documents = [];
    DocumentReference allDoc = FirebaseFirestore.instance.collection('Attendees').doc(emmail);
   // Future<DocumentSnapshot<Object?>> FullName = allDoc.get("Full Name");
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Sueda Bilen"),
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


