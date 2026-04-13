import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_app/core/constants/app_colors.dart';
import 'package:notes_app/features/notes/bloc/notes_bloc.dart';
import 'package:notes_app/features/notes/bloc/notes_events.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                focusNode: _focusNode,
                autofocus: false,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  hintStyle: TextStyle(color: Colors.grey.shade500),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.primary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (val) {
                  context.read<NotesBloc>().add(SearchNotes(val.trim()));
                },
              ),
            ),
          ),

          const SizedBox(width: 10),

          GestureDetector(
            onTap: () => _openFilterSheet(context),
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.tune, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 🔹 Handle
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const Text(
                "Sort Notes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              _tile(
                context,
                icon: Icons.access_time,
                title: "Newest First",
                onTap: () {
                  context.read<NotesBloc>().add(const SortNotes());
                  Navigator.pop(context);
                },
              ),

              _tile(
                context,
                icon: Icons.history,
                title: "Oldest First",
                onTap: () {
                  context.read<NotesBloc>().add(const SortNotes(reverse: true));
                  Navigator.pop(context);
                },
              ),

              _tile(
                context,
                icon: Icons.sort_by_alpha,
                title: "Alphabetical",
                onTap: () {
                  context.read<NotesBloc>().add(
                    const SortNotes(alphabetical: true),
                  );
                  Navigator.pop(context);
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: onTap,
    );
  }
}
