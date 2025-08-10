// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';

import 'package:flutter_daily_journal/features/journal/data/models/attachment_model.dart';

import '../../domain/entities/journal_entity.dart';

part 'journal_model.g.dart';

@HiveType(typeId: 0)
class JournalModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final bool isFavorite;

  @HiveField(5)
  final List<AttachmentModel> attachments;

  JournalModel({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.isFavorite,
    List<AttachmentModel>? attachments,
  }) : attachments = attachments ?? <AttachmentModel>[];

  factory JournalModel.fromEntity(JournalEntity entity) {
    return JournalModel(
      id: entity.id,
      date: entity.date,
      title: entity.title,
      content: entity.content,
      isFavorite: entity.isFavorite,
      attachments: entity.attachments.map((e) => AttachmentModel.fromEntity(e)).toList(),
    );
  }

  JournalEntity toEntity() {
    return JournalEntity(
      id: id,
      date: date,
      title: title,
      content: content,
      isFavorite: isFavorite,
      attachments: attachments.map((e) => e.toEntity()).toList(),
    );
  }
}
