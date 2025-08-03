import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../data/datasources/journal_local_datasources.dart';
import '../../data/models/journal_model.dart';
import '../../data/repositories/journal_repository.dart';
import 'journal_repository_impl.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  final box = Hive.box<JournalModel>('journals');
  final dataSource = JournalLocalDataSourceImpl(journalBox: box);
  return JournalRepositoryImpl(localDataSource: dataSource);
});
