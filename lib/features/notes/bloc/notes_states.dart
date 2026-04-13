import 'package:equatable/equatable.dart';
import 'package:notes_app/features/notes/model/note_model.dart';


abstract class NotesStates extends Equatable {
  const NotesStates();

  @override
  List<Object?> get props => [];
}

class NotesInitial extends NotesStates {}

class NotesLoading extends NotesStates {}

class NotesLoaded extends NotesStates {
  final List<Note> notes;
  final List<Note> filtered;
  final bool isRefreshing;

  const NotesLoaded(
    this.notes, {
    List<Note>? filtered,
    this.isRefreshing = false,
  }) : filtered = filtered ?? notes; // ✅ FIX HERE

  @override
  List<Object?> get props => [notes, filtered, isRefreshing];
}

class NotesError extends NotesStates {
  final String message;

  const NotesError(this.message);
}
