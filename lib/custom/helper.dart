import 'dart:async';
import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveFile {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> getImageFromNetwork(String url) async {
    File file = await DefaultCacheManager().getSingleFile(url);
    return file;
  }

  Future<File> saveImage(String url) async {
    final file = await getImageFromNetwork(url);
    //retrieve local path for device
    var path = await _localPath;
    Image image = decodeImage(file.readAsBytesSync());

    Image thumbnail = copyResize(image, width: 120, height: 120);

    // Save the thumbnail as a PNG.
    File savedFile = new File('$path/profile.png')
      ..writeAsBytesSync(encodePng(thumbnail));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profileImage', savedFile.path);

    return savedFile;
  }

  Future<File> saveFile(File file, String prefKey) async {
    //retrieve local path for device
    var path = await _localPath;
    final fileName = basename(file.path);
    final File localImage = await File(file.path).copy('$path/$fileName');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(prefKey, localImage.path);

    return localImage;
  }

  Future<void> deleteImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uri = prefs.getString('profileImage') ?? null;

    if (uri != null) {
      File file = File(uri);
      file.delete();

      prefs.remove('profileImage');
    }
  }
}

class DateFormatter {
  static String stringForDatetime(DateTime dt) {
    var dtInLocal = dt.toLocal();
    var now = DateTime.now().toLocal();
    var dateString = "";

    var diff = now.difference(dtInLocal);

    if (now.day == dtInLocal.day) {
      // creates format like: 12:35 PM,
      var todayFormat = DateFormat("h:mm a");
      dateString += todayFormat.format(dtInLocal);
    } else if ((diff.inDays) == 1 ||
        (diff.inSeconds < 86400 && now.day != dtInLocal.day)) {
      var yesterdayFormat = DateFormat("h:mm a");
      dateString += "Yesterday, " + yesterdayFormat.format(dtInLocal);
    } else if (now.year == dtInLocal.year && diff.inDays > 1) {
      var monthFormat = DateFormat("MMM d");
      dateString += monthFormat.format(dtInLocal);
    } else {
      var yearFormat = DateFormat("MMM d y");
      dateString += yearFormat.format(dtInLocal);
    }

    return dateString;
  }

  static DateTime stringToDate(String date) {
    return new DateFormat("yyyy-MM-dd hh:mm:ss").parse(date);
  }
}
