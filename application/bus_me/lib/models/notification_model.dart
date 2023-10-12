
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationModel
{
  static final NotificationModel _instance = NotificationModel._internal();

  factory NotificationModel() {
    return _instance;

  }

  NotificationModel._internal();

  final FlutterTts _tts = FlutterTts();
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  int _lastId = 0;
    //map of notifiaction types to function to use


  Future<void> initPushNotifications() async
  {
    const andInitSettings = AndroidInitializationSettings("assets/icons/app-icons/bus-me-logo.png");
    final iosInitSettings = DarwinInitializationSettings();

    await _localNotificationsPlugin.initialize(InitializationSettings(android: andInitSettings, iOS: iosInitSettings, macOS: iosInitSettings));
  }

  final Set<NotifType> _notfiSettings = Set();
  late final Map<NotifType, Future<void> Function(String)> notfiHandlers = {
    NotifType.TTS: _sendTTS,
    NotifType.POPUP: _sendPopup
  };

  Future<void> sendNotification(String str) async
  {
    //loop over notification types and call handlers for each if present
    for (NotifType type in _notfiSettings)
    {
      await notfiHandlers[type]!(str);
    }

  }

  Future<void> _sendTTS(String str) async
  {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5); //speed of speech
    await _tts.setVolume(1.0); //volume of speech
    await _tts.setPitch(1); //pitc of sound

    await _tts.speak(str);
  }

  Future<void> _sendPopup(String str) async
  {
    _localNotificationsPlugin.show(_lastId, "BusME Alert!", str, const NotificationDetails());
    _lastId +=1;

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
  POPUP
}