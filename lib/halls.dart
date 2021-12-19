import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'hall_profile.dart';
import 'dart:developer';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

// utils
import 'database.dart';

class HallsList extends StatefulWidget {
  HallsList({Key? key}) : super(key: key);
  @override
  HallListState createState() => HallListState();
}

class HallListState extends State<HallsList> {
  List<Widget> cards = <Widget>[];

  @override
  void initState() {
    super.initState();
    update();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      update();
    });
    return Stack(
      children: <Widget>[
        ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, int index) {
              return cards[index];
            }),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: () async => {
              // After await the update and cardAdder is closed the update method will get called
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CardAdder()),
              ),
              update(),
            },
            tooltip: 'add a new Hall',
            child: Icon(Icons.add),
          ),
        ),
      ],
    );

    //Stack(
    //  children: <Widget>[
    //    Container(
    //      child: ListView(children: cards),
    //    ),
    //  ],
    //);
  }

  void update() async {
    List<Widget> newCards = await getCards();
    setState(() {
      cards = newCards;
    });
  }
}

class HallCard extends StatelessWidget {
  String? objectId = '';
  String name;
  String location;
  String barcode;
  HallCard(this.name, this.location, this.barcode);

  void set id(String? generatedId) {
    objectId = generatedId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.place),
              title: Text(name),
              subtitle: Text(location),
            ),
            ButtonBar(
              buttonPadding: EdgeInsets.symmetric(horizontal: 11, vertical: 1),
              alignment: MainAxisAlignment.start,
              children: <Widget>[
                TextButton(
                  child: Text('Edit'),
                  onPressed: () {/* ... */},
                ),
                FlatButton(
                  color: Colors.green,
                  child: Text('Check In'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HallProfile(
                                this.name, this.location, this.barcode)));
                  },
                ),
                FlatButton(
                  color: Colors.redAccent,
                  child: Text('Delete'),
                  onPressed: () async {
                    ParseUser currentUser = await ParseUser.currentUser();
                    String? cardObjectId = await getCardObjectId(
                        name, location, currentUser.objectId!);
                    if (objectId != null) {
                      var cardToDelete = ParseObject('HallCards')
                        ..objectId = cardObjectId;
                      await cardToDelete.delete();
                      print("deleted?");
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CardAdder extends StatelessWidget {
  final cityController = TextEditingController();
  final nameController = TextEditingController();
  final codeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new eCard'),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'City',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormField(
                controller: codeController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'code',
                ),
              ),
            ),
            TextButton(
              child: Text('Scan Barcode'),
              onPressed: () {
                scanBarcode();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                addCard();
                Navigator.of(context).pop();
              },
            )
          ]),
    );
  }

  void addCard() async {
    print("ADDING");
    ParseUser currentUser = await ParseUser.currentUser();
    String city = cityController.text;
    String name = nameController.text;
    // TODO Add barcode to card
    String code = codeController.text;
    print(code);
    HallCard card = HallCard(name, city, code);
    card.id = currentUser.objectId;
    addHallCard(card);
    cityController.clear();
    nameController.clear();
    codeController.clear();
  }

  Future<String> scanBarcode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", 'Cancel', false, ScanMode.DEFAULT);
    print(code);
    codeController.text = code;
    return '';
  }
}
