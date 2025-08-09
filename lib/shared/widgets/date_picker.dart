import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

/// Drop-in replacement: komponen pilih tanggal yang tematik & accessible
class CustomDatePicker extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final String label; // e.g. 'Date'
  final String? helpText; // teks header di date picker

  const CustomDatePicker({
    super.key,
    required this.date,
    required this.onChanged,
    this.label = 'Date',
    this.helpText,
  });

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
      initialDate: date,
      helpText: helpText ?? 'Select $label',
      confirmText: 'OK',
      cancelText: 'Cancel',
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        // Opsional: samakan warna dialog dengan theme
        final cs = Theme.of(context).colorScheme;
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(dialogTheme: DialogThemeData(backgroundColor: cs.surface)),
          child: child!,
        );
      },
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Material(
      color: cs.surface,
      elevation: 0, // biar rata, kita pakai outline halus
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant, width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _pickDate(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.calendar_month, color: cs.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Label kecil di atas
                    Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Nilai tanggal
                    Text(
                      // gunakan locale device jika mau: DateFormat.yMMMd(Localizations.localeOf(context).toString())
                      DateFormat('dd-MM-yyyy').format(date),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Tombol aksi sekunder (optional, seluruh bar juga tappable)
              TextButton.icon(
                onPressed: () => _pickDate(context),
                icon: const Icon(Icons.edit_calendar),
                label: const Text('Change'),
                style: TextButton.styleFrom(
                  foregroundColor: cs.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
