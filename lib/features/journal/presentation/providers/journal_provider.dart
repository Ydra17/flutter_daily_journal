import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_daily_journal/features/journal/domain/usecases/get_all_journals.dart';
import 'package:flutter_daily_journal/features/journal/domain/usecases/get_journals_by_date.dart';
import 'package:flutter_daily_journal/features/journal/domain/usecases/add_journals.dart';
import 'package:flutter_daily_journal/features/journal/domain/usecases/update_journal.dart';
import 'package:flutter_daily_journal/features/journal/domain/usecases/delete_journal.dart';
import 'package:flutter_daily_journal/features/journal/presentation/providers/journal_notifier.dart';
import 'package:flutter_daily_journal/features/journal/presentation/providers/journal_state.dart';

import '../../domain/repositories/journal_repository_provider.dart';

/// Provider untuk dependensi use case
final getAllJournalsProvider = Provider<GetAllJournals>((ref) => GetAllJournals(ref.watch(journalRepositoryProvider)));

final getJournalsByDateProvider = Provider<GetJournalsByDate>((ref) => GetJournalsByDate(ref.watch(journalRepositoryProvider)));

final addJournalProvider = Provider<AddJournal>((ref) => AddJournal(ref.watch(journalRepositoryProvider)));

final updateJournalProvider = Provider<UpdateJournal>((ref) => UpdateJournal(ref.watch(journalRepositoryProvider)));

final deleteJournalProvider = Provider<DeleteJournal>((ref) => DeleteJournal(ref.watch(journalRepositoryProvider)));

/// Main StateNotifierProvider
final journalNotifierProvider = StateNotifierProvider<JournalNotifier, JournalState>((ref) {
  return JournalNotifier(
    getAllJournals: ref.watch(getAllJournalsProvider),
    getJournalsByDate: ref.watch(getJournalsByDateProvider),
    addJournal: ref.watch(addJournalProvider),
    updateJournal: ref.watch(updateJournalProvider),
    deleteJournal: ref.watch(deleteJournalProvider),
  );
});
