import '../../data/repositories/journal_repository.dart';
import '../entities/journal_entity.dart';

class GetAllJournals {
  final JournalRepository repository;

  GetAllJournals(this.repository);

  Future<List<JournalEntity>> call() {
    return repository.getAllJournals();
  }
}
