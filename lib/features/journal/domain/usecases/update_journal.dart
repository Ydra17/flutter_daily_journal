import '../../data/repositories/journal_repository.dart';
import '../entities/journal_entity.dart';

class UpdateJournal {
  final JournalRepository repository;

  UpdateJournal(this.repository);

  Future<void> call(JournalEntity journal) {
    return repository.updateJournal(journal);
  }
}
