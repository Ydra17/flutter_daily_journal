import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/journal_entity.dart';
import '../providers/journal_provider.dart';

class JournalFormPage extends ConsumerStatefulWidget {
  final JournalEntity? existing;
  const JournalFormPage({super.key, this.existing});

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

  void initState() {
    super.initState();
    _date = widget.existing?.date ?? DateTime.now();
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
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value == null || value.isEmpty ? 'Title Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,

                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 8,
                validator: (value) => value == null || value.isEmpty ? 'Content Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Date'),
                  const SizedBox(width: 8),
                  Text('${_date.toLocal()}'.split('')[0]),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2050),
                        initialDate: _date,
                      );
                      if (picked != null) {
                        setState(() {
                          _date = picked;
                        });
                      }
                    },
                    child: const Text('Change'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
