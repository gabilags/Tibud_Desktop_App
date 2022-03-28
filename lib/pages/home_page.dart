// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, non_constant_identifier_names

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:queue_app/database/server.dart';
import 'package:queue_app/models/person.dart';
import 'package:queue_app/pages/login_form.dart';
import 'package:queue_app/pages/reports_page.dart';
import 'package:queue_app/utils/constant.dart';
import 'package:queue_app/utils/dialogs.dart';
import 'package:queue_app/utils/drawer.dart';
import 'package:queue_app/utils/functions.dart';
import 'package:queue_app/utils/window_buttons.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.username}) : super(key: key);
  final String username;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController controller1 = ScrollController();
  final ScrollController controller2 = ScrollController();
  GlobalKey key = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    MongoDatabase.logout();
  }

  @override
  Widget build(BuildContext context) {
    Size dsize = MediaQuery.of(context).size;
    return FutureBuilder(
        future: MongoDatabase.getData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: dsize.width,
              height: dsize.height,
              child: Container(
                width: dsize.width,
                height: dsize.height,
                color: Colors.white,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else {
            if (snapshot.hasData) {
              return Scaffold(
                drawer: DrawerWidget(list: snapshot, username: widget.username,),
                body: Builder(
                  builder: (context) {
                    return Row(
                      children: [
                        Container(
                          width: 50,
                          height: dsize.height,
                          color: bgblue[50],      
                          child: Column(
                            children: [
                              Container(
                                height: 30,
                                child: MoveWindow(),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  width: 50,
                                  child: Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ConnectionDialog();
                                            });
                                        },
                                        tooltip: 'New Connection',
                                        splashRadius: 15,
                                        icon: Icon(Icons.add, color: Colors.white),
                                      ),
                                      SizedBox(height: 20,),
                                      Badge(
                                        showBadge:
                                            (notifCount(snapshot.data) == 0) ? false : true,
                                        badgeContent: Text('${notifCount(snapshot.data)}', style: TextStyle(
                                          color: Colors.white,
                                        )),
                                        position: BadgePosition.topEnd(top: 6, end: 3),
                                        child: IconButton(
                                          onPressed: () {
                                            Scaffold.of(context).openDrawer();
                                          },
                                          tooltip: 'Notifications',
                                          splashRadius: 15,
                                          icon: Icon(Icons.notifications_none, color: Colors.white),
                                        )
                                      ),
                                      SizedBox(height: 20,),
                                      IconButton(
                                        onPressed: () {
                                          MongoDatabase.logout();
                                          Navigator.pushReplacement(
                                            context, 
                                            MaterialPageRoute<void>(
                                              builder: (BuildContext context) => Login(),
                                            ),
                                          );
                                        },
                                        tooltip: 'Logout',
                                        splashRadius: 15,
                                        icon: Icon(Icons.logout, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: dsize.height,
                            child: Column(
                              children: [
                                WindowTitleBarBox(
                                  child: Row(
                                    children: [
                                      Expanded(child: MoveWindow()),
                                      Windowbuttons(),
                                    ],
                                  ),
                                ),
                                //Start of UI
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      'Queue List',
                                      style: TextStyle(
                                          fontSize: 30, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                //The 3 boxes on top
                                Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        width: 170,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: bgblue[50],
                                          borderRadius: BorderRadius.circular(5.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color:  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 5,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${snapshot.data.length}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Total Issues',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Container(
                                        width: 170,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: bgblue[50],
                                          borderRadius: BorderRadius.circular(5.0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              spreadRadius: 5,
                                              blurRadius: 5,
                                              offset: Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${pendingIssues(snapshot.data)}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Pending Issues',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Container(
                                          width: 170,
                                          height: 120,
                                          decoration: BoxDecoration(
                                            color: bgblue[50],
                                            borderRadius: BorderRadius.circular(5.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                spreadRadius: 5,
                                                blurRadius: 5,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    '${resolvedIssues(snapshot.data)}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    'Resolved Issues',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //The 2 buttons for Add and Refresh
                                Align(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            primary: bgblue[50], // background
                                            onPrimary: Colors.white, // foreground
                                          ),
                                          onPressed: ()
                                          => showDialog(
                                              context: context,
                                              builder: (context) {
                                                return InsertForm(snapshot: snapshot,username: widget.username,);
                                              }).then((value) => setState(() {})),
                                          icon: Icon(Icons.add),
                                          label: Text('Add Issue'),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            primary: bgblue[50], // background
                                            onPrimary: Colors.white, // foreground
                                          ),
                                          onPressed: () {
                                            setState(() {});
                                          },
                                          icon: Icon(Icons.refresh),
                                          label: Text('Refresh'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: DataTable(
                                        columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.1,
                                        dataRowHeight: 80,
                                        showBottomBorder: true,
                                        headingRowColor: MaterialStateColor.resolveWith((states) => Colors.grey.shade400),
                                        columns: 
                                          const [
                                            DataColumn(label: Text('Issue No.' , style: TextStyle(fontWeight: FontWeight.bold),)),
                                            DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold),)),
                                            DataColumn(label: Text('Respondent/Complainant', style: TextStyle(fontWeight: FontWeight.bold),)),
                                            DataColumn(label: Text('Request/Concern', style: TextStyle(fontWeight: FontWeight.bold),)),
                                            DataColumn(label: Text('Time Period', style: TextStyle(fontWeight: FontWeight.bold),)),
                                            DataColumn(label: Text('Action Taken', style: TextStyle(fontWeight: FontWeight.bold),)),
                                            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold),)),
                                            DataColumn(label: Text('Last Updated', style: TextStyle(fontWeight: FontWeight.bold),)),
                                            DataColumn(label: Text('Updated By', style: TextStyle(fontWeight: FontWeight.bold),)), 
                                            DataColumn(label: Text('Ref No.', style: TextStyle(fontWeight: FontWeight.bold),)),
                                            DataColumn(label: Text('Options', style: TextStyle(fontWeight: FontWeight.bold),)),
                                          ],
                                        rows:data(snapshot),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                ),
              );
            }else{
              return Scaffold(
                body: Container(
                  width: dsize.width,
                  height: dsize.height,
                  color: Colors.white,
                  child: Column(
                    children: [
                      WindowTitleBarBox(
                        child: Row(
                          children: [
                            Expanded(child: Container()),
                            Windowbuttons(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 250, 0, 20),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text('No Data Available'),
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: bgblue[50], // background
                          onPrimary: Colors.white, // foreground
                        ),
                        onPressed: () {
                          setState(() {});
                        },
                        icon: Icon(Icons.refresh),
                        label: Text('Refresh'),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
        });
  }
  List<DataRow> data(AsyncSnapshot snapshot) {
    List<DataRow> dataList = [];
    for (var item in snapshot.data) {
      Person person = Person.fromJson(item);
      dataList.add(
        DataRow(cells: [
          DataCell(Container(width: (MediaQuery.of(context).size.width / 10) * .75, child: Text(person.id.$oid))),
          DataCell(Container(width: (MediaQuery.of(context).size.width / 10) * .75, child: Text(Jiffy(person.date).yMMMMd))),
          DataCell(Container(width: (MediaQuery.of(context).size.width / 10) * .7, child: Text(person.name))),
          DataCell(Container(width: (MediaQuery.of(context).size.width / 10) * .9, child: Text(person.issue, overflow: TextOverflow.ellipsis,))),
          DataCell(Container(width: (MediaQuery.of(context).size.width / 10) * .65, child: Text(Jiffy(person.date).fromNow()))),
          DataCell(Container(width: (MediaQuery.of(context).size.width / 10) * .7, child: Text(person.actionTaken, overflow: TextOverflow.fade,))),
          DataCell(
            Container(
              width: (MediaQuery.of(context).size.width / 10) * .6, 
              child: Container(
                width: (MediaQuery.of(context).size.width / 10) * .6,
                height:(MediaQuery.of(context).size.width / 10) * .2,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: person.status == 'Pending'? Colors.red: Colors.green,
                ),
                child: Text(
                  person.status, 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (MediaQuery.of(context).size.width / 10) * .08,
                  )
                )
              )
            )
          ),
          DataCell(Container(width: (MediaQuery.of(context).size.width / 10) * .75, child: Text(Jiffy(person.lastUpdated).yMMMMd))),
          DataCell(Container(width: (MediaQuery.of(context).size.width / 10) * .65, child: Text(person.user))),
          DataCell(Container(width: (MediaQuery.of(context).size.width / 10) * .4, child: Text(person.refNo))),
          DataCell(Row(
            children: [
              IconButton(
                splashRadius: 15,
                tooltip: 'View',
                icon: Icon(Icons.remove_red_eye),
                onPressed: (){
                showDialog(
                  context: context,
                  builder: (context) {
                    return ViewEditForm(person: person,username: widget.username,);
                  }).then((value) => setState(() {}));
                }
              ),
              IconButton(
                splashRadius: 15,
                tooltip: 'Report',
                icon: Icon(Icons.picture_as_pdf),
                onPressed: (){
                  Navigator.pushReplacement(
                    context, 
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => ReportsForm(userName: widget.username,person: person,),
                    ),
                  );
                }
              ),
              IconButton(
                splashRadius: 15,
                tooltip: 'Delete',
                icon: Icon(Icons.delete),
                onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return RemoveDialog(id: person.id);
                  }).then((value) => setState(() {}));
                }
              ),
            ]
          )),
        ])
      );
    }
    return dataList;
  }
}
