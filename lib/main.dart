import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notee/bloc/note_bloc.dart';
import 'package:notee/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isBoxOpen("notes")) {
    await Hive.openBox<Map>("notes");
  }
  runApp(const NoteeApp());
}

class NoteeApp extends StatelessWidget {
  const NoteeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteBloc(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Notee',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        darkTheme: ThemeData.dark(),
        routerConfig: router,
      ),
    );
  }
}
