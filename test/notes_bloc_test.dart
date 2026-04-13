import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

import 'package:notes_app/features/notes/bloc/notes_bloc.dart';
import 'package:notes_app/features/notes/bloc/notes_events.dart';
import 'package:notes_app/features/notes/bloc/notes_states.dart';
import 'package:notes_app/features/notes/model/note_model.dart';

import 'test_notes_repository.dart';


void main() {
  late NotesBloc bloc;

  setUp(() {
    bloc = NotesBloc(repository: TestNotesRepository());
  });

  test('initial state', () {
    expect(bloc.state, isA<NotesInitial>());
  });

  blocTest<NotesBloc, NotesStates>(
    'FetchNotes should load notes',
    build: () => NotesBloc(repository: TestNotesRepository()),
    act: (bloc) => bloc.add(FetchNotes()),
    expect: () => [isA<NotesLoading>(), isA<NotesLoaded>()],
  );

  blocTest<NotesBloc, NotesStates>(
    'AddNote should add note',
    build: () => NotesBloc(repository: TestNotesRepository()),
    act: (bloc) => bloc.add(
      AddNote(
        Note(
          id: '1',
          title: 'Test',
          content: 'Hello',
          createdAt: DateTime.now(),
        ),
      ),
    ),
    expect: () => [isA<NotesLoading>(), isA<NotesLoaded>()],
  );
}
