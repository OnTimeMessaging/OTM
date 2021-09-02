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

  // String FormatStringAsPhoneNumber(String input) {
  //   String output;
  //   switch (input.length) {
  //     case 11:
  //       if (input.substring(0, 1) == '0')
  //         output = '+91' +
  //             input.substring(1,
  //                 11); //String.format("%s%s", input.substring(0,3), input.substring(3,7));
  //       break;
  //     case 10:
  //       output = '+91' + input;
  //       break;
  //     default:
  //       return input;
  //   }
  //   return output;
  // }

  // void onClickNotificationTriggerWhatsapp(message) {
  //   print('chal ja bhai');
  //   print(message);
  //   // print(json.decode(message));
  //   // var messageId =  json.decode(message).id;
  //   // print(messageId);
  //   // message.content = ;
  //   var decodedMessage = Messageclass().fromJson(json.decode(message));
  //   _processWhatsAppMessage(decodedMessage);
  // }
  //
  // void _processWhatsAppMessage(Message message) async {
  //   String baseURL = "https://api.whatsapp.com/send?phone=";
  //   // var url =
  //   //     "${baseURL}${FormatStringAsPhoneNumber(message.endpoint.split(" ").join(""))}&text=${message.content}";
  //   // AndroidIntent intent = AndroidIntent(
  //   //     action: 'action_view',
  //   //     data: Uri.encodeFull(url),
  //   //     package: "com.whatsapp");
  //   // print(intent.toString());
  //   // print(url);
  //   // print("url");
  //   // print(message.mailAttachment);
  //   // await intent.launch();
  //   try {
  //     print('qweuiop');
  //     final String result = await platform.invokeMethod('getBatteryLevel', {
  //       "endpoint":
  //       FormatStringAsPhoneNumber(message.endpoint.split(" ").join("")),
  //       "content": message.content,
  //       "attachment": message.mailAttachment
  //     });
  //     print('poiuytr');
  //     print(result);
  //     if (result == 'done') {
  //       message.status = MessageStatus.SENT;
  //       message.attempts++;
  //       print(message.status);
  //       _ctrlMsg.sink.add(message);
  //     }
  //   } on PlatformException catch (e) {
  //     print('exception');
  //     print(e.message);
  //   }
  // }
  //
  // void _processEmail(Messagec message1) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String username = message1.mailId;
  //   String password = message1.mailPassword;
  //   String host = message1.mailHost;
  //   var smtpServer = gmail(username, password);
  //   if (message1.mailHost == 'Yahoo') {
  //     smtpServer = yahoo(username, password);
  //   } else if (message1.mailHost == 'Hotmail') {
  //     smtpServer = hotmail(username, password);
  //   }
  //   print('the recipient');
  //   print(username);
  //   print(password);
  //   print(message1);
  //   var message = mailer.Message()
  //     ..from = mailer.Address(username, username)
  //     ..recipients.add(message1.endpoint)
  //   // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
  //   // ..bccRecipients.add(mailer.Address('bccAddress@example.com'))
  //     ..subject = message1.subject
  //     ..text = message1.content;
  //   if (message1.mailAttachment != '') {
  //     File file = new File(message1.mailAttachment);
  //     message = mailer.Message()
  //       ..from = mailer.Address(username, username)
  //       ..recipients.add(message1.endpoint)
  //       ..attachments.add(mailer.FileAttachment(file))
  //     // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
  //     // ..bccRecipients.add(mailer.Address('bccAddress@example.com'))
  //       ..subject = message1.subject
  //       ..text = message1.content;
  //   }
  //
  //   print(mailer.Address(username));
  //   print(message1.endpoint);
  //   print(message1.subject);
  //   print(message1.content);
  //
  //   try {
  //     final sendReport = await mailer.send(message, smtpServer);
  //     message1.status = MessageStatus.SENT;
  //     message1.attempts++;
  //     _ctrlMsg.sink.add(message1);
  //     print('Message sent: ' + sendReport.toString());
  //   } on mailer.MailerException catch (e) {
  //     print('Message not sent.');
  //     print(e);
  //
  //     message1.status = MessageStatus.FAILED;
  //     message1.attempts++;
  //     _ctrlMsg.sink.add(message1);
  //     for (var p in e.problems) {
  //       print('Problem: ${p.code}: ${p.msg}');
  //     }
  //   }
  //   // final Email email = Email(
  //   //   body: 'Email body',
  //   //   subject: 'Email subject',
  //   //   recipients: ['pateldhawal4@gmail.com', message.endpoint],
  //   //   // cc: ['cc@example.com'],
  //   //   // bcc: ['bcc@example.com'],
  //   //   // attachmentPaths: ['/path/to/attachment.zip'],
  //   //   isHTML: false,
  //   // );
  //
  //   // await FlutterEmailSender.send(email);
  // }
  //

    // final int simSlot =

    // final Settings settings = await SettingsProvider.getInstance().getSettings();



  // void _triggershowNotificationWithDefaultSound(Message message) async {
  //   print("message.endpoint");
  //
  //   print(message.endpoint);
  //   _ctrlNotification.sink.add(message);
  // }

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
