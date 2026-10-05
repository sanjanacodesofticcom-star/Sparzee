import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/models.dart';
import '../../core/services/database_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/spargee_widgets.dart';

class NotepadScreen extends StatefulWidget {
  final bool showBackButton;

  const NotepadScreen({super.key, this.showBackButton = false});

  @override
  State<NotepadScreen> createState() => _NotepadScreenState();
}

class _NotepadScreenState extends State<NotepadScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _noteContentController = TextEditingController();
  bool _isPinned = true;
  String _visibleTo = 'All management & admins';
  DateTime? _selectedDate = DateTime.now();

  final List<String> _visibilityOptions = [
    'All management & admins',
    'Teachers & Staff',
    'Only Management',
    'Public / Everyone',
  ];

  @override
  void dispose() {
    _noteContentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryOrange,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveNote() async {
    final text = _noteContentController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please type your note before saving.'),
          backgroundColor: AppColors.primaryOrangeDark,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final dateStr = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : DateFormat('dd/MM/yyyy').format(DateTime.now());

    final newNote = NoteItem(
      id: 'NT${DateTime.now().millisecondsSinceEpoch}',
      title: text.length > 30 ? '${text.substring(0, 27)}...' : text,
      content: text,
      date: dateStr,
      isPinned: _isPinned,
      visibleTo: _visibleTo,
    );

    _noteContentController.clear();
    await DatabaseService.instance.addNote(newNote);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Note saved successfully!'),
          ],
        ),
        backgroundColor: AppColors.primaryPurple,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showNoteActions(NoteItem note) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.description_outlined, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        note.title,
                        style: AppTextStyles.titleSmall.copyWith(fontSize: 17),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE5D4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    note.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF5A443B),
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.visibility_outlined, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(note.visibleTo, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                    const Spacer(),
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(note.date, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.statusAbsent,
                          side: const BorderSide(color: AppColors.statusAbsent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.delete_outline_rounded, size: 18),
                        label: const Text('Delete'),
                        onPressed: () async {
                          await DatabaseService.instance.deleteNote(note.id);
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text('Edit Note'),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _openEditNoteDialog(note);
                        },
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
  }

  void _openEditNoteDialog(NoteItem note) {
    final editController = TextEditingController(text: note.content);
    bool editPinned = note.isPinned;
    String editVisible = note.visibleTo;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edit Note', style: AppTextStyles.titleMedium),
                  const SizedBox(height: 16),
                  Container(
                    height: 120,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.primaryOrange, width: 1.2),
                      color: Colors.white,
                    ),
                    child: TextField(
                      controller: editController,
                      maxLines: null,
                      style: const TextStyle(fontSize: 14.5),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type your note...',
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pin this Note', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                      Switch(
                        value: editPinned,
                        activeThumbColor: AppColors.primaryOrange,
                        activeTrackColor: AppColors.primaryPurple,
                        onChanged: (val) {
                          setModalState(() => editPinned = val);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SpargeePrimaryButton(
                    text: 'Update Note',
                    onPressed: () async {
                      if (editController.text.trim().isEmpty) return;
                      final updated = note.copyWith(
                        content: editController.text.trim(),
                        title: editController.text.trim().length > 30 ? '${editController.text.trim().substring(0, 27)}...' : editController.text.trim(),
                        isPinned: editPinned,
                        visibleTo: editVisible,
                      );
                      await DatabaseService.instance.updateNote(updated);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateDisplay = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : 'dd/mm/yyyy';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button & title
              Row(
                children: [
                  const SpargeeBackButton(),
                  const SizedBox(width: 14),
                ],
              ),
              const SizedBox(height: 16),

              Text(
                'Notepad',
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 18),

              // Section Label: Add Note
              Text(
                'Add Note',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // Multiline Note Input Container matching Figma
              Container(
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primaryOrange, width: 1.2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextField(
                  controller: _noteContentController,
                  maxLines: null,
                  style: const TextStyle(
                    fontSize: 14.5,
                    color: AppColors.textDark,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'type your note here.......',
                    hintStyle: TextStyle(
                      color: Color(0xFFB0A8A4),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pin this Note row with Switch
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pin this Note',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Transform.scale(
                    scale: 0.95,
                    child: Switch(
                      value: _isPinned,
                      activeThumbColor: AppColors.primaryOrange,
                      activeTrackColor: AppColors.primaryPurple,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: const Color(0xFFDCDCE8),
                      onChanged: (val) {
                        setState(() {
                          _isPinned = val;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Visible to section
              Text(
                'Visible to',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.primaryOrange, width: 1.2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _visibleTo,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primaryOrange,
                      size: 26,
                    ),
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF6E6059),
                      fontWeight: FontWeight.w400,
                    ),
                    items: _visibilityOptions.map((opt) {
                      return DropdownMenuItem<String>(
                        value: opt,
                        child: Text(opt),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _visibleTo = val;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Date section
              Text(
                'Date',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickDate,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.primaryOrange, width: 1.2),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateDisplay,
                        style: TextStyle(
                          fontSize: 14.5,
                          color: _selectedDate != null ? const Color(0xFF6E6059) : const Color(0xFFB0A8A4),
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: AppColors.primaryPurple,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),

              // Save note button (Solid Orange matching Figma)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _saveNote,
                  child: const Text(
                    'Save note',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // List of saved/pinned notes matching peach cards in Figma
              StreamBuilder<List<NoteItem>>(
                stream: DatabaseService.instance.notesStream,
                initialData: DatabaseService.instance.currentNotes,
                builder: (context, snapshot) {
                  final notes = snapshot.data ?? [];
                  if (notes.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      alignment: Alignment.center,
                      child: Text(
                        'No notes saved yet.',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                    );
                  }
                  return Column(
                    children: notes.map((note) => _buildPeachNoteCard(note)).toList(),
                  );
                },
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeachNoteCard(NoteItem note) {
    return GestureDetector(
      onTap: () => _showNoteActions(note),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDFCE), // Peach background from screenshot
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Blue/Purple circular badge
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFF7F80DA),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.article_outlined,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Note Content text
            Expanded(
              child: Text(
                note.content,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF5A443B),
                  height: 1.35,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
