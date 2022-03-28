// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:mongo_dart/mongo_dart.dart';
import 'package:queue_app/models/person.dart';
import 'package:queue_app/utils/constant.dart';


class MongoDatabase {
  static var db, userCollection;

//connecting to MongoDB
  static connect() async {
    db = await Db.create(MONGO_USER);
    await db.open();
    userCollection = db.collection(USER_COLLECTION);
  }

  static logout() async {
    await db.close();
  }

//Getter of documents then turn to list
  static Future<List<Map<String, dynamic>>> getData() async {
    try{
      final arrData = await userCollection.find().toList();
      return arrData;
    }catch(er){
      return Future.error(er);
    }
  }

//Inserting a new document
  static Future<String> insert(Person data) async {
    try {
      var result = await userCollection.insertOne(data.toJson());
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something Wrong with inserting data.";
      }
    } catch (e) {
      return e.toString();
    }
  }

//Deleting a document
  static delete(ObjectId id) async {
    await userCollection.remove(where.id(id));
  }

//Updating a document
  static Future<String> update(Person data) async {
    try {
      var result = await userCollection.replaceOne(where.id(data.id),{
        "_id": data.id,
        "name": data.name,
        "actionTaken": data.actionTaken,
        "user": data.user,
        "issue": data.issue,
        "status": data.status,
        "date": data.date,
        "lastUpdated": data.lastUpdated,
        "refNo": data.refNo,
      });
      if (result.isSuccess) {
        return "Data Inserted";
      } else {
        return "Something Wrong with inserting data.";
      }
    } catch (e) {
      return e.toString();
    }
  }
}
