// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:queue_app/database/server.dart';

String MONGO_USER = 'mongodb://localhost';
String USER_COLLECTION = 'issues';

Future<void> newConnection(String dbName, String colName, String port) async {
  MONGO_USER = 'mongodb://localhost:$port/$dbName';
  USER_COLLECTION = colName;
  await MongoDatabase.connect();
}

Future<void> login() async {
  MONGO_USER = 'mongodb://localhost:27017/QueueDB';
  USER_COLLECTION = 'complaints';
  await MongoDatabase.connect();
}

const PrimaryValue = 0xFF3682F5;

const MaterialColor bgblue = MaterialColor(
    PrimaryValue,
    <int, Color>{
      50:  Color(0xFF3682F5),
    },
  );