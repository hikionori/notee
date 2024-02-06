import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notee/bloc/note_bloc.dart';

class ViewEditNotePage extends StatefulWidget {
  const ViewEditNotePage({super.key});

  @override
  State<ViewEditNotePage> createState() => _ViewEditNotePageState();
}

class _ViewEditNotePageState extends State<ViewEditNotePage> {
  late int id;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: editMode
            ? const Text("Редактувати нотатку")
            : const Text("Перегляд нотатки"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // navigate to edit note page
              setState(() {
                editMode = !editMode;
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (editMode) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: "Content",
                    ),
                    maxLines: 10,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // update note
                      BlocProvider.of<NoteBloc>(context).add(UpdateNoteEvent(
                        id,
                        _titleController.text,
                        _contentController.text,
                      ));
                      setState(() {
                        editMode = !editMode;
                      });
                    },
                    child: const Text("Update"),
                  ),
                ],
              ),
            );
          } else {
            if (state is NoteLoaded) {
              final note =
                  state.notes.firstWhere((element) => element.id == id);
              _titleController.text = note.title;
              _contentController.text = note.content;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note.content,
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}