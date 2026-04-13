import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:notes_app/features/notes/bloc/notes_bloc.dart';
import 'package:notes_app/features/notes/bloc/notes_events.dart';
import 'package:notes_app/features/notes/repository/notes_repository.dart';
import 'package:notes_app/features/notes/screen/notes_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('notesBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (_) =>
            NotesBloc(repository: NotesRepository())..add(FetchNotes()),
        child: const NotesScreen(),
      ),
    );
  }
}
