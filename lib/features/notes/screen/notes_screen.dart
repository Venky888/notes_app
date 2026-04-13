import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/constants/app_colors.dart';
import 'package:notes_app/features/notes/bloc/notes_bloc.dart';
import 'package:notes_app/features/notes/bloc/notes_events.dart';
import 'package:notes_app/features/notes/bloc/notes_states.dart';
import 'package:notes_app/features/notes/widgets/note_input_sheet.dart';
import 'package:notes_app/features/notes/widgets/notes_list_view.dart';
import 'package:notes_app/features/notes/widgets/search_bar.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: const Text(
              "My Notes",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          const SearchBarWidget(),

          Expanded(
            child: BlocConsumer<NotesBloc, NotesStates>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is NotesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state is NotesLoaded) {
                  return NotesListView(
                    notes: state.filtered,
                    onRefresh: () async {
                      context.read<NotesBloc>().add(FetchNotes());
                      await Future.delayed(const Duration(seconds: 1));
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),

      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.primaryGradient,
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: _openSheet,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }

  void _openSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NoteInputSheet(
        onSave: (note) {
          context.read<NotesBloc>().add(AddNote(note));
        },
      ),
    );
  }
}
