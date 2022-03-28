import 'package:flutter/material.dart';
import 'package:queue_app/pages/home_page.dart';
import 'package:queue_app/utils/constant.dart';

class Loading extends StatefulWidget {
  Loading({ Key? key, required this.userName }) : super(key: key);

  String userName;
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void getData() async {
    await login();
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute<void>(
        builder: (BuildContext context) => MyHomePage(username: widget.userName,),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}