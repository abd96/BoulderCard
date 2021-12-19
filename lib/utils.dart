import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:developer';

// Firebase

Future<String> readJson(String path) {
  return rootBundle.loadString(path);
}

// get all users from databse



// Check if password is correct for a given user
