import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ontimemessaging/New%20DB/MessageClass.dart';

import 'ViewMessage.dart';
import 'datetime.dart';

class Schedule extends StatefulWidget {
  final List<Messageclass> _list;
  final Function _onListChanged;

  const Schedule(this._list, [this._onListChanged]);

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  Map<String, String> _numberNameMapper = Map();

  void _listChanged() {
    if (widget._onListChanged != null) widget._onListChanged();
  //  _mapNamesToNumbers();
  }

  @override
  void initState() {
    super.initState();
  //  _mapNamesToNumbers();

    // Timer(Duration(seconds: 1), () {
    //   if (this.mounted) setState(() => _mapNamesToNumbers());
  //  });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: widget._list == null
            ? Center(child: CircularProgressIndicator())
            : widget._list.length == 0
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('No Messages.', style: TextStyle(fontSize: 22)),
          ],
        )
            : _buildList(context));
  }

  Widget _buildList(BuildContext context) {
    return ListView.builder(
        itemCount: widget._list.length,
        itemBuilder: (BuildContext context, int index) {
          final Messageclass message = widget._list.elementAt(index);
          // final DateTime executedAt = DateTime.fromMillisecondsSinceEpoch(message.executedAt);
          const maxMsgLen = 20;
          const iconSize = 20.0;

          return /* Dismissible(
            onDismissed: (DismissDirection dd) async {
              message.isArchived = true;
              await MessageProvider.getInstance().updateMessage(message);
              _listChanged();
            },
            direction: DismissDirection.horizontal,
            dismissThresholds: {
              DismissDirection.horizontal: 0.2,
            },
            secondaryBackground: Icon(Icons.archive, color: Colors.blueGrey),
            background: Icon(Icons.archive, color: Colors.blueGrey),
            confirmDismiss: (DismissDirection dd) async {
              return true;
            },
            key: Key(message.id.toString()),
            child: */
            ListTile(
              isThreeLine: true,

             title:
             Text(_numberNameMapper[message.subject] ?? message.subject),
              subtitle: Text(
                message.content.substring(0,
                    message.content.length > maxMsgLen ? maxMsgLen : null) +
                    (message.content.length > maxMsgLen ? '...' : ''),
                overflow: TextOverflow.ellipsis,
                //maxLines: 1,
              ),
              trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                        message.status == MessageStatus.SENT
                            ? Icons.done
                            : message.status == MessageStatus.PENDING
                            ? Icons.schedule
                            : Icons.error,
                        size: iconSize),
                    Text(DateTimeFormator.timespan(
                        DateTime.fromMillisecondsSinceEpoch(message.executedAt),
                        units: 1))
                  ]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<bool>(
                      builder: (context) => ViewMessage(message)),
                ).then((bool result) {
                  _listChanged();
                });
             },

            );
        });
  }

}
