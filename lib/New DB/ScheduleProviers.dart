import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide Message;
import 'package:is_lock_screen/is_lock_screen.dart';
import 'package:ontimemessaging/New%20DB/MessageBloc.dart';
import 'package:ontimemessaging/New%20DB/MessageClass.dart';
import 'package:ontimemessaging/New%20DB/Provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
class ScheduleProvider {
  Timer _timer;
  final StreamController<Messageclass> _ctrlMsg = StreamController();
  final StreamController<Messageclass> _ctrlNotification = StreamController();
  final StreamController<List<Messageclass>> _ctrlMsgs = StreamController();
  StreamSubscription _subMsg;
  StreamSubscription _subMsgNotification;
  StreamSubscription _subMsgs;

  static const platform = const MethodChannel('samples.flutter.dev/battery');

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  /// Constructs a sheduler using the given [onMessageProcessed] and [onScheduleProcessed] listeners.
  ScheduleProvider(
      {dynamic Function(Messageclass) onMessageProcessed,
        dynamic Function(Messageclass) onNotificationTriggered,
        dynamic Function(List<Messageclass>) onScheduleProcessed}) {
    print('lodu');
    print(onMessageProcessed);
    print(onNotificationTriggered);
    print(onScheduleProcessed);

    if (onMessageProcessed != null)
      this.onMessageProcessed = onMessageProcessed;
    if (onScheduleProcessed != null)
      this.onScheduleProcessed = onScheduleProcessed;
  }

  /// Starts executing the schedule periodically according to the given [duration].
  void start(Duration duration) {
    stop();
    _subMsg?.resume();
    _subMsgNotification?.resume();
    _subMsgs?.resume();
    _timer = Timer.periodic(duration, (Timer t) => this._processSchedule());
  }

  void stop() {
    _timer?.cancel();
    _subMsg?.pause();
    _subMsgNotification?.pause();
    _subMsgs?.pause();
  }

  set onMessageProcessed(Function(Messageclass) onData) {
    assert(onData != null);

    _subMsg?.cancel();
    _subMsg = _ctrlMsg.stream.listen((Messageclass message) => onData(message));
  }

  set onNotificationTriggered(Function(Messageclass) onData) {
    assert(onData != null);

    _subMsgNotification?.cancel();
    _subMsgNotification =
        _ctrlNotification.stream.listen((Messageclass message) => onData(message));
  }

  set onScheduleProcessed(Function(List<Messageclass>) onDone) {
    assert(onDone != null);

    _subMsgs?.cancel();
    _subMsgs =
        _ctrlMsgs.stream.listen((List<Messageclass> messages) => onDone(messages));
  }

  void dispose() {
    _timer.cancel();
    _subMsg?.cancel();
    _subMsgNotification?.cancel();
    _subMsgs?.cancel();
    _ctrlMsg.close();
    _ctrlNotification.close();
    _ctrlMsgs.close();
  }



  void _processSchedule() async {
    final messages = await MessageProviders.getInstance().getMessages();
    bool isLocked = await isLockScreen();

    messages
        .takeWhile((Messageclass message) =>
    (message.status == MessageStatus.PENDING ||
        (message.status == MessageStatus.FAILED &&
        DateTime.now().millisecondsSinceEpoch >= message.executedAt)))
        .forEach((Messageclass message) {
      MessageDriver.SCHEDULE;
      //_processSms(message);
    });

    if (messages.length > 0) _ctrlMsgs.sink.add(messages);
  }
}
