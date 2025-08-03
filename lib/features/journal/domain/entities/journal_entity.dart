class JournalEntity {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final bool isFavorite;

  const JournalEntity({required this.id, required this.date, required this.title, required this.content, this.isFavorite = false});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          date == other.date &&
          title == other.title &&
          content == other.content &&
          isFavorite == other.isFavorite;

  @override
  int get hashCode => id.hashCode ^ date.hashCode ^ title.hashCode ^ content.hashCode ^ isFavorite.hashCode;
}
