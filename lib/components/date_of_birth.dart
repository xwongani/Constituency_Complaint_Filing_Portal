import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DOB extends StatefulWidget {
  const DOB({Key? key}) : super(key: key);

  @override
  State<DOB> createState() => _DOBState();
}

class _DOBState extends State<DOB> {
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
              ),
              icon: Icon(Icons.calendar_today_rounded),
              labelText: 'yyyy/mm/dd',
            ),
            controller: dateController,
            onTap: () async {
              DateTime? pickeddate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1930),
                lastDate: DateTime(2005),
              );

              if (pickeddate != null) {
                setState(() {
                  dateController.text = DateFormat('yyyy-MM-dd')
                      .format(pickeddate); // Use 'yyyy-MM-dd'
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
