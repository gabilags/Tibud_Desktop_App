import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:queue_app/pages/loading.dart';
import 'package:queue_app/utils/constant.dart';
import 'package:queue_app/utils/window_buttons.dart';

class Login extends StatefulWidget {
  Login({ Key? key }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _controller = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? get _errorText {
    final text = _controller.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    if (text.length < 4) {
      return 'Too short';
    }
    return null;
  }

  void _submit() {
    setState(() => _submitted = true);
    if (_errorText == null) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute<void>(
          builder: (BuildContext context) => Loading(userName: _controller.text,),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size dsize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: dsize.width,
        height: dsize.height,
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child:Column(
                children: [
                  Container(
                    height: 50,
                    child: MoveWindow(),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(100, 100, 100, 0),
                    child: Container(
                      width: double.infinity,
                      height: dsize.height * .6,
                      child: Image.asset('assets/TIBUD_LOGO.PNG', fit: BoxFit.fill,),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: dsize.width/2,
              height: dsize.height,
              color: bgblue[50],
              child: ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, TextEditingValue value, __){
                  return Column(
                    children: [
                      WindowTitleBarBox(
                        child: Row(
                          children: [
                            Expanded(child: MoveWindow()),
                            Windowbuttons(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(100, 100, 100, 100),
                        child: Container(
                          width: double.infinity,
                          height: dsize.height * .1,
                          child: Center(child: Text('Tibud SKMPC', style: TextStyle(color: Colors.white, fontSize: dsize.width * .05, fontWeight: FontWeight.bold),)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(100, 50, 100, 20),
                        child: TextField(
                          controller: _controller,
                          toolbarOptions: ToolbarOptions(selectAll: true),
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: const Icon(Icons.account_circle_outlined,
                                size: 25),
                            contentPadding: EdgeInsets.all(20),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                  color: Color(0xFF3682F5), width: 1.0),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                  color: Colors.grey, width: 1.0),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              borderSide: BorderSide(
                                  color: Colors.red, width: 3.0),
                            ),
                            hintText: 'Username',
                            errorText: _submitted ? _errorText : null,
                          ), 
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 100),
                        child: Container(
                          width: double.infinity,
                          height: dsize.height * .07,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white), // background
                              foregroundColor: MaterialStateProperty.all<Color?>(
                                  bgblue[50]), // foreground
                            ),
                            onPressed: _controller.value.text.isNotEmpty ? _submit : null,
                            child: Text(
                              'LOGIN',
                              style: TextStyle(fontSize: dsize.width * .02),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}