import 'dart:io';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tritek_lms/custom/helper.dart';
import 'package:tritek_lms/data/entity/users.dart';
import 'package:tritek_lms/data/repository/course.repository.dart';
import 'package:tritek_lms/database/app.db.dart';
import 'package:tritek_lms/http/http.client.dart';
import 'package:tritek_lms/http/user.dart';

class UserRepository {
  UserApiProvider _apiProvider = UserApiProvider();

  Future<UserResponse> login(String username, String password) async {
    UserResponse response = await _apiProvider.loginUser(username, password);

    if (response.results != null) {
      await HttpClient.setToken(response.results.password);
      await saveUser(response.results);
      getUserLevel(response.results.id);

      if (response.results.image != null && response.results.image.length > 0) {
        try {
          await SaveFile().saveImage(response.results.image);
        } catch (e) {
          print('Image Get Error: ' + e.toString());
        }
      }
    }

    return response;
  }

  Future<RegisterResponse> register(String username, String password,
      String firstName, String lastName, String phoneNo, String email) async {
    RegisterResponse response = await _apiProvider.register(
        username, password, firstName, lastName, phoneNo, email);

    return response;
  }

  Future<RegisterResponse> resetPassword(String email) async {
    RegisterResponse response = await _apiProvider.resetPassword(email);

    return response;
  }

  Future<RegisterResponse> setNewPassword(
      String email, String password, String otp) async {
    RegisterResponse response =
        await _apiProvider.setNewPassword(email, password, otp);

    return response;
  }

  Future<UserResponse> getUser() async {
    final UserResponse response = await _apiProvider.getUser();
    if (response.results != null) {
      await saveUser(response.results);
    }
    return response;
  }

  Future<RegisterResponse> changePassword(
      String email, String password, String oldPassword) async {
    RegisterResponse response =
        await _apiProvider.changePassword(email, password, oldPassword);

    return response;
  }

  Future<UserResponse> verify(String otp, String email) async {
    UserResponse response = await _apiProvider.verify(otp, email);

    if (response.results != null) {
      await HttpClient.setToken(response.results.password);
      await saveUser(response.results);

      if (response.results.image != null && response.results.image.length > 0) {
        SaveFile().saveImage(response.results.image);
      }
    }

    return response;
  }

  Future<UserResponse> editUser(Users _user) async {
    UserResponse response = await _apiProvider.editUser(_user);

    if (response.results != null) {
      await saveUser(response.results);

      if (response.results.image != null && response.results.image.length > 0) {
        SaveFile().saveImage(response.results.image);
      }
    }

    return response;
  }

  Future<UserResponse> getDbUser() async {
    // UserResponse resp = await getUser();
    // if (resp.results != null) {
    //   await saveUser(resp.results);
    //
    //   return resp;
    // }

    final database = await AppDB().getDatabase();
    final userDao = database.userDao;

    final Users user = await userDao.findAll();

    UserResponse response = UserResponse(user, '', 0, '');
    return response;
  }

  Future<UserLevelResponse> getUserLevel(int userId) async {
    bool conn = await DataConnectionChecker().hasConnection;
    if (!conn) {
      final database = await AppDB().getDatabase();
      final userLevelDao = database.userLevelDao;
      final logDao = database.levelLogsDao;

      final UserLevel level = await userLevelDao.findAll();
      final logs = await logDao.findAll();

      level.logs = logs;
      UserLevelResponse response = UserLevelResponse(level, '', 0, '');
      return response;
    }

    final UserLevelResponse level = await _apiProvider.getLevel(userId);
    if (level.data != null) {
      saveUserLevel(level.data);
    }
    return level;
  }

  Future<UserResponse> logout() async {
    await refreshUser();
    return null;
  }

  Future<void> saveUser(Users user) async {
    final database = await AppDB().getDatabase();
    final userDao = database.userDao;

    await userDao.deleteAll();
    userDao.save(user);
  }

  Future<void> saveUserLevel(UserLevel level) async {
    final database = await AppDB().getDatabase();
    final userDao = database.userLevelDao;
    final levelLog = database.levelLogsDao;

    await userDao.deleteAll();
    userDao.save(level);

    await levelLog.deleteAll();
    await levelLog.saveAll(level.logs);
  }

  Future<void> refreshUser() async {
    final database = await AppDB().getDatabase();
    final userDao = database.userDao;
    final notesDao = database.notesDao;
    final userLevelDao = database.userLevelDao;
    final levelLogDao = database.levelLogsDao;
    final CourseRepository courseRepository = CourseRepository();

    await userDao.deleteAll();
    await levelLogDao.deleteAll();
    await userLevelDao.deleteAll();
    await notesDao.deleteAll();

    await courseRepository.refreshCourses();
    await HttpClient.removeToken();
    await SaveFile().deleteImage();
  }

  Future<File> getImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String path = prefs.getString('profileImage') ?? null;

    if (path != null) {
      return File(path);
    }
    return null;
  }

  Future<UserResponse> googleLogin(GoogleSignInAccount acc) async {
    UserResponse response = await _apiProvider.loginGoogle(acc);
    final storage = new FlutterSecureStorage();

    if (response.results != null) {
      await saveUser(response.results);
      await storage.write(key: 'token', value: response.results.password);
      getUserLevel(response.results.id);

      if (acc.photoUrl != null) {
        SaveFile().saveImage(acc.photoUrl);
      }
    }

    return response;
  }
}
