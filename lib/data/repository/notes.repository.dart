import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tritek_lms/data/entity/note.dart';
import 'package:tritek_lms/data/repository/user.repository.dart';
import 'package:tritek_lms/database/app.db.dart';
import 'package:tritek_lms/http/notes.http.dart';
import 'package:tritek_lms/http/user.dart';

class NoteRepository {
  final _apiProvider = NoteApiProvider();
  final _userRepository = UserRepository();

  Future<List<Notes>> getNotes() async {
    bool conn = await DataConnectionChecker().hasConnection;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int noteResp = prefs.getInt('noteResp') ?? 0;

    UserResponse user = await _userRepository.getDbUser();
    if ((!conn && noteResp > 0) || user.results == null) {
      final database = await AppDB().getDatabase();
      final noteDao = database.notesDao;

      return await noteDao.findAll();
    }

    NotesResponse response = await _apiProvider.getNotes();

    if (response.length != noteResp && response.results != null) {
      await saveNotes(response.results);
      await prefs.setInt('noteResp', response.length);
    } else if (response.results == null) {
      debugPrint('Api get note error');
      final database = await AppDB().getDatabase();
      final noteDao = database.notesDao;

      return await noteDao.findAll();
    }

    return response.results;
  }

  Future<Notes> save(Notes note) async {
    // NoteResponse resp = await _apiProvider.editNotes(note);
    // if (resp.result != null) {
    //   await saveDB(resp.result);
    // } else {
    await saveDB(note);
    // }

    return note;
  }

  Future<void> syncNotes() async {
    UserResponse user = await _userRepository.getDbUser();
    if (user.results == null) {
      print('Sycing Notes: User not found');
      return;
    }
    print('Sycing Notes');
    final database = await AppDB().getDatabase();
    final noteDao = database.notesDao;

    List<Notes> notes = await noteDao.findNotSynced();
    if (notes.length > 0) {
      NotesResponse resp = await _apiProvider.syncNotes(notes);
      if (resp.results != null) {
        await saveNotes(resp.results);
      }
    }
  }

  Future<List<Notes>> getByLessonId(int id) async {
    final database = await AppDB().getDatabase();
    final noteDao = database.notesDao;

    return await noteDao.findByLessonId(id);
  }

  Future<List<Notes>> getBySectionId(int id) async {
    final database = await AppDB().getDatabase();
    final noteDao = database.notesDao;

    return await noteDao.findBySectionId(id);
  }

  Future<List<Notes>> getByCourseId(int id) async {
    final database = await AppDB().getDatabase();
    final noteDao = database.notesDao;

    return await noteDao.findByCourseId(id);
  }

  Future<List<Notes>> search(String term) async {
    final database = await AppDB().getDatabase();
    final noteDao = database.notesDao;

    return await noteDao.search('%' + term + '%');
  }

  Future<void> saveDB(Notes note) async {
    final database = await AppDB().getDatabase();
    final noteDao = database.notesDao;

    await noteDao.save(note);
  }

  Future<void> saveNotes(List<Notes> notes) async {
    for (Notes note in notes) {
      await saveDB(note);
    }
  }

  Future<Notes> update(Notes note) async {
    NoteResponse resp = await _apiProvider.editNotes(note);

    if (resp.result != null) {
      note = resp.result;
    }

    final database = await AppDB().getDatabase();
    final noteDao = database.notesDao;
    int id = await noteDao.update(note);
    note.id = id;
    return note;
  }

  Future<Notes> delete(Notes note) async {
    await _apiProvider.deleteNotes(note);

    final database = await AppDB().getDatabase();
    final noteDao = database.notesDao;
    await noteDao.delete(note.id);

    return note;
  }

  Future<void> deleteAll() async {
    final database = await AppDB().getDatabase();
    final noteDao = database.notesDao;
    noteDao.deleteAll();
  }
}
