import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsBloc {
  final BehaviorSubject<bool> _cellularData = BehaviorSubject<bool>();
  final BehaviorSubject<bool> _notifications = BehaviorSubject<bool>();
  final BehaviorSubject<int> _videoQuality = BehaviorSubject<int>();
  final BehaviorSubject<String> _notificationTime = BehaviorSubject<String>();
  final BehaviorSubject<bool> _frt = BehaviorSubject<bool>();

  BehaviorSubject<bool> get cellularData => _cellularData;

  BehaviorSubject<bool> get notifications => _notifications;

  BehaviorSubject<bool> get frt => _frt;

  BehaviorSubject<String> get notificationTime => _notificationTime;

  BehaviorSubject<int> get videoQuality => _videoQuality;

  getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _cellularData.sink.add(prefs.getBool('cellularData') ?? true);
    _notifications.sink.add(prefs.getBool('notifications') ?? false);
    _frt.sink.add(prefs.getBool('FRT') ?? false);
    _notificationTime.sink.add(prefs.getString('notificationTime') ?? '..:..');
    _videoQuality.sink.add(prefs.getInt('videoQuality') ?? 1);
  }

  setVideoQuality(int q) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('videoQuality', q);
    _videoQuality.sink.add(q);
  }

  setCellularData(bool d) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('cellularData', d);
    _cellularData.sink.add(d);
  }

  setNotifications(bool d) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications', d);
    _notifications.sink.add(d);
  }

  setFRT(bool d) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('FRT', d);
    _frt.sink.add(d);
  }

  setNotificationTime(String t) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('notificationTime', t);
    _notificationTime.sink.add(t);
  }

  dispose() {
    _cellularData.close();
    _notifications.close();
    _frt.close();
    _notificationTime.close();
    _videoQuality.close();
  }
}

final settingsBloc = SettingsBloc();
