// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class AttachmentEntity extends Equatable {
  final String id;
  final String name;
  final String path;
  final String mimeType;
  final int size;
  final DateTime createdAt;

  const AttachmentEntity({
    required this.id,
    required this.name,
    required this.path,
    required this.mimeType,
    required this.size,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, path, mimeType, size, name, createdAt];

  AttachmentEntity copyWith({
    String? id,
    String? name,
    String? path,
    String? mimeType,
    int? size,
    DateTime? createdAt,
  }) {
    return AttachmentEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      mimeType: mimeType ?? this.mimeType,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
