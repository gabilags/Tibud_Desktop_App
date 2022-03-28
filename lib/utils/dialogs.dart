// ignore_for_file: prefer_const_constructors, prefer_const_declarations, sized_box_for_whitespace

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:queue_app/database/server.dart';
import 'package:queue_app/models/person.dart';
import 'package:queue_app/utils/constant.dart';
import 'package:queue_app/utils/functions.dart';
import 'package:queue_app/utils/radioButton.dart';
import 'package:path_provider/path_provider.dart';


//Remove Data Dialog
class RemoveDialog extends StatelessWidget {
  const RemoveDialog({Key? key, required this.id}) : super(key: key);
  final mongo.ObjectId id;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Remove Data'),
      content: Text('Do you wish to remove this data?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No')),
        TextButton(
            onPressed: () async {
              await MongoDatabase.delete(id);
              Navigator.pop(context);
              GFToast.showToast(
                'Data Removed',
                context,
                toastPosition: GFToastPosition.BOTTOM,
              );
            },
            child: Text('Yes')),
      ],
      elevation: 24.0,
    );
  }
}

class SaveDialog extends StatelessWidget {
  SaveDialog({ Key? key, this.pdf }) : super(key: key);

  var pdfName = TextEditingController();
  final pdf;

  Future<void> SavePDF(String name) async {
    final output = await getDownloadsDirectory();
    final file = File('${output?.path}/$name.pdf');
    await file.writeAsBytes(await pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    Size dsize = MediaQuery.of(context).size;
    return SimpleDialog(
      title: Text('Save PDF'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: dsize.width * .2,
            height: dsize.height * .15,
            child: TextField(
              controller: pdfName,
              toolbarOptions: ToolbarOptions(selectAll: true),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                hintText: 'Filename'
              ),
            ),         
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: dsize.width * .11,
              height: dsize.height * .05,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // background
                  foregroundColor: MaterialStateProperty.all<Color?>(
                      bgblue[50]), // foreground
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              width: dsize.width * .11,
              height: dsize.height * .05,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color?>(
                      bgblue[50]), // background
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // foreground
                ),
                onPressed: () {
                  SavePDF(pdfName.text);
                  Navigator.pop(context);
                  GFToast.showToast(
                    'PDF Saved in Downloads Directory',
                    context,
                    toastPosition: GFToastPosition.BOTTOM,
                  );
                },
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ConnectionDialog extends StatelessWidget {
  ConnectionDialog({ Key? key }) : super(key: key);

  var dbName = TextEditingController();
  var colName = TextEditingController();
  var port = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size dsize = MediaQuery.of(context).size;
    return SimpleDialog(
      title: Text('New Connection'),
      children: [
        Container(
          width: dsize.width * .3,
          height: dsize.height * .3,
          child: Column(
            children: [
              TextField(
                controller: port,
                toolbarOptions: ToolbarOptions(selectAll: true),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  hintText: 'Port'
                ),
              ),
              TextField(
                controller: dbName,
                toolbarOptions: ToolbarOptions(selectAll: true),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  hintText: 'Database'
                ),
              ),
              TextField(
                controller: colName,
                toolbarOptions: ToolbarOptions(selectAll: true),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  hintText: 'Collection'
                ),
              ),
            ],
          ),
          
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: dsize.width * .15,
              height: dsize.height * .05,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // background
                  foregroundColor: MaterialStateProperty.all<Color?>(
                      bgblue[50]), // foreground
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              width: dsize.width * .15,
              height: dsize.height * .05,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color?>(
                      bgblue[50]), // background
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // foreground
                ),
                onPressed: () {
                  newConnection(dbName.text, colName.text, port.text);
                  Navigator.pop(context);
                  GFToast.showToast(
                      'New Connection',
                      context,
                      toastPosition: GFToastPosition.BOTTOM,
                    );
                },
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ViewEditForm extends StatefulWidget {
  ViewEditForm({ Key? key, required this.person, required this.username }) : super(key: key);
  final Person person;
  final String username;

  @override
  State<ViewEditForm> createState() => _ViewEditFormState();
}

class _ViewEditFormState extends State<ViewEditForm> {
  var name = TextEditingController();
  var issue = TextEditingController();
  var action = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    Size dsize = MediaQuery.of(context).size;

    name.text = widget.person.name;
    action.text = widget.person.actionTaken;
    issue.text = widget.person.issue;

    return SimpleDialog(
      elevation: 24.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      titlePadding: EdgeInsets.only(bottom: 10),
      title: Container(
        width: dsize.width * .3,
        height: dsize.height * .07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          color: bgblue[50],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Last Updated: ${Jiffy(widget.person.lastUpdated).yMMMMd}",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      children: [
        Container(
          width: dsize.width * .5,
          height: dsize.height * .5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  controller: name,
                  toolbarOptions: ToolbarOptions(selectAll: true),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_outlined,
                        size: 25),
                    contentPadding: EdgeInsets.all(20),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Color(0xFF3682F5), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey, width: 1.0),
                    ),
                    labelText: 'Respondent/ Complainant/ Appellant'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  maxLines: 5,
                  controller: issue,
                  toolbarOptions: ToolbarOptions(selectAll: true),
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 85),
                      child: Icon(Icons.edit,
                          size: 25),
                    ),
                    contentPadding: EdgeInsets.all(20),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Color(0xFF3682F5), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey, width: 1.0),
                    ),
                    labelText: 'Request/Concern'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  controller: action,
                  toolbarOptions: ToolbarOptions(selectAll: true),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.edit,
                        size: 25),
                    contentPadding: EdgeInsets.all(20),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Color(0xFF3682F5), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey, width: 1.0),
                    ),
                    labelText: 'Action Taken'),
                ),
              ),
              RadioButton1(person: widget.person,),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: dsize.width * .25,
              height: dsize.height * .05,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // background
                  foregroundColor: MaterialStateProperty.all<Color?>(
                      bgblue[50]), // foreground
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              width: dsize.width * .25,
              height: dsize.height * .05,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color?>(
                      bgblue[50]), // background
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // foreground
                ),
                onPressed: () {
                  _updateData(widget.person.id, name.text, action.text, widget.username,
                  validate(), issue.text, widget.person.date, widget.person.refNo);
                  Navigator.pop(context);
                  GFToast.showToast(
                      'Data Updated',
                      context,
                      toastPosition: GFToastPosition.BOTTOM,
                    );
                },
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _updateData(mongo.ObjectId _id, String name, String action, String user,
    String status, String issue, String date, String refNo) async {
    final data = Person(
        id: _id,
        name: name,
        actionTaken: action,
        user: user,
        issue: issue,
        status: status,
        date: date,
        lastUpdated: DateTime.now().toString(),
        refNo: refNo
    );
    await MongoDatabase.update(data);
  }

}

