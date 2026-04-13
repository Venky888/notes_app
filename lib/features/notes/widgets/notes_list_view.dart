import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/constants/app_colors.dart';
import 'package:notes_app/features/notes/model/note_model.dart';
import 'package:notes_app/features/notes/widgets/note_card.dart';
import 'package:notes_app/features/notes/widgets/note_input_sheet.dart';
import 'package:notes_app/features/notes/bloc/notes_bloc.dart';
import 'package:notes_app/features/notes/bloc/notes_events.dart';

class NotesListView extends StatelessWidget {
  final List<Note> notes;
  final Future<void> Function() onRefresh;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: notes.isEmpty
          ? Center(
              child: Text(
                "No Notes Yet ",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: notes.length,
              itemBuilder: (context, i) {
                final note = notes[i];

                return NoteCard(
                  note: note,

                  onDelete: () async {
                    final confirm = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: AppColors.primaryGradient,
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  "Delete Note",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Are you sure you want to delete this note?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text("Cancel"),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: AppColors.primaryGradient,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context, true),
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );

                    if (confirm == true) {
                      context.read<NotesBloc>().add(DeleteNote(note.id));
                    }
                  },

                  onEdit: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => NoteInputSheet(
                        note: note,
                        onSave: (updated) {
                          context.read<NotesBloc>().add(UpdateNote(updated));
                        },
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
