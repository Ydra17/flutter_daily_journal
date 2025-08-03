import 'package:flutter_daily_journal/features/journal/domain/entities/journal_entity.dart';
import 'package:flutter_daily_journal/features/journal/domain/usecases/delete_journal.dart';
import 'package:flutter_daily_journal/features/journal/domain/usecases/get_all_journals.dart';
import 'package:flutter_daily_journal/features/journal/domain/usecases/get_journals_by_date.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/add_journals.dart';
import '../../domain/usecases/update_journal.dart';
import 'journal_state.dart';

class JournalNotifier extends StateNotifier<JournalState> {
  final GetAllJournals getAllJournals;
  final GetJournalsByDate getJournalsByDate;
  final AddJournal addJournal;
  final UpdateJournal updateJournal;
  final DeleteJournal deleteJournal;

  JournalNotifier({
    required this.getAllJournals,
    required this.getJournalsByDate,
    required this.addJournal,
    required this.updateJournal,
    required this.deleteJournal,
  }) : super(JournalState.initial());

  Future<void> loadJournals() async {
    state = state.copyWith(status: JournalStatus.loading);
    try {
      final journals = await getAllJournals();
      state = state.copyWith(journals: journals, status: JournalStatus.success);
    } catch (e) {
      state = state.copyWith(status: JournalStatus.failure, errorMessage: e.toString());
    }
  }

  Future<void> filterByDate(DateTime date) async {
    state = state.copyWith(status: JournalStatus.loading);
    try {
      final journals = await getJournalsByDate(date);
      state = state.copyWith(journals: journals, status: JournalStatus.success);
    } catch (e) {
      state = state.copyWith(status: JournalStatus.failure, errorMessage: e.toString());
    }
  }

  Future<void> createJournal(JournalEntity journal) async {
    await addJournal(journal);
    await loadJournals();
  }

  Future<void> editJournal(JournalEntity journal) async {
    await editJournal(journal);
    await loadJournals();
  }

  Future<void> removeJournal(String id) async {
    await deleteJournal(id);
    await loadJournals();
  }
}
