import '../../domain/entities/journal_entity.dart';

abstract class JournalRepository {
  Future<List<JournalEntity>> getAllJournals();
  Future<List<JournalEntity>> getJournalsByDate(DateTime date);
  Future<void> addJournal(JournalEntity journal);
  Future<void> updateJournal(JournalEntity journal);
  Future<void> deleteJournal(String id);
}
