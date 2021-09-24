import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tritek_lms/data/repository/user.repository.dart';
import 'package:tritek_lms/http/ping.dart';
import 'package:tritek_lms/http/user.dart';

class UserBloc {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final UserRepository _repository = UserRepository();
  final PingResponse _pingResponse = PingResponse();

  final BehaviorSubject<UserResponse> _userSubject =
      BehaviorSubject<UserResponse>();

  final BehaviorSubject<PingServerResp> _pingSubject =
      BehaviorSubject<PingServerResp>();

  final BehaviorSubject<bool> _userStatus = BehaviorSubject<bool>();
  final BehaviorSubject<String> _token = BehaviorSubject<String>();
  final BehaviorSubject<File> _image = BehaviorSubject<File>();
  final BehaviorSubject<UserLevelResponse> _userLevel =
      BehaviorSubject<UserLevelResponse>();

  login(String username, String password) async {
    UserResponse response = await _repository.login(username, password);
    _userSubject.sink.add(response);
  }

  bool _isDisposed = false;

  dispose() {
    _userSubject.close();
    _userStatus.close();
    _userLevel.close();
    _pingSubject.close();
    _token.close();
    _image.close();
    _isDisposed = true;
  }

  void drainStream() {
    _userSubject.isClosed ? null : _userSubject.value = null;
    _userStatus.isClosed ? null : _userStatus.value = null;
    _userLevel.isClosed ? null : _userLevel.value = null;
    _token.isClosed ? null : _token.value = null;
  }

  BehaviorSubject<UserResponse> get userSubject => _userSubject;

  BehaviorSubject<String> get token => _token;

  BehaviorSubject<UserLevelResponse> get userLevel => _userLevel;

  BehaviorSubject<bool> get userStatus => _userStatus;

  BehaviorSubject<PingServerResp> get pingSubject => _pingSubject;

  BehaviorSubject<File> get image => _image;

  void getUser() async {
    updateUser();
    UserResponse resp = await _repository.getDbUser();
    if (_isDisposed) {
      return;
    }
    _userSubject.sink.add(resp);
    _userStatus.sink.add(resp.results != null);
  }

  void updateUser() async {
    UserResponse resp = await _repository.getUser();
    if (_isDisposed) {
      return;
    }

    if (resp.results != null) {
      _userSubject.sink.add(resp);
    }
  }

  void getToken() async {
    var t = await _storage.read(key: 'token') ?? null;
    _token.sink.add(t);
  }

  void getImage() async {
    var t = await _repository.getImage();

    // if (_image.isClosed) {
    //   return;
    // }
    _image.sink.add(t);
  }

  void getUserLevel(userId) async {
    UserLevelResponse resp = await _repository.getUserLevel(userId);
    _userLevel.sink.add(resp);
  }

  void pingServer() async {
    PingServerResp resp = await _pingResponse.pingServer();
    if (_pingSubject.isClosed) {
      return;
    }
    _pingSubject.sink.add(resp);
  }

  Future<bool> logout() async {
    await _repository.logout();
    _userSubject.sink.add(null);
    return true;
  }
}

final userBloc = UserBloc();
