// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:flutter_daily_journal/features/journal/domain/entities/attachment_entity.dart';

class JournalEntity extends Equatable {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final bool isFavorite;
  final List<AttachmentEntity> attachments;

  JournalEntity({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    required this.isFavorite,
    List<AttachmentEntity>? attachments,
  }) : attachments = attachments ?? [];

  JournalEntity copyWith({
    String? id,
    DateTime? date,
    String? title,
    String? content,
    bool? isFavorite,
    List<AttachmentEntity>? attachments,
  }) {
    return JournalEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
      isFavorite: isFavorite ?? this.isFavorite,
      attachments: attachments ?? this.attachments,
    );
  }

  JournalEntity addAttachment(AttachmentEntity attachment) {
    return copyWith(attachments: [...attachments, attachment]);
  }

  JournalEntity removeAttachmentById(String attachmentId) {
    return copyWith(attachments: attachments.where((a) => a.id != attachmentId).toList());
  }

  @override
  List<Object> get props {
    return [id, date, title, content, isFavorite, attachments];
  }

  @override
  bool get stringify => true;
}
