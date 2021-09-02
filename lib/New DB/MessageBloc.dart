import 'dart:async';

import 'package:ontimemessaging/New%20DB/MessageClass.dart';

import 'Provider.dart';

class MessageAdd {
  final _mp = MessageProviders.getInstance();
  final _ctrl = StreamController<List<Messageclass>>.broadcast();
  List<Messageclass> _list = List();

  Stream get stream => _ctrl.stream;


  void dispose() {
    _ctrl.close();
  }

  void loadMessages({MessageStatus status, int count}) async {
    final messages = await _mp.getMessages(status: status, count: count);
    _list = messages;
    _ctrl.sink.add(messages);
  }

  void truncateTables() async {
    await _mp.truncateTables();
    await _ctrl.stream.drain();
    _list.clear();
    _ctrl.sink.add(List<Messageclass>());
  }

  void deleteAllMessages() {
    truncateTables();
  }

  Future<bool> addMessage(final Messageclass message) async {
    final bool r = await _mp.addMessage(message);
    _ctrl.sink.add(_list..add(message));
    return r;
  }

  Future<bool> updateMessage(final Messageclass message) async {
    final bool r = await _mp.updateMessage(message);
    print('updateMessage');
    for (int i = 0; i < _list.length; ++i)
      if (_list[i].id == message.id){
        print('updateMessage1234567890');
        print(message.toString());
        _list[i] = message;
        _ctrl.sink.add(_list);
        return r;
      }
    _ctrl.sink.add(_list..add(message));

    return r;
  }
}