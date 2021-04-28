import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:petfinder/commons/arguments.dart';
import 'package:petfinder/commons/styles.dart';
import 'package:petfinder/widgets/icon_button_material.dart';

class Filter extends StatefulWidget {
  Filter(
      {Key? key,
      required this.onPressed})
      : super(key: key);

  final OnSearchCallback onPressed;

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {

  TextEditingController textController = TextEditingController();
  TextEditingController radiusController = TextEditingController();

  bool collapsed = false;
  DateTime? dateStart;
  DateTime? dateEnd;

  @override
  Widget build(BuildContext context) {
    if ((collapsed)) {
      return minimized();
    } else {
      return Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.all(5.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: TextField(
                controller: textController,
                decoration: InputDecoration(
                    hintText: 'Enter coincidences like dog, max, cat ...'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
                  Text('From: ', style: sectionText),
                  Expanded(
                    child: Center(
                      child: Text(
                        dateToString(dateStart),
                        style: normalText,
                      ),
                    ),
                  ),
                  IconButtonWithMaterial(
                      icon: Icons.calendar_today,
                      onPressed: () => onPressedDate(context, true)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
                  Text('To: ', style: sectionText),
                  Expanded(
                    child: Center(
                      child: Text(
                        dateToString(dateEnd),
                        style: normalText,
                      ),
                    ),
                  ),
                  IconButtonWithMaterial(
                      icon: Icons.calendar_today,
                      onPressed: () => onPressedDate(context, false)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
                  Text('Radius: ', style: sectionText),
                  Expanded(
                    child: TextField(
                      controller: radiusController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: 'by default is 1500 meters'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Row(
                children: [
                  iconButton(Icons.keyboard_arrow_up, true),
                  Expanded(child: Container()),
                  IconButtonWithMaterial(
                      icon: Icons.search,
                      onPressed: () {
                        widget.onPressed(
                            textController.text,
                            (radiusController.text.length > 0)
                                ? int.parse(radiusController.text)
                                : null,
                            dateStart,
                            dateEnd);
                        setState(() {
                          collapsed = true;
                        });
                      }),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  minimized() {
    return Container(
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(5)),
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '  Expand the filter',
            style: sectionText,
          ),
          iconButton(Icons.keyboard_arrow_down, false)
        ],
      ),
    );
  }

  iconButton(IconData icon, bool collapse) {
    return IconButtonWithMaterial(
        icon: icon, onPressed: () => setState(() => collapsed = collapse));
  }

  onPressedDate(BuildContext context, bool start) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (picked != null) {
      setState(() {
        (start) ? dateStart = picked : dateEnd = picked;
      });
      final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute),
      );
      if (timeOfDay != null) {
        setState(() {
          if (start)
            dateStart = DateTime(dateStart!.year, dateStart!.month,
                dateStart!.day, timeOfDay.hour, timeOfDay.minute);
          else
            dateEnd = DateTime(dateEnd!.year, dateEnd!.month, dateEnd!.day,
                timeOfDay.hour, timeOfDay.minute);
        });
      }
    }
  }

  dateToString(DateTime? date) {
    String str = '';
    if (date != null) str = DateFormat('dd/MM/yyyy HH:mm').format(date);
    return str;
  }

  @override
  void dispose() {
    textController.dispose();
    radiusController.dispose();
    super.dispose();
  }
}
