import 'package:hive/hive.dart';

import '../models/journal_model.dart';

abstract class JournalLocalDataSource {
  Future<List<JournalModel>> getAllJournals();
  Future<List<JournalModel>> getJournalsByDate(DateTime date);
  Future<void> addJournal(JournalModel journal);
  Future<void> updateJournal(JournalModel journal);
  Future<void> deleteJournal(String id);
}

class JournalLocalDataSourceImpl implements JournalLocalDataSource {
  final Box<JournalModel> journalBox;

  JournalLocalDataSourceImpl({required this.journalBox});

  @override
  Future<List<JournalModel>> getAllJournals() async {
    return journalBox.values.toList()..sort((a, b) => b.date.compareTo(a.date)); // urutkan terbaru ke lama
  }

  @override
  Future<List<JournalModel>> getJournalsByDate(DateTime date) async {
    return journalBox.values
        .where((journal) => journal.date.year == date.year && journal.date.month == date.month && journal.date.day == date.day)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> addJournal(JournalModel journal) async {
    await journalBox.put(journal.id, journal);
  }

  @override
  Future<void> updateJournal(JournalModel journal) async {
    await journalBox.put(journal.id, journal);
  }

  @override
  Future<void> deleteJournal(String id) async {
    await journalBox.delete(id);
  }
}
