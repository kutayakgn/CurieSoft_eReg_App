import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_login_ui/screens/event_detail.dart';
import 'package:signature/signature.dart';

import '../../utilities/constants.dart';

class SignaturePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<SignaturePage> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.white,
    onDrawStart: () => print('onDrawStart called!'),
    onDrawEnd: () => print('onDrawEnd called!'),
  );

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => print('Value changed'));
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return EventDetailScreen();
          }),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      // title: Text("My title"),
      content: Text("Your signature successfully saved."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          "Signature Page",
        ),
        centerTitle: true,
        actions: [
          // Icon(Icons.more_vert)
        ],
        backgroundColor: koyumavi,
      ),
      body: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.topCenter,
              height: 100,
              child: const Center(
                child: Text(
                  'Please sign below!',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
            ),
          ),

          //SIGNATURE CANVAS
          Signature(
            controller: _controller,
            height: 300,
            backgroundColor: Colors.white,
          ),
          Spacer(),
          //OK AND CLEAR BUTTONS
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: const BoxDecoration(color: koyumavi),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //SHOW EXPORTED IMAGE IN NEW ROUTE

                  SizedBox.fromSize(
                    size: Size(70, 60),
                    child: Material(
                      color: koyumavi,
                      child: InkWell(
                        splashColor: Colors.white24,
                        onTap: () {
                          setState(() => _controller.clear());
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.clear,
                              color: Colors.white,
                            ), // <-- Icon
                            Text("Clear",
                                style: TextStyle(
                                  color: Colors.white,
                                )), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox.fromSize(
                    size: Size(70, 60),
                    child: Material(
                      color: koyumavi,
                      child: InkWell(
                        splashColor: Colors.white24,
                        onTap: () {
                          setState(() => _controller.undo());
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.undo,
                              color: Colors.white,
                            ), // <-- Icon
                            Text("Undo",
                                style: TextStyle(
                                  color: Colors.white,
                                )), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox.fromSize(
                    size: Size(70, 60),
                    child: Material(
                      color: koyumavi,
                      child: InkWell(
                        splashColor: Colors.white24,
                        onTap: () {
                          setState(() => _controller.redo());
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.redo,
                              color: Colors.white,
                            ), // <-- Icon
                            Text("Redo",
                                style: TextStyle(
                                  color: Colors.white,
                                )), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox.fromSize(
                    size: Size(70, 60),
                    child: Material(
                      color: koyumavi,
                      child: InkWell(
                        splashColor: Colors.white24,
                        onTap: () async {
                          if (_controller.isNotEmpty) {
                            final Uint8List? data =
                                await _controller.toPngBytes();
                            File.fromRawPath(data!);
                            final FirebaseStorage _firebaseStorage =
                                FirebaseStorage.instance;
                            Reference ref = _firebaseStorage
                                .ref()
                                .child('${DateTime.now()}.png');
                            UploadTask uploadTask = ref.putData(data,
                                SettableMetadata(contentType: 'image/png'));
                            TaskSnapshot taskSnapshot = await uploadTask
                                .whenComplete(() => print('done'))
                                .catchError(
                                    (error) => print("something went wrong"));
                            String url =
                                await taskSnapshot.ref.getDownloadURL();

                            showAlertDialog(context);
                            /*     if (data != null) {
                                await Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) {
                                      return Scaffold(
                                        appBar: AppBar(),
                                        body: Center(
                                          child: Container(
                                            color: Colors.grey[300],
                                            child: Image.memory(data),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } */
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.check,
                              color: Colors.white,
                            ), // <-- Icon
                            Text("Save",
                                style: TextStyle(
                                  color: Colors.white,
                                )), // <-- Text
                          ],
                        ),
                      ),
                    ),
                  ),

                  /*   IconButton(
                      icon: const Icon(Icons.check),
                      color: Colors.white,
                      onPressed: () async {
                        if (_controller.isNotEmpty) {
                          final Uint8List? data =
                          await _controller.toPngBytes();
                          if (data != null) {
                            await Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) {
                                  return Scaffold(
                                    appBar: AppBar(),
                                    body: Center(
                                      child: Container(
                                        color: Colors.grey[300],
                                        child: Image.memory(data),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.undo),
                      color: Colors.white,
                      onPressed: () {
                        setState(() => _controller.undo());
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.redo),
                      color: Colors.white,
                      onPressed: () {
                        setState(() => _controller.redo());
                      },
                    ),
                    //CLEAR CANVAS
                    IconButton(
                      icon: const Icon(Icons.clear),
                      color: Colors.white,
                      onPressed: () {
                        setState(() => _controller.clear());
                      },
                    ), */
                ],
              ),
            ),
            /* Container(
                height: 300,
                child: const Center(
                  child: Text('Big container to test scrolling issues'),
                ),
              ),*/
          ),
        ],
      ),
    );
  }
}
