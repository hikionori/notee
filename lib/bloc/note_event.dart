part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

class LoadNotesEvent extends NoteEvent {}

class AddNoteEvent extends NoteEvent {
  final String title;
  final String content;

  AddNoteEvent(this.title, this.content);
}

class UpdateNoteEvent extends NoteEvent {
  final int id;
  final String title;
  final String content;

  UpdateNoteEvent(this.id, this.title, this.content);
}

class DeleteNoteEvent extends NoteEvent {
  final int id;

  DeleteNoteEvent(this.id);
}

class SearchNoteEvent extends NoteEvent {
  final String query;

  SearchNoteEvent(this.query);
}

class GetNoteEvent extends NoteEvent {
  final int id;

  GetNoteEvent(this.id);
}
