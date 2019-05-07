import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  @override
  _RadioGroupState createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  int _currentIndex = 1;

  List<GroupModel> _group = [
    GroupModel(
      text: "Flutter.dev",
      index: 1,
    ),
    GroupModel(
      text: "Inducesmile.com",
      index: 2,
    ),
    GroupModel(
      text: "Google.com",
      index: 3,
    ),
    GroupModel(
      text: "Yahoo.com",
      index: 4,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("RadioGroup Example"),
      ),
      body: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.all(8.0),
        children: _group
            .map((item) => RadioListTile(
                  groupValue: _currentIndex,
                  title: Text("${item.text}"),
                  value: item.index,
                  onChanged: (val) {
                    setState(() {
                      _currentIndex = val;
                    });
                  },
                ))
            .toList(),
      ),
    );
  }
}

class GroupModel {
  String text;
  int index;

  GroupModel({this.text, this.index});
}
