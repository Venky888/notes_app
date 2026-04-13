import 'package:notes_app/features/notes/model/note_model.dart';
import 'package:notes_app/features/notes/repository/notes_repository.dart';

class TestNotesRepository extends NotesRepository {
  List<Note> notes = [];

  @override
  Future<List<Note>> getNotes() async => notes;

  @override
  Future<void> addNote(Note note) async {
    notes.add(note);
  }

  @override
  Future<void> deleteNote(String id) async {
    notes.removeWhere((n) => n.id == id);
  }

  @override
  Future<void> updateNote(Note note) async {
    final index = notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      notes[index] = note;
    }
  }
}
