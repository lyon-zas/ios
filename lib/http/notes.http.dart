import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:tritek_lms/data/entity/note.dart';
import 'package:tritek_lms/http/endpoints.dart';
import 'package:tritek_lms/http/http.client.dart';

class NotesResponse {
  final List<Notes> results;
  final int length;
  final String error;
  final String eTitle;

  NotesResponse(this.results, this.length, this.error, this.eTitle);

  NotesResponse.fromJson(json, length)
      : results = (json as List).map((i) => new Notes.fromJson(i)).toList(),
        length = length,
        error = "",
        eTitle = "";

  NotesResponse.withError(String msg, String title)
      : results = null,
        length = 0,
        error = msg,
        eTitle = title;
}

class NoteResponse {
  final Notes result;
  final String error;
  final String eTitle;

  NoteResponse(this.result, this.error, this.eTitle);

  NoteResponse.fromJson(json)
      : result = Notes.fromJson(json),
        error = "",
        eTitle = "";

  NoteResponse.withError(String msg, String title)
      : result = null,
        error = msg,
        eTitle = title;
}

class NoteApiProvider {
  Future<NotesResponse> getNotes() async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.get(notesEndpoint,
          options: Options(method: 'GET', responseType: ResponseType.plain));
      return NotesResponse.fromJson(
          json.decode(response.data), response.data.length);
    } catch (e) {
      print(e.message);
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return NotesResponse.withError(error['message'], error['error']);
      }
      return NotesResponse.withError(
          "Network Error. Please check your network connection",
          "Network Error");
    }
  }

  Future<NoteResponse> editNotes(Notes note) async {
    try {
      final Dio _dio = await HttpClient.http();
      Response response =
          await _dio.put(editNoteEndpoint, data: note.toJson(true));
      return NoteResponse.fromJson(response.data);
    } catch (e) {
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return NoteResponse.withError(error['message'], error['error']);
      }
      print(e.message);
      return NoteResponse.withError(
          "Network Error. Please check your network connection",
          "Network Error");
    }
  }

  Future<NotesResponse> syncNotes(List<Notes> notes) async {
    var req = [];
    for (Notes note in notes) {
      req.add(note.toJson(true));
    }
    try {
      final Dio _dio = await HttpClient.http();
      Response response = await _dio.patch(syncNoteEndpoint, data: req);
      return NotesResponse.fromJson(response.data, 0);
    } catch (e) {
      print('sycn error: ${e.message}');
      if (e.response != null) {
        Map<String, dynamic> error = json.decode(e.response.toString());
        return NotesResponse.withError(error['message'], error['error']);
      }

      print('Network Error: ${e.message}');
      return NotesResponse.withError(
          "Network Error. Please check your network connection",
          "Network Error");
    }
  }

  Future<bool> deleteNotes(Notes note) async {
    try {
      final Dio _dio = await HttpClient.http();
      await _dio.delete(deleteNoteEndpoint + note.id.toString());
      print('Note Deleted');
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteAllNotes() async {
    try {
      final Dio _dio = await HttpClient.http();
      await _dio.delete(deleteAllNotesEndpoint);
      return true;
    } catch (e) {
      return false;
    }
  }
}
