import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_login_ui/screens/newhome.dart';
import 'package:flutter_login_ui/screens/signaturePage/signature.dart';
import 'package:flutter_login_ui/utilities/constants.dart';

import '../main.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = 'Unknown';
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    scanQRCode();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(backgroundColor: koyumavi,),
  body: Column(mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Text('Wrong QR Code Please Try Again', style: TextStyle(color: koyumavi,fontSize: 40),),_buildLoginBtn()
  ],)
  );
  Future QRcodelink() async {
    final _firestore = await FirebaseFirestore.instance
        .collection('Events')
        .doc(EventListScreen.choseneventid)
        .get();

    String QRlink = _firestore['QR Link'];
    print(QRlink);
    if (qrCode.toString() == QRlink) {
      print(qrCode.toString());
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return SignaturePage();
        }),
      );
    }

  }
  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
        QRcodelink();
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: ()  {scanQRCode();},

        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Start Scanning',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
  }
