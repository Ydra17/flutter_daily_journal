import 'package:flutter/material.dart';
import 'package:flutter_daily_journal/app.dart';
import 'package:flutter_daily_journal/core/constants/app_colors.dart';
import 'package:flutter_daily_journal/core/utils/logger.dart';
import 'package:flutter_daily_journal/features/journal/presentation/pages/journal_form_page.dart';
import 'package:flutter_daily_journal/features/journal/presentation/providers/journal_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/journal_provider.dart';

class JournalHomePage extends ConsumerStatefulWidget {
  const JournalHomePage({super.key});

  @override
  ConsumerState<JournalHomePage> createState() => _JournalHomePageState();
}

class _JournalHomePageState extends ConsumerState<JournalHomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month; // Dipindahkan ke dalam state
  Set<DateTime> datesWithJournals = {};

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    // Memanggil fungsi asinkron setelah inisialisasi
    Future.microtask(() async {
      await loadAndFilterJournals(); // Memanggil fungsi asinkron di initState
    });
  }

  // Fungsi asinkron yang memuat dan memfilter jurnal
  Future<void> loadAndFilterJournals() async {
    await ref.read(journalNotifierProvider.notifier).loadJournals(); // Tunggu hingga selesai
    if (ref.read(journalNotifierProvider).journals.isNotEmpty) {
      datesWithJournals.clear();
      for (var journal in ref.read(journalNotifierProvider).journals) {
        final journalDate = journal.date; // Pastikan jurnal memiliki properti 'date'
        datesWithJournals.add(DateTime(journalDate.year, journalDate.month, journalDate.day));
      }
    }
    // Setelah semua jurnal dimuat dan diproses, filter berdasarkan tanggal saat ini
    await ref.read(journalNotifierProvider.notifier).filterByDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journalNotifierProvider);
    final notifier = ref.read(journalNotifierProvider.notifier);

    for (var journal in state.journals) {
      final journalDate = journal.date; // Pastikan jurnal memiliki properti 'date'
      datesWithJournals.add(DateTime(journalDate.year, journalDate.month, journalDate.day));
    }

    bool isDateWithJournal(DateTime date) {
      // Normalisasi tanggal ke tahun, bulan, dan hari saja
      final normalizedDate = DateTime(date.year, date.month, date.day);

      // Periksa apakah tanggal yang sudah dinormalisasi ada dalam Set
      return datesWithJournals.any((journalDate) {
        final normalizedJournalDate = DateTime(
          journalDate.year,
          journalDate.month,
          journalDate.day,
        );
        return normalizedJournalDate == normalizedDate;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text('My Journal')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2025),
            lastDay: DateTime.utc(2050),
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) =>
                _selectedDay != null && DateUtils.isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedDay = selectedDay;
              });
              notifier.filterByDate(selectedDay);
            },
            availableCalendarFormats: const {
              CalendarFormat.week: 'Week',
              CalendarFormat.month: 'Month',
            },
            calendarFormat: _calendarFormat, // Menggunakan _calendarFormat dari state
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay; // Perbarui state untuk focusedDay
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
              weekendTextStyle: TextStyle(color: Colors.red),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                // AppLogger.log(datesWithJournals.toString());
                // AppLogger.log(
                //   datesWithJournals.contains(date)
                //       ? 'Date has journal entries'
                //       : 'Date has no journal entries for $date',
                // );
                if (isDateWithJournal(date)) {
                  return Positioned(
                    bottom: 1,
                    right: 1,
                    child: Container(
                      height: 6,
                      width: 6,
                      decoration: const BoxDecoration(
                        color: Colors.red, // Menandai tanggal dengan jurnal
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: true, // Menampilkan tombol untuk ganti format kalender
              formatButtonShowsNext: false, // Menampilkan tombol format yang aktif
            ),
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format; // Perbarui format kalender berdasarkan pilihan pengguna
              });
            },
          ),
          Expanded(
            child: Builder(
              builder: (context) {
                if (state.status == JournalStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == JournalStatus.failure) {
                  return Center(child: Text(state.errorMessage ?? 'Error Loading Journals'));
                } else if (state.journals.isEmpty) {
                  return const Center(child: Text('No Journal entries for this day'));
                }

                return ListView.builder(
                  itemCount: state.journals.length,
                  itemBuilder: (context, index) {
                    final journal = state.journals[index];
                    return ListTile(
                      title: Text(journal.title),
                      subtitle: Text(
                        journal.content.length > 50
                            ? '${journal.content.substring(0, 50)}...'
                            : journal.content,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => JournalFormPage(existing: journal)),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => JournalFormPage()));
        },
        backgroundColor: AppColors.accent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
