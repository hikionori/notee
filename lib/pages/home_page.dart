import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notee/bloc/note_bloc.dart';
import 'package:notee/pages/search_note_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // fetch notes
    BlocProvider.of<NoteBloc>(context).add(LoadNotesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notee"),
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // show search dialog
                showSearch(context: context, delegate: SearchNoteDelegate());
              }),
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoaded) {
            final notes = state.notes;
            return ListView.builder(
              // reload list when user pull down
              physics: const AlwaysScrollableScrollPhysics(),

              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                // return list item with note title and content, and button for delete
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.content,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Видалити нотатку?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Ні"),
                              ),
                              TextButton(
                                onPressed: () {
                                  // delete note
                                  BlocProvider.of<NoteBloc>(context)
                                      .add(DeleteNoteEvent(note.id));
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Так"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  onTap: () {
                    GoRouter.of(context).go('/view_edit/${note.id}');
                  },
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go('/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
