
class ObsSignal
{
  String type;
  Map<String, dynamic> parameters;

  ObsSignal(String notifType, Map<String, dynamic> params)
    : type = notifType,
      parameters = params;

}

abstract class Observable
{
  final List<Observer> _observers = [];

  void addObserver( observer)
  {
    _observers.add(observer);
  }

  Future<void> notifyObservers(ObsSignal notification) async
  {
    for (Observer observer in _observers)
    {
      await observer.notify(notification);
    }
  }
}

abstract class Observer
{
  Future<void> notify(ObsSignal notification);
}


class BaseObservable extends Observable
{

}