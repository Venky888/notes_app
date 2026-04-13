import 'package:equatable/equatable.dart';
import 'package:notes_app/features/notes/model/note_model.dart';

abstract class NotesEvents extends Equatable {
  const NotesEvents();

  @override
  List<Object?> get props => [];
}

class FetchNotes extends NotesEvents {}

class AddNote extends NotesEvents {
  final Note note;
  const AddNote(this.note);
}

class DeleteNote extends NotesEvents {
  final String id;
  const DeleteNote(this.id);
}

class UpdateNote extends NotesEvents {
  final Note note;
  const UpdateNote(this.note);
}

class SearchNotes extends NotesEvents {
  final String query;
  const SearchNotes(this.query);
}

class SortNotes extends NotesEvents {
  final bool reverse;
  final bool alphabetical;

  const SortNotes({this.reverse = false, this.alphabetical = false});
}
