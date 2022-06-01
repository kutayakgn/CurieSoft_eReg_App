import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_ui/screens/login_screen.dart';
import 'package:flutter_login_ui/screens/admin_home_screen.dart';
import 'package:flutter_login_ui/screens/newhome.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');
  var isAdmin = preferences.getString('isAdmin');
  print(preferences.getString('currentemail'));
  runApp(MaterialApp(
    title: 'CurieSoft e-Reg App',
    debugShowCheckedModeBanner: false,
    home: email == null
        ? LoginScreen()
        : isAdmin.toString() == "false"
            ? EventList()
            : AdminHome(),
  ));
}
