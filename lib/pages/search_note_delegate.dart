import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notee/bloc/note_bloc.dart';

class SearchNoteDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state is NoteLoaded) {
          final notes = state.notes;
          final filteredNotes = notes
              .where((element) =>
                  element.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final note = filteredNotes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(
                  note.content.length >= 20
                      ? "${note.content.substring(0, 20)}..."
                      : note.content,
                ),
                onTap: () {
                  close(context, note.id);
                  Navigator.of(context).pushNamed(
                    '/view_edit',
                    arguments: note.id,
                  );
                },
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        if (state is NoteLoaded) {
          final notes = state.notes;
          final filteredNotes = notes
              .where((element) =>
                  element.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final note = filteredNotes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(
                  note.content.length >= 20
                      ? "${note.content.substring(0, 20)}..."
                      : note.content,
                ),
                onTap: () {
                  query = note.title;
                  close(context, note.id);
                  Navigator.of(context).pushNamed(
                    '/view_edit',
                    arguments: note.id,
                  );
                },
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
