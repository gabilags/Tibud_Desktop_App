import 'package:flutter/material.dart';
import 'package:queue_app/models/person.dart';
import 'package:queue_app/utils/functions.dart';

class RadioButton1 extends StatefulWidget {
  RadioButton1({ Key? key, required this.person}) : super(key: key);
  Person person;

  @override
  State<RadioButton1> createState() => _RadioButtonState1();
}

class _RadioButtonState1 extends State<RadioButton1> {
  int _value = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.person.status == 'Pending'){
      _value = 1;
    }else{
      _value = 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    double dheight = MediaQuery.of(context).size.height;
    double dwidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          width: dwidth,
          height: dheight * .05,
          child: RadioListTile(
            value: 1, 
            groupValue: _value, 
            onChanged: (val){
              setState(() {
                _value = int.parse('$val');
                setvalue(int.parse('$val'));
              });
            },
            title: Text('Pending'),
          ),
        ),
        Container(
          width: dwidth,
          height: dheight * .05,
          child: RadioListTile(
            value: 2, 
            groupValue: _value, 
            onChanged: (val){
              setState(() {
                _value = int.parse('$val');
                setvalue(int.parse('$val'));
              });
            },
            title: Text('Done/Resolved'),
          ),
        ),
      ],
    );
  }
}