import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:notee/models/note.dart';
import 'package:notee/stores/note_store.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {

  /// The code you provided is the constructor of the `NoteBloc` class.
  final NoteStore noteStore = NoteStore();

  NoteBloc() : super(NoteInitial()) {
    on<NoteEvent>((event, emit) {
      switch (event.runtimeType) {
        case LoadNotesEvent:
          _loadNotes(emit);
          break;
        case AddNoteEvent:
          _addNoteEvent(event as AddNoteEvent, emit);
          break;
        case UpdateNoteEvent:
          _updateNoteEvent(event as UpdateNoteEvent, emit);
          break;
        case DeleteNoteEvent:
          _deleteNoteEvent(event as DeleteNoteEvent, emit);
          break;
        case SearchNoteEvent:
          _searchNoteEvent(event as SearchNoteEvent, emit);
          break;
        case GetNoteEvent:
          _getNoteEvent(event as GetNoteEvent, emit);
          break;
        default:
          emit(NoteError('Unknown event'));
      }
    });
  }

  void _loadNotes(Emitter<NoteState> emit) {
    emit(NoteLoading());
    emit(NoteLoaded(noteStore.notes
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt))));
  }

  void _addNoteEvent(AddNoteEvent event, Emitter<NoteState> emit) {
    noteStore.add(event.title, event.content);
    emit(NoteLoaded(noteStore.notes
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt))));
  }

  void _updateNoteEvent(UpdateNoteEvent event, Emitter<NoteState> emit) {
    noteStore.update(event.id, event.title, event.content);
    emit(NoteLoaded(noteStore.notes
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt))));
  }

  void _deleteNoteEvent(DeleteNoteEvent event, Emitter<NoteState> emit) {
    noteStore.delete(event.id);
    emit(NoteLoaded(noteStore.notes
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt))));
  }

  void _searchNoteEvent(SearchNoteEvent event, Emitter<NoteState> emit) {
    emit(NoteLoaded(noteStore.search(event.query)));
  }

  void _getNoteEvent(GetNoteEvent event, Emitter<NoteState> emit) {
    final note = noteStore.get(event.id);
    if (note != null) {
      emit(NoteLoaded([note]));
    } else {
      emit(NoteError('Note not found'));
    }
  }

}
