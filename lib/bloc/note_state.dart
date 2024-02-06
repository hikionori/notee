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

class NoteInitial extends NoteState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class NoteLoading extends NoteState with EquatableMixin {
  @override
  List<Object> get props => [];
}

class NoteLoaded extends NoteState with EquatableMixin {
  final List<Note> notes;

  NoteLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

class NoteError extends NoteState with EquatableMixin {
  final String message;

  NoteError(this.message);

  @override
  List<Object> get props => [message];
}
