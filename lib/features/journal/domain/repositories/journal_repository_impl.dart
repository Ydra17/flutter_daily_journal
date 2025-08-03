import '../../data/datasources/journal_local_datasources.dart';
import '../../data/models/journal_model.dart';
import '../../data/repositories/journal_repository.dart';
import '../entities/journal_entity.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDataSource localDataSource;

  JournalRepositoryImpl({required this.localDataSource});

  @override
  Future<List<JournalEntity>> getAllJournals() async {
    final models = await localDataSource.getAllJournals();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<JournalEntity>> getJournalsByDate(DateTime date) async {
    final models = await localDataSource.getJournalsByDate(date);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addJournal(JournalEntity journal) async {
    final model = JournalModel.fromEntity(journal);
    await localDataSource.addJournal(model);
  }

  @override
  Future<void> updateJournal(JournalEntity journal) async {
    final model = JournalModel.fromEntity(journal);
    await localDataSource.updateJournal(model);
  }

  @override
  Future<void> deleteJournal(String id) async {
    await localDataSource.deleteJournal(id);
  }
}
