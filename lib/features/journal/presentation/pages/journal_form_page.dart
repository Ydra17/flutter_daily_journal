import 'package:flutter/material.dart';
import 'package:flutter_daily_journal/shared/widgets/forms.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
          child: ListView(
            children: [
              CustomTextField2(controller: _titleController, label: 'Title'),
              const SizedBox(height: 16),
              CustomTextField2(controller: _contentController, label: 'Content', maxLines: 8),
              // TextFormField(
              //   controller: _titleController,
              //   decoration: const InputDecoration(labelText: 'Title'),
              //   validator: (value) => value == null || value.isEmpty ? 'Title Required' : null,
              // ),
              // const SizedBox(height: 16),
              // TextFormField(
              //   controller: _contentController,

              //   decoration: const InputDecoration(labelText: 'Content'),
              //   maxLines: 8,
              //   validator: (value) => value == null || value.isEmpty ? 'Content Required' : null,
              // ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        51,
                        158,
                        158,
                        158,
                      ), // Colors.grey.withOpacity(0.2)
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Label "Date"
                    const Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 16), // Tambahkan jarak antar elemen
                    // Tanggal dalam format DD-MM-YYYY
                    Text(
                      DateFormat('dd-MM-yyyy').format(_date), // Format menggunakan intl package
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withOpacity(0.7), // Sedikit opacity untuk warna teks
                      ),
                    ),
                    const Spacer(),
                    // Tombol untuk memilih tanggal
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
                      child: const Text(
                        'Change',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue, // Warna tombol untuk aksen
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
