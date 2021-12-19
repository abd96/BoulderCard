import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:barcode_widget/barcode_widget.dart';

class HallProfile extends StatelessWidget {
  String name;
  String location;
  String barcode;
  HallProfile(this.name, this.location, this.barcode);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(name + ' in ' + location)),
        body: ProfilePage(name, location, barcode));
  }
}

class ProfilePage extends StatelessWidget {
  String name;
  String location;
  String barcode;
  ProfilePage(this.name, this.location, this.barcode);
  @override
  Widget build(BuildContext context) {
    //return Center(
    //  child: QrImage(
    //    data: "1234",
    //    version: QrVersions.auto,
    //  ),
    //);
    return Center(
        child: SafeArea(
            child: BarcodeWidget(
                barcode: Barcode.code128(),
                data: barcode,
                width: 450,
                height: 100)));
  }
}
