
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationModel
{
  static final NotificationModel _instance = NotificationModel._internal();

  factory NotificationModel() {
    WidgetsFlutterBinding.ensureInitialized();
    return _instance;

  }

  NotificationModel._internal();

  late final FlutterTts _tts;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  int _lastId = 0;
    //map of notifiaction types to function to use


  Future<void> initNotifications() async
  {
    WidgetsFlutterBinding.ensureInitialized();
    _tts = FlutterTts();
    const andInitSettings = AndroidInitializationSettings("assets/icons/app-icons/bus-me-logo.png");
    final iosInitSettings = DarwinInitializationSettings();

    await _localNotificationsPlugin.initialize(InitializationSettings(android: andInitSettings, iOS: iosInitSettings, macOS: iosInitSettings));
  }

  final Set<NotifType> _notfiSettings = Set();

  late final Map<NotifType, Future<void> Function(String, BuildContext? context)> notfiHandlers = {
    NotifType.TTS: _sendTTS,
    NotifType.POPUP: _sendPopup,
    NotifType.ALERT: _sendAlert
  };

  Future<void> sendNotification(String str, BuildContext? context) async
  {
    await Future.forEach(_notfiSettings, (element)  async {
      notfiHandlers[element]!(str, context);
    });
    //loop over notification types and call handlers for each if present

  }

  Future<void> _sendTTS(String str, BuildContext? context) async
  {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5); //speed of speech
    await _tts.setVolume(1.0); //volume of speech
    await _tts.setPitch(1); //pitch of sound

    await _tts.speak(str);
  }

  Future<void> _sendPopup(String str, BuildContext? context) async
  {
    _localNotificationsPlugin.show(_lastId, "BusME Alert!", str, const NotificationDetails());
    _lastId +=1;

  }

  Future<void> _sendAlert(String str, BuildContext? context) async
  {
    return showDialog(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('BusME Alert!'),
          content: Text(str),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void addNotifType(NotifType type)
  {
    _notfiSettings.add(type);
  }

  void removeNotifType(NotifType type)
  {
    _notfiSettings.remove(type);
  }

}

enum NotifType
{
  TTS,
  POPUP,
  ALERT
}