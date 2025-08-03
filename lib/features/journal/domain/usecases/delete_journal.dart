import '../../data/repositories/journal_repository.dart';

class DeleteJournal {
  final JournalRepository repository;

  DeleteJournal(this.repository);

  Future<void> call(String id) {
    return repository.deleteJournal(id);
  }
}
