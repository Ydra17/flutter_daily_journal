import 'package:hive/hive.dart';

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

  JournalModel({required this.id, required this.date, required this.title, required this.content, this.isFavorite = false});

  factory JournalModel.fromEntity(JournalEntity entity) {
    return JournalModel(id: entity.id, date: entity.date, title: entity.title, content: entity.content, isFavorite: entity.isFavorite);
  }

  JournalEntity toEntity() {
    return JournalEntity(id: id, date: date, title: title, content: content, isFavorite: isFavorite);
  }
}
