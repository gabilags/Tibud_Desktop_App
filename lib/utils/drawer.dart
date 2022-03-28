// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:queue_app/models/person.dart';
import 'package:queue_app/utils/constant.dart';
import 'package:queue_app/utils/dialogs.dart';


class DrawerWidget extends StatefulWidget {
  DrawerWidget({ Key? key, required this.list, required this.username}) : super(key: key);

  AsyncSnapshot list;
  final String username;

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final ScrollController controller3 = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: bgblue[50],
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Text("Notifications", style: TextStyle(color: Colors.white, fontSize: 25)),
              Divider(color: Colors.white, thickness: 3,),
              Flexible(
                child: ListView.builder(
                  addAutomaticKeepAlives: false,
                    controller: controller3,
                    scrollDirection: Axis.vertical,
                    itemCount: widget.list.data.length,
                    itemBuilder: (context, index) {
                      var date1 = Jiffy(widget.list.data[index]['date']);
                      var date2 = Jiffy(DateTime.now());
                      num diff = date2.diff(date1, Units.HOUR);
                      if (widget.list.data[index]['status'] == 'Pending' && diff >= 72) {
                        return NotifTile(Person.fromJson(widget.list.data[index]), context);
                      }
                      return Container();
                    }),
              ),
            ],
          ),
        )
      ),
    );
  }

  Widget NotifTile(Person person, BuildContext context) {
    Size dsize = MediaQuery.of(context).size;
    return ListTile(
      isThreeLine: true,
      onTap: () {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return ViewEditForm(
              person: person,
              username: widget.username,
            );
          });
      },
      leading: Icon(Icons.report_problem, color: Colors.red,),
      title: Text('Urgent Request/Concern', style: TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),),
      subtitle: Text('${person.name} \n ${Jiffy(person.date).fromNow()}', style: TextStyle(color: Colors.white),),
    );
  }
}