import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/journal_entity.dart';

class JournalListItem extends StatelessWidget {
  final JournalEntity journal;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const JournalListItem({super.key, required this.journal, required this.onTap, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final day = DateFormat('d').format(journal.date); // 1..31
    final mon = DateFormat('MMM').format(journal.date); // Jan..Dec

    return Card(
      elevation: 0,
      color: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant, width: 1),
      ),
      clipBehavior: Clip.antiAlias, // ripple rapi di tepi card
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              // Badge tanggal
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primaryContainer,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      mon.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onPrimaryContainer,
                        letterSpacing: .5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Title + preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            journal.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (journal.isFavorite)
                          const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 18),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      journal.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
