import 'package:flutter/material.dart';

class AttachmentTile extends StatelessWidget {
  final String name;
  final String mime;
  final int size;
  final VoidCallback onOpen;
  final VoidCallback onRemove;
  final VoidCallback onShare;

  const AttachmentTile({
    super.key,
    required this.name,
    required this.mime,
    required this.size,
    required this.onOpen,
    required this.onRemove,
    required this.onShare,
  });

  IconData get _icon {
    if (mime.startsWith('image/')) return Icons.image_outlined;
    if (mime == 'application/pdf') return Icons.picture_as_pdf_outlined;
    return Icons.insert_drive_file_outlined;
  }

  String get _sizeText {
    if (size < 1024) return '$size B';
    final kb = size / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: cs.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: ListTile(
        leading: Icon(_icon, color: cs.primary),
        title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text('$mime • $_sizeText', maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(tooltip: 'Share', icon: const Icon(Icons.share), onPressed: onShare),
            IconButton(
              tooltip: 'Remove',
              icon: const Icon(Icons.close_rounded),
              onPressed: onRemove,
            ),
          ],
        ),
        onTap: onOpen,
      ),
    );
  }
}
