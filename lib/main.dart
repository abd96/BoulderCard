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
        //home: DefaultTabController(length: 2, child: LoginScreen()));
        home: LoginScreen());
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Boulder eCards"),
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [HallsList(() => refresh()), Settings()],
          ),
        ));
  }

  void refresh() async {
    setState(() {});
  }
}

Widget menu() {
  return Container(
    color: const Color(0xFF4CAF50),
    child: const TabBar(
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
