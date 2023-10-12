
import 'package:flutter_tts/flutter_tts.dart';

class NotificationModel
{
  final FlutterTts _tts = FlutterTts();

  NotificationModel()
  {
    //map of notifiaction types to function to use
    notfiHandlers = {
      NotifType.TTS: _sendTTS,
      NotifType.POPUP: _sendPopup
    };


  }

  final Set<NotifType> _notfiSettings = Set();
  late final Map<NotifType, Future<void> Function(String)> notfiHandlers;

  void sendNotification(String str) async
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