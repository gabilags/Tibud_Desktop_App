// To parse this JSON data, do
//     final user = userFromJson(jsonString);

import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';

Person userFromJson(String str) => Person.fromJson(json.decode(str));

String userToJson(Person data) => json.encode(data.toJson());

class Person {
    Person({
        required this.id,
        required this.name,
        required this.actionTaken,
        required this.user,
        required this.issue,
        required this.status,
        required this.date,
        required this.lastUpdated,
        required this.refNo,
    });

    ObjectId id;
    String name;
    String actionTaken;
    String user;
    String issue;
    String status;
    String date;
    String lastUpdated;
    String refNo;

    factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["_id"],
        name: json["name"],
        actionTaken: json["actionTaken"],
        user: json["user"],
        issue: json["issue"],
        status: json["status"],
        date: json["date"],
        lastUpdated: json["lastUpdated"],
        refNo: json["refNo"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "actionTaken": actionTaken,
        "user": user,
        "issue": issue,
        "status": status,
        "date": date,
        "lastUpdated": lastUpdated,
        "refNo": refNo,
    };
}

