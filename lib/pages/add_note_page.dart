// Page where user can add a note

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:notee/bloc/note_bloc.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Нова нотатка"),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => GoRouter.of(context).go("/")),
      ),
      body: Column(children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: titleController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Назва",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: contentController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Зміст",
              alignLabelWithHint: true,
            ),
            maxLines: 10,
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            final title = titleController.text;
            final content = contentController.text;

            BlocProvider.of<NoteBloc>(context)
                .add(AddNoteEvent(title, content));
            GoRouter.of(context).go("/");
          },
          child: const Text("Зберегти"),
        ),
      ]),
    );
  }
}
