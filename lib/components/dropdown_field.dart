import 'package:flutter/material.dart';

class DropDownField extends StatefulWidget {
  const DropDownField({Key? key}) : super(key: key);

  @override
  State<DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<DropDownField> {
  final _value = "-1";

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        // Wrap in a SingleChildScrollView
        child: DropdownButtonFormField(
          value: _value,
          items: const [
            DropdownMenuItem(value: "-1", child: Text('-- Select Province --')),
            DropdownMenuItem(value: "-2", child: Text('Central Province')),
            DropdownMenuItem(value: "-3", child: Text('Copperbelt Province')),
            DropdownMenuItem(value: "-4", child: Text('Eastern Province')),
            DropdownMenuItem(value: "-5", child: Text('Luapula Province')),
            DropdownMenuItem(value: "-6", child: Text('Lusaka Province')),
            DropdownMenuItem(value: "-7", child: Text('Muchinga Province')),
            DropdownMenuItem(value: "-8", child: Text('Northern Province')),
            DropdownMenuItem(
                value: "-9", child: Text('North-Western Province')),
            DropdownMenuItem(value: "-10", child: Text('Southern Province')),
            DropdownMenuItem(value: "-11", child: Text('Western  Province')),
          ],
          onChanged: (V) {},
        ),
      ),
    );
  }
}