class InsertForm extends StatefulWidget {
  InsertForm({ Key? key, required this.snapshot, required this.username }) : super(key: key);
  AsyncSnapshot snapshot;
  final String username;
  
  @override
  State<InsertForm> createState() => _InsertFormState();
}

class _InsertFormState extends State<InsertForm> {
  var name = TextEditingController();
  var issue = TextEditingController();
  var action = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size dsize = MediaQuery.of(context).size;
    return SimpleDialog(
      elevation: 24.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
      titlePadding: EdgeInsets.only(bottom: 10),
      title: Container(
        width: dsize.width * .3,
        height: dsize.height * .07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
          color: bgblue[50],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Issue No: ",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      children: [
        Container(
          width: dsize.width * .5,
          height: dsize.height * .5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  controller: name,
                  toolbarOptions: ToolbarOptions(selectAll: true),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle_outlined,
                        size: 25),
                    contentPadding: EdgeInsets.all(20),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Color(0xFF3682F5), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey, width: 1.0),
                    ),
                    labelText: 'Respondent/ Complainant/ Appellant'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  maxLines: 5,
                  controller: issue,
                  toolbarOptions: ToolbarOptions(selectAll: true),
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 85),
                      child: Icon(Icons.edit,
                          size: 25),
                    ),
                    contentPadding: EdgeInsets.all(20),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Color(0xFF3682F5), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey, width: 1.0),
                    ),
                    labelText: 'Request/Concern'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: TextField(
                  controller: action,
                  toolbarOptions: ToolbarOptions(selectAll: true),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.edit,
                        size: 25),
                    contentPadding: EdgeInsets.all(20),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Color(0xFF3682F5), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(
                          color: Colors.grey, width: 1.0),
                    ),
                    labelText: 'Action Taken'),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: dsize.width * .25,
              height: dsize.height * .05,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // background
                  foregroundColor: MaterialStateProperty.all<Color?>(
                      bgblue[50]), // foreground
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Close',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              width: dsize.width * .25,
              height: dsize.height * .05,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color?>(
                      bgblue[50]), // background
                  foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white), // foreground
                ),
                onPressed: () {
                  _insertData(widget.snapshot, name.text, action.text, widget.username, issue.text);
                  Navigator.pop(context);
                  GFToast.showToast(
                      'Inserted to Database',
                      context,
                      toastPosition: GFToastPosition.BOTTOM,
                    );
                },
                child: Text(
                  'Save',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

    Future<void> _insertData(AsyncSnapshot snapshot, String name, String action, String user, String issue) async {
    var _id = mongo.ObjectId();
    var now = DateTime.now();
    int refno = makeRefNo(snapshot);
    final data = Person(
        id: _id,
        name: name,
        actionTaken: action,
        user: user,
        issue: issue,
        status: "Pending",
        date: DateTime.now().toString(),
        lastUpdated: DateTime.now().toString(),
        refNo: refno.toString(),
    );
    await MongoDatabase.insert(data);
    clearAll();
  }

  int makeRefNo(AsyncSnapshot snapshot){
    int ref = Random().nextInt(999) + 100;
    for (var item in snapshot.data) {
      Person person = Person.fromJson(item);
      if(int.parse(person.refNo) == ref){
        makeRefNo(snapshot);
        break;
      }
    }
    return ref;
  }

  void clearAll() {
    name.text = "";
    action.text = "";
    issue.text = "";
  }
}