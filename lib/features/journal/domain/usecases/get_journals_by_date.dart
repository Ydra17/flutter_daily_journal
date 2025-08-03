import '../../data/repositories/journal_repository.dart';
import '../entities/journal_entity.dart';

class GetJournalsByDate {
  final JournalRepository repository;

  GetJournalsByDate(this.repository);

  Future<List<JournalEntity>> call(DateTime date) {
    return repository.getJournalsByDate(date);
  }
}
