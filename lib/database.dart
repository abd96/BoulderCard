import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:flutter/material.dart';
import 'halls.dart';

void initDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();
  const keyApplicationId = 'qHbKDg0FdSdpunm5qr6rQEZ2X4EYo6tesLiqeJ4q';
  const keyClientKey = 'zHwwSasM6Fvkv2DnA5rpgkCA11KcZVbsvQPJj4K1';
  const keyParseServerUrl = 'https://parseapi.back4app.com';

  await Parse().initialize(keyApplicationId, keyParseServerUrl,
      clientKey: keyClientKey, autoSendSessionId: true);
}

// Add a hallcard to the database
void addHallCard(HallCard card) async {
  var toAdd = ParseObject('HallCards')
    ..set('name', card.name)
    ..set('location', card.location)
    ..set('user', card.objectId)
    ..set('code', card.barcode);
  await toAdd.save();
}

// Find a user in database using the objectId
Future<String?> isUser(String name) async {
  List<ParseObject>? allUsers = await getAllUsers();
  if (allUsers != null) {
    for (var i = 0; i < allUsers.length; i++) {
      if (allUsers[i].get('username') == name) {
        return allUsers[i].get('objectId');
      }
    }
    return null;
  }
  return null;
}

Future<ParseObject?> getUser(String name) async {
  List<ParseObject>? allUsers = await getAllUsers();
  if (allUsers != null) {
    for (var i = 0; i < allUsers.length; i++) {
      if (allUsers[i].get('username') == name) {
        return allUsers[i];
      }
    }
    return null;
  }
  return null;
}

// Get a list of all Users in the database
Future<List<ParseObject>?> getAllUsers() async {
  QueryBuilder<ParseUser> queryUsers =
      QueryBuilder<ParseUser>(ParseUser.forQuery());
  final ParseResponse apiResponse = await queryUsers.query();

  if (apiResponse.success && apiResponse.results != null) {
    List<ParseObject> backendUsers = apiResponse.results as List<ParseObject>;
    return backendUsers;
  }
  return null;
}

Future<List<Widget>> getCards() async {
  List<Widget> ret = <Widget>[];
  ParseUser currentUser = await ParseUser.currentUser();
  String currentObjectID = currentUser.objectId!;
  final QueryBuilder<ParseObject> parseQuery =
      QueryBuilder<ParseObject>(ParseObject('HallCards'));
  parseQuery.whereContains('user', currentObjectID);
  final ParseResponse apiResponse = await parseQuery.query();
  if (apiResponse.success && apiResponse.results != null) {
    for (var o in apiResponse.results!) {
      ParseObject card = (o as ParseObject);
      String user = card['user'];
      String location = card['location'];
      String name = card['name'];
      String code = card['code'];
      ret.add(HallCard(name, location, code));
    }
  }
  return ret;
}

Future<String?> getCardObjectId(
    String _name, String _location, String _user) async {
  ParseUser currentUser = await ParseUser.currentUser();
  String currentObjectID = currentUser.objectId!;
  final QueryBuilder<ParseObject> parseQuery =
      QueryBuilder<ParseObject>(ParseObject('HallCards'));
  parseQuery.whereContains('user', currentObjectID);
  final ParseResponse apiResponse = await parseQuery.query();
  if (apiResponse.success && apiResponse.results != null) {
    for (var o in apiResponse.results!) {
      ParseObject card = (o as ParseObject);
      String name = card['name'];
      String location = card['location'];
      String code = card['code'];
      String user = card['user'];
      if (user == _user && name == _name && location == _location) {
        return card.objectId;
      }
    }
  }
}
