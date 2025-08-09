import 'package:flutter/material.dart';
import 'package:flutter_daily_journal/shared/widgets/date_picker.dart';
import 'package:flutter_daily_journal/shared/widgets/forms.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/widgets/action_button.dart';
import '../../domain/entities/journal_entity.dart';
import '../providers/journal_provider.dart';

class JournalFormPage extends ConsumerStatefulWidget {
  final JournalEntity? existing;
  final DateTime selectedDate;
  const JournalFormPage({super.key, this.existing, required this.selectedDate});

  @override
  ConsumerState<JournalFormPage> createState() => _JournalFormPageState();
}

class _JournalFormPageState extends ConsumerState<JournalFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = const Uuid();

  late DateTime _date;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _date = widget.existing?.date ?? widget.selectedDate;
    _titleController = TextEditingController(text: widget.existing?.title ?? '');
    _contentController = TextEditingController(text: widget.existing?.content ?? '');
    _isFavorite = widget.existing?.isFavorite ?? false;
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      final newEntry = JournalEntity(
        id: widget.existing?.id ?? _uuid.v4(),
        date: _date,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        isFavorite: _isFavorite,
      );

      final notifier = ref.read(journalNotifierProvider.notifier);

      if (widget.existing == null) {
        await notifier.createJournal(newEntry);
      } else {
        await notifier.editJournal(newEntry);
      }
      await notifier.filterByDate(_date);
      if (context.mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Entry' : 'New Entry'),
        actions: [IconButton(onPressed: _handleSubmit, icon: const Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomTextField2(controller: _titleController, label: 'Title'),
                const SizedBox(height: 16),
                CustomTextField2(controller: _contentController, label: 'Content', maxLines: 8),
                const SizedBox(height: 16),
                CustomDatePicker(
                  date: _date,
                  onChanged: (picked) => setState(() => _date = picked),
                  label: 'Date',
                  // helpText: 'Select the date for this entry',
                ),
                const SizedBox(height: 16),
                ActionButton(
                  label: 'Save Journal',
                  icon: Icons.save_outlined,
                  kind: ActionButtonKind.primary,
                  variant: ActionButtonVariant.filled,
                  expand: true,
                  onPressed: _handleSubmit,
                ),

                const SizedBox(height: 16),
                if (widget.existing != null) // ✅ Hanya tampil jika ada data existing
                  ConfirmingActionButton(
                    label: 'Delete Journal',
                    kind: ActionButtonKind.danger,
                    onConfirmed: () async {
                      await ref
                          .read(journalNotifierProvider.notifier)
                          .removeJournal(widget.existing?.id ?? '');
                      if (context.mounted) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Journal deleted')));
                        if (context.mounted) Navigator.pop(context);
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
