// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_daily_journal/features/journal/domain/entities/attachment_entity.dart';
import 'package:hive/hive.dart';

part 'attachment_model.g.dart';

@HiveType(typeId: 1)
class AttachmentModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String path;
  @HiveField(3)
  String mimeType;
  @HiveField(4)
  int size;
  @HiveField(5)
  DateTime createdAt;

  AttachmentModel({
    required this.id,
    required this.name,
    required this.path,
    required this.mimeType,
    required this.size,
    required this.createdAt,
  });

  factory AttachmentModel.fromEntity(AttachmentEntity e) => AttachmentModel(
    id: e.id,
    name: e.name,
    path: e.path,
    mimeType: e.mimeType,
    size: e.size,
    createdAt: e.createdAt,
  );

  AttachmentEntity toEntity() => AttachmentEntity(
    id: id,
    name: name,
    path: path,
    mimeType: mimeType,
    size: size,
    createdAt: createdAt,
  );
}
