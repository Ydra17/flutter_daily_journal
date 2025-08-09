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
      final list = await getAllJournals();

      // bangun set tanggal (dinormalisasi y/m/d)
      final dates = <DateTime>{};
      for (final j in list) {
        final d = j.date;
        dates.add(DateTime(d.year, d.month, d.day));
      }

      state = state.copyWith(
        journals: list, // kalau ingin tampil semua; biasanya UI akan pakai filterByDate setelah ini
        allDatesWithJournals: dates,
        status: JournalStatus.success,
        errorMessage: null,
      );
    } catch (e) {
      state = state.copyWith(status: JournalStatus.failure, errorMessage: e.toString());
    }
  }

  Future<void> filterByDate(DateTime date) async {
    state = state.copyWith(status: JournalStatus.loading);
    try {
      final list = await getJournalsByDate(date);
      // perhatikan: JANGAN sentuh allDatesWithJournals di sini
      state = state.copyWith(journals: list, status: JournalStatus.success, errorMessage: null);
    } catch (e) {
      state = state.copyWith(status: JournalStatus.failure, errorMessage: e.toString());
    }
  }

  // create/edit/delete tetap sama; setelah aksi panggil loadJournals()
  Future<void> createJournal(JournalEntity journal) async {
    await addJournal(journal);
    await loadJournals();
  }

  Future<void> editJournal(JournalEntity journal) async {
    await updateJournal(journal);
    await loadJournals();
  }

  Future<void> removeJournal(String id) async {
    await deleteJournal(id);
    await loadJournals();
  }
}
