import 'package:hive/hive.dart';
import 'package:notes_app/features/notes/model/note_model.dart';

class NotesRepository {
  final Box box = Hive.box('notesBox');

  Future<List<Note>> getNotes() async {
    return box.values.map((e) => Note.fromMap(Map.from(e))).toList();
  }

  Future<void> addNote(Note note) async {
    await box.put(note.id, note.toMap());
  }

  Future<void> deleteNote(String id) async {
    await box.delete(id);
  }

  Future<void> updateNote(Note note) async {
    await box.put(note.id, note.toMap());
  }
}
