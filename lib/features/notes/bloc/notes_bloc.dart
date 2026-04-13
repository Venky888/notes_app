import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/features/notes/bloc/notes_events.dart';
import 'package:notes_app/features/notes/bloc/notes_states.dart';
import 'package:notes_app/features/notes/model/note_model.dart';
import 'package:notes_app/features/notes/repository/notes_repository.dart';

class NotesBloc extends Bloc<NotesEvents, NotesStates> {
  final NotesRepository repository;

  String _lastQuery = '';
  bool _isAlphabetical = false;
  bool _isReverse = false;

  NotesBloc({required this.repository}) : super(NotesInitial()) {
    on<FetchNotes>(_onFetch);
    on<AddNote>(_onAdd);
    on<DeleteNote>(_onDelete);
    on<UpdateNote>(_onUpdate);
    on<SearchNotes>(_onSearch);
    on<SortNotes>(_onSort);
  }

  Future<void> _onFetch(FetchNotes event, Emitter<NotesStates> emit) async {
    try {
      emit(NotesLoading());

      final notes = await repository.getNotes();
      final filtered = _applyFilters(notes);

      emit(NotesLoaded(notes, filtered: filtered));
    } catch (e) {
      emit(NotesError(e.toString()));
    }
  }

  Future<void> _onAdd(AddNote event, Emitter emit) async {
    await repository.addNote(event.note);

    final notes = await repository.getNotes();
    final filtered = _applyFilters(notes);

    emit(NotesLoaded(notes, filtered: filtered));
  }

  Future<void> _onDelete(DeleteNote event, Emitter emit) async {
    if (state is NotesLoaded) {
      final current = state as NotesLoaded;

      final updatedNotes = current.notes
          .where((n) => n.id != event.id)
          .toList();

      final filtered = _applyFilters(updatedNotes);

      emit(NotesLoaded(updatedNotes, filtered: filtered));

      await repository.deleteNote(event.id);
    }
  }

  Future<void> _onUpdate(UpdateNote event, Emitter emit) async {
    if (state is NotesLoaded) {
      final current = state as NotesLoaded;

      final updatedNotes = current.notes.map((n) {
        return n.id == event.note.id ? event.note : n;
      }).toList();

      final filtered = _applyFilters(updatedNotes);

      emit(NotesLoaded(updatedNotes, filtered: filtered));

      await repository.updateNote(event.note);
    }
  }

  void _onSearch(SearchNotes event, Emitter emit) {
    if (state is NotesLoaded) {
      final current = state as NotesLoaded;

      _lastQuery = event.query.trim();

      if (_lastQuery.isEmpty) {
        final filtered = _applyFilters(current.notes);
        emit(NotesLoaded(current.notes, filtered: filtered));
        return;
      }

      final filtered = _applyFilters(current.notes);

      emit(NotesLoaded(current.notes, filtered: filtered));
    }
  }

  void _onSort(SortNotes event, Emitter emit) {
    if (state is NotesLoaded) {
      final current = state as NotesLoaded;

      _isAlphabetical = event.alphabetical;
      _isReverse = event.reverse;

      final filtered = _applyFilters(current.notes);

      emit(NotesLoaded(current.notes, filtered: filtered));
    }
  }

  List<Note> _applyFilters(List<Note> notes) {
    List<Note> result = List.from(notes);

    if (_lastQuery.isNotEmpty) {
      final query = _lastQuery.toLowerCase();

      result = result.where((note) {
        return note.title.toLowerCase().contains(query) ||
            note.content.toLowerCase().contains(query);
      }).toList();
    }

    if (_isAlphabetical) {
      result.sort((a, b) => a.title.compareTo(b.title));
    } else if (_isReverse) {
      result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else {
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return result;
  }
}
