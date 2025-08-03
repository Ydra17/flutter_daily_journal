import '../../data/repositories/journal_repository.dart';
import '../entities/journal_entity.dart';

class AddJournal {
  final JournalRepository repository;

  AddJournal(this.repository);

  Future<void> call(JournalEntity journal) {
    return repository.addJournal(journal);
  }
}
