
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../model/activity.dart';

class BottleDialog extends StatefulWidget {

  final DateTime _timeStart = new DateTime.now();
  final DateTime _timeEnd = new DateTime.now();
  final Bottle bottle;

  BottleDialog.add() : bottle = null;

  BottleDialog.edit(this.bottle);

  @override
  _BottleDialogState createState() {
    if(bottle != null){
      return new _BottleDialogState(bottle.timeStart, bottle.timeEnd, bottle.note);
    } else {
      return new _BottleDialogState(this._timeStart, this._timeEnd, null);
    }
  }
}

class _BottleDialogState extends State<BottleDialog> {
  DateTime _timeStart;
  DateTime _timeEnd;
  String _note;

  TextEditingController _textController;


  _BottleDialogState(this._timeStart, this._timeEnd, this._note);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _textController = new TextEditingController(text: _note);

  }


  @override
  Widget build(BuildContext context) {
    return new SimpleDialog(
      contentPadding: EdgeInsets.zero,
      title: const Text('Mamadeira'),
      children: <Widget>[
        new ListTile(
          leading: new Icon(Icons.today, color: Colors.grey[500]),
          title: new DateTimeItem(
            dateTime: _timeStart,
            onChanged: ((timeStart) {
              setState(() {
                _timeStart = timeStart;
              });
            }),
          ),
        ),
        new ListTile(
          leading: new Icon(Icons.today, color: Colors.grey[500]),
          title: new DateTimeItem(
            dateTime: _timeEnd,
            onChanged: ((timeEnd) {
              setState(() {
                _timeEnd = timeEnd;
              });
            }),
          ),
        ),
        new ListTile(
          leading: new Icon(Icons.speaker_notes),
          title: new TextField(
            decoration: new InputDecoration(hintText: "Digite uma nota"),
            controller: _textController,
            onChanged: (value) => _note = value,
          ),
        ),
        new ListTile(
          title: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("CLOSE"),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(new Bottle(
                      _timeStart, _timeEnd, _note));
                },
                child:
                new Text("OK", style: new TextStyle(color: Theme.of(context).accentColor)),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key key, DateTime dateTime, @required this.onChanged})
      : assert(onChanged != null),
        date = dateTime == null
            ? new DateTime.now()
            : new DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null
            ? new DateTime.now()
            : new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new InkWell(
            onTap: (() => _showDatePicker(context)),
            child: new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new Text(new DateFormat('dd/MM/yyyy').format(date))),
          ),
        ),
        new InkWell(
          onTap: (() => _showTimePicker(context)),
          child: new Padding(
              padding: new EdgeInsets.symmetric(vertical: 0.0),
              child: new Text('${time.format(context)}')),
        ),
      ],
    );
  }

  Future _showDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date.subtract(const Duration(days: 20000)),
        lastDate: new DateTime.now());

    if (dateTimePicked != null) {
      onChanged(new DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute));
    }
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay =
    await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      onChanged(new DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
    }
  }
}