import 'dart:io';

import 'package:flutter_daily_journal/features/journal/domain/entities/attachment_entity.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;

class AttachmentUtils {
  static const _uuid = Uuid();

  static Future<AttachmentEntity> importFileToAppDir(String sourcePath) async {
    final file = File(sourcePath);
    final name = p.basename(sourcePath);
    final bytes = await file.length();
    final mime = lookupMimeType(sourcePath) ?? 'application/octet-stream';

    final appDir = await getApplicationDocumentsDirectory();
    final destDir = Directory(p.join(appDir.path, 'attachments'));
    if (!await destDir.exists()) {
      await destDir.create(recursive: true);
    }

    final id = _uuid.v4();
    // final ext = p.extension(name);
    final destPath = p.join(destDir.path, '${id}_$name');

    await file.copy(destPath);

    return AttachmentEntity(
      id: id,
      name: name,
      path: destPath,
      mimeType: mime,
      size: bytes,
      createdAt: DateTime.now(),
    );
  }
}
