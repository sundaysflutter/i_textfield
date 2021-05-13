import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:i_textfield/i_textfield.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ITextField(
                    keyboardType: ITextInputType.text,
                    hintText: 'hintText',
                    deleteIcon: Icon(Icons.delete),
                    pwdEyeCloseIcon:
                        Icon(Icons.remove_red_eye_sharp, color: Colors.black),
                    pwdEyeIcon: Icon(Icons.remove_red_eye, color: Colors.black),
                  ),
                  ITextField(
                    keyboardType: ITextInputType.text,
                    hintText: 'hintText',
                    deleteIcon: Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                    pwdEyeCloseIcon:
                        Icon(Icons.remove_red_eye_sharp, color: Colors.black),
                    pwdEyeIcon: Icon(Icons.remove_red_eye, color: Colors.black),
                    otherWidget: Icon(Icons.ac_unit, color: Colors.black),
                    // isOtherFloorDel: true
                  ),
                  IButtonTextField(
                    keyboardType: ITextInputType.text,
                    hintText: 'hintText',
                    deleteIcon: Icon(
                      Icons.delete,
                      color: Colors.black,
                      size: 22,
                    ),
                    otherWidget: Icon(
                      Icons.delete,
                      color: Colors.black,
                      size: 22,
                    ),
                  )
                ]),
          )),
    );
  }
}
