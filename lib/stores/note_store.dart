import 'package:hive_flutter/adapters.dart';
import 'package:notee/models/note.dart';

class NoteStore {
  final Box<Map> _box = Hive.box("notes");

  List<Note> get notes =>
      _box.values.map((e) => Note.fromJson(convertMap(e))).toList();

  Note? get(int id) {
    final note = _box.get(id);
    if (note != null) {
      return Note.fromJson(note as Map<String, dynamic>);
    }
    return null;
  }

  void add(String title, String content) {
    final note = Note(
      id: _box.values.length + 1,
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    _box.put(note.id, note.toJson());
  }

  void update(int id, String title, String content) {
    final note = get(id);
    if (note != null) {
      note.title = title;
      note.content = content;
      _box.put(note.id, note.toJson());
    }
  }

  // search for notes
  List<Note> search(String query) {
    return notes.where((note) {
      return note.title.toLowerCase().contains(query.toLowerCase()) ||
          note.content.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void delete(int id) {
    _box.delete(id);
  }
}

Map<String, dynamic> convertMap(Map<dynamic, dynamic> map) {
  return map.map((key, value) {
    return MapEntry(key.toString(), value);
  });
}
