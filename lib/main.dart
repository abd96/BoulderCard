import 'package:flutter/material.dart';
import 'settings.dart';
import 'halls.dart';
import 'login.dart';
import 'package:flutter/foundation.dart';
import 'dart:developer';
import 'dart:convert';
// database imports
import 'database.dart';

void main() {
  initDatabase();
  runApp(const BoulderApp());
}

class BoulderApp extends StatelessWidget {
  const BoulderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Boulder Card',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: DefaultTabController(length: 2, child: LoginScreen()));
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Boulder eCards"),
      ),
      bottomNavigationBar: menu(),
      body: TabBarView(
        children: [Container(child: HallsList()), Container(child: Settings())],
      ),
    );
  }
}

Widget menu() {
  return Container(
    color: Color(0xFF4CAF50),
    child: TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: EdgeInsets.all(5.0),
      indicatorColor: Colors.white,
      tabs: [
        Tab(
          text: "My eCards",
          icon: Icon(Icons.card_membership),
        ),
        Tab(
          text: "Settings",
          icon: Icon(Icons.settings),
        ),
      ],
    ),
  );
}
