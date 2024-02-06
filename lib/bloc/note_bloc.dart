import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notee/models/note.dart';
import 'package:notee/stores/note_store.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteStore _noteStore = NoteStore();
  NoteBloc() : super(NoteInitial()) {
    on<NoteEvent>((event, emit) {
      if (event is LoadNotesEvent) {
        emit(NoteLoading());
        emit(NoteLoaded(_noteStore.notes));
      } else if (event is AddNoteEvent) {
        _noteStore.add(event.title, event.content);
        emit(NoteLoaded(_noteStore.notes));
      } else if (event is UpdateNoteEvent) {
        _noteStore.update(event.id, event.title, event.content);
        emit(NoteLoaded(_noteStore.notes));
      } else if (event is DeleteNoteEvent) {
        _noteStore.delete(event.id);
        emit(NoteLoaded(_noteStore.notes));
      } else if (event is SearchNoteEvent) {
        emit(NoteLoaded(_noteStore.search(event.query)));
      } else if (event is GetNoteEvent) {
        final note = _noteStore.get(event.id);
        if (note != null) {
          emit(NoteLoaded([note]));
        } else {
          emit(NoteError('Note not found'));
        }
      } else {
        emit(NoteError('Unknown event'));
      }
    });
  }
}
