import 'package:flutter/material.dart';
import 'package:notes_app/core/constants/app_colors.dart';
import 'package:notes_app/features/notes/model/note_model.dart';

class NoteInputSheet extends StatefulWidget {
  final Function(Note) onSave;
  final Note? note;

  const NoteInputSheet({super.key, required this.onSave, this.note});

  @override
  State<NoteInputSheet> createState() => _NoteInputSheetState();
}

class _NoteInputSheetState extends State<NoteInputSheet> {
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.note?.title ?? "");

    contentController = TextEditingController(text: widget.note?.content ?? "");
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            _buildInput(controller: titleController, hint: "Title"),

            const SizedBox(height: 14),

            _buildInput(
              controller: contentController,
              hint: "Content",
              maxLines: 4,
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: _onSave,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    widget.note == null ? "Add Note" : "Update Note",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade500),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }

  void _onSave() {
    if (titleController.text.trim().isEmpty ||
        contentController.text.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();

    final note = Note(
      id: widget.note?.id ?? DateTime.now().toString(),
      title: titleController.text.trim(),
      content: contentController.text.trim(),
      createdAt: widget.note?.createdAt ?? DateTime.now(),
    );

    widget.onSave(note);
    Navigator.pop(context);
  }
}
