import 'package:flutter/material.dart';

class DRTSelectDriversWidget extends StatefulWidget {
  @override
  _DRTSelectDriversWidgetState createState() => _DRTSelectDriversWidgetState();
}

class _DRTSelectDriversWidgetState extends State<DRTSelectDriversWidget> {
  bool option1 = false;
  bool option2 = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 8),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Add new driver',
              hintText: 'Enter driver\'s Driver Tag',
            ),
            textCapitalization: TextCapitalization.characters,
          ),
        ),
        CheckboxListTile(
          title: Text('Muhamad Syameel Bin Basri'),
          value: option1,
          onChanged: (value) => setState(() => option1 = !option1),
        ),
        Divider(),
        CheckboxListTile(
          title: Text('Muhammad Aiman Bin Ahmad Tamizai'),
          value: option2,
          onChanged: (value) => setState(() => option2 = !option2),
        ),
      ]
    );
  }
}