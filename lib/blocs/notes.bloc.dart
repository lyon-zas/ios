import 'package:rxdart/rxdart.dart';
import 'package:tritek_lms/data/entity/note.dart';
import 'package:tritek_lms/data/repository/notes.repository.dart';

class NotesBloc {
  final NoteRepository _repository = NoteRepository();
  final BehaviorSubject<List<Notes>> _noteSubject =
      BehaviorSubject<List<Notes>>();

  final BehaviorSubject<List<Notes>> _search = BehaviorSubject<List<Notes>>();

  getNotes() async {
    await _repository.syncNotes();
    List<Notes> response = await _repository.getNotes();
    _noteSubject.sink.add(response);
  }

  searchNote(String term) async {
    List<Notes> response = await _repository.search(term);
    _noteSubject.sink.add(response);
  }

  dispose() {
    _noteSubject.close();
    _search.close();
  }

  BehaviorSubject<List<Notes>> get subject => _noteSubject;

  BehaviorSubject<List<Notes>> get search => _search;
}

final noteBloc = NotesBloc();
