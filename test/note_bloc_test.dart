import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notee/bloc/note_bloc.dart';
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
  late NoteBloc noteBloc;
  late NoteStore noteStore;

  setUp(() async {
    PathProviderPlatform.instance = MockPathProviderPlatform();
    SharedPreferences.setMockInitialValues({});
    await Hive.initFlutter();
    await Hive.openBox<Map>("notes");
    noteStore = NoteStore();
    noteBloc = NoteBloc();
  });

  tearDown(() async {
    await Hive.close();
    noteBloc.close();
    await Directory('test/test_data').delete(recursive: true);
  });

  blocTest<NoteBloc, NoteState>(
    'emits [NoteLoading, NoteLoaded] when LoadNotesEvent is added',
    build: () => noteBloc,
    act: (bloc) => bloc.add(LoadNotesEvent()),
    expect: () => [NoteLoadingState(), NoteLoadedState(noteStore.notes)],
  );

  blocTest<NoteBloc, NoteState>(
    'emits [NoteLoaded] when AddNoteEvent is added',
    build: () => noteBloc,
    act: (bloc) => bloc.add(AddNoteEvent('Test Title', 'Test Content')),
    expect: () => [NoteLoadedState(noteStore.notes)],
  );

  blocTest<NoteBloc, NoteState>(
    'emits [NoteLoaded] when UpdateNoteEvent is added',
    build: () => noteBloc,
    act: (bloc) {
      noteStore.add('Test Title', 'Test Content');
      bloc.add(UpdateNoteEvent(1, 'Updated Title', 'Updated Content'));
    },
    expect: () => [NoteLoadedState(noteStore.notes)],
  );

  blocTest<NoteBloc, NoteState>(
    'emits [NoteLoaded] when DeleteNoteEvent is added',
    build: () => noteBloc,
    act: (bloc) {
      noteStore.add('Test Title', 'Test Content');
      bloc.add(DeleteNoteEvent(1));
    },
    expect: () => [NoteLoadedState(noteStore.notes)],
  );

  blocTest<NoteBloc, NoteState>(
    'emits [NoteLoaded] when SearchNoteEvent is added',
    build: () => noteBloc,
    act: (bloc) {
      noteStore.add('Test Title', 'Test Content');
      bloc.add(SearchNoteEvent('Test'));
    },
    expect: () => [NoteLoadedState(noteStore.notes)],
  );

  blocTest<NoteBloc, NoteState>('emits [NoteLoaded] when GetNoteEvent is added',
      build: () => noteBloc,
      act: (bloc) {
        noteStore.add('Test Title', 'Test Content');
        bloc.add(GetNoteEvent(1));
      },
      expect: () {
        final note = noteStore.get(1);
        if (note != null) {
          return [
            NoteLoadedState([note])
          ];
        } else {
          fail('Note not found');
        }
      });

  blocTest<NoteBloc, NoteState>(
    'emits [NoteError] when GetNoteEvent is added with non-existing id',
    build: () => noteBloc,
    act: (bloc) => bloc.add(GetNoteEvent(999)),
    expect: () => [NoteErrorState('Note not found')],
  );
}
