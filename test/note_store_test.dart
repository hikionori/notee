// FILEPATH: /home/hikionori/Documents/Projects/notee/test/note_store_test.dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notee/models/note.dart';
import 'package:notee/stores/note_store.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockPathProviderPlatform extends PathProviderPlatform implements Mock {
  @override
  Future<String> getApplicationDocumentsPath() async {
    return './test/test_data';
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final Box<Map> box;
  late final NoteStore noteStore;

  setUpAll(() async {
    PathProviderPlatform.instance = MockPathProviderPlatform();
    SharedPreferences.setMockInitialValues({});

    await Hive.initFlutter();
    box = await Hive.openBox<Map>('notes');
    noteStore = NoteStore();
  });

  tearDownAll(() async {
    await box.clear();
    await box.close();
    await Hive.close();

    // remove test_data directory
    Directory('./test/test_data').deleteSync(recursive: true);
  });

  tearDown(() => box.clear());

  group('NoteStore', () {
    test('should add a note', () {
      noteStore.add('Test Title', 'Test Content');
      expect(noteStore.notes.length, 1);
      expect(noteStore.notes[0].title, 'Test Title');
      expect(noteStore.notes[0].content, 'Test Content');
    });

    test('should get a note by id', () {
      noteStore.add('Test Title', 'Test Content');
      Note? note = noteStore.get(1);
      expect(note, isNotNull);
      expect(note!.title, 'Test Title');
      expect(note.content, 'Test Content');
    });

    test('should return null if note does not exist', () {
      Note? note = noteStore.get(999);
      expect(note, isNull);
    });

    test('should update a note', () {
      noteStore.add('Test Title', 'Test Content');
      noteStore.update(1, 'Updated Title', 'Updated Content');
      Note? note = noteStore.get(1);
      expect(note, isNotNull);
      expect(note!.title, 'Updated Title');
      expect(note.content, 'Updated Content');
    });

    test('should not update a non-existing note', () {
      noteStore.update(999, 'Updated Title', 'Updated Content');
      Note? note = noteStore.get(999);
      expect(note, isNull);
    });

    test('should search for notes by title', () {
      noteStore.add('Test Title', 'Test Content');
      noteStore.add('Another Test Title', 'Another Test Content');
      List<Note> results = noteStore.search('Test Title');
      expect(results.length, 2);
    });

    test('should search for notes by content', () {
      noteStore.add('Test Title', 'Test Content');
      noteStore.add('Another Test Title', 'Another Test Content');
      List<Note> results = noteStore.search('Test Content');
      expect(results.length, 2);
    });

    test('should delete a note', () {
      noteStore.add('Test Title', 'Test Content');
      noteStore.delete(1);
      Note? note = noteStore.get(1);
      expect(note, isNull);
    });

    test('should not throw an error when deleting a non-existing note', () {
      expect(() => noteStore.delete(999), returnsNormally);
    });
  });
}
