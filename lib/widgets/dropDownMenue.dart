import 'package:booking_app/utils/pallete.dart';
import 'package:flutter/material.dart';

class DropDownMenu extends StatefulWidget {
  @override
  _DropDownMenuState createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  final items = ['Beauty', 'Sport', 'Medicine'];

  String? value;
  late double _height;
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.all(_height / 50.61818181818182),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(border: Border.all(color: kGreen)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          items: items.map(buildMenueItem).toList(),
          value: value,
          hint: Text('Choose Category'),
          onChanged: (value) {
            setState(() => this.value = value);
          },
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey,
          ),
          iconSize: 36,
        ),
      ),
    );
  }
}

DropdownMenuItem<String> buildMenueItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
        item,
        style: TextStyle(fontSize: 20),
      ),
    );
