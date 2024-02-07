part of 'note_bloc.dart';

@immutable
abstract class NoteState implements Comparable<NoteState> {
  @override
  int compareTo(NoteState other) {
    if (runtimeType != other.runtimeType) {
      return runtimeType.toString().compareTo(other.runtimeType.toString());
    }
    return 0;
  }
}

class NoteInitialState extends NoteState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class NoteLoadingState extends NoteState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class NoteLoadedState extends NoteState with EquatableMixin {
  final List<Note> notes;

  NoteLoadedState(this.notes);

  @override
  List<Object> get props => [notes];
}

class NoteErrorState extends NoteState with EquatableMixin {
  final String message;

  NoteErrorState(this.message);

  @override
  List<Object> get props => [message];
}
