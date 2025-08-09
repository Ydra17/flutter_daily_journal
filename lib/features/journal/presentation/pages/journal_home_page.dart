import 'package:flutter/material.dart';
import 'package:flutter_daily_journal/core/constants/app_colors.dart';
import 'package:flutter_daily_journal/features/journal/presentation/pages/journal_form_page.dart';
import 'package:flutter_daily_journal/features/journal/presentation/providers/journal_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

import '../providers/journal_provider.dart';
import '../widgets/journal_list_item.dart';

class JournalHomePage extends ConsumerStatefulWidget {
  const JournalHomePage({super.key});

  @override
  ConsumerState<JournalHomePage> createState() => _JournalHomePageState();
}

class _JournalHomePageState extends ConsumerState<JournalHomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    Future.microtask(() async {
      await ref.read(journalNotifierProvider.notifier).loadJournals();
      await ref.read(journalNotifierProvider.notifier).filterByDate(_focusedDay);
    });
  }

  bool _isDateWithJournal(Set<DateTime> allDates, DateTime date) {
    final nd = DateTime(date.year, date.month, date.day);
    // karena kita sudah simpan normalized, cukup contains
    return allDates.contains(nd);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journalNotifierProvider);
    final notifier = ref.read(journalNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('My Journal')),
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
            calendarFormat: _calendarFormat,
            onPageChanged: (focusedDay) {
              setState(() => _focusedDay = focusedDay);
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
              weekendTextStyle: TextStyle(color: Colors.red),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (_isDateWithJournal(state.allDatesWithJournals, date)) {
                  return const Positioned(
                    bottom: 1,
                    right: 1,
                    child: SizedBox(
                      height: 6,
                      width: 6,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
            headerStyle: const HeaderStyle(formatButtonVisible: true, formatButtonShowsNext: false),
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: JournalListItem(
                        journal: journal,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JournalFormPage(
                                existing: journal,
                                selectedDate: _selectedDay ?? DateTime.now(),
                              ),
                            ),
                          ).then((_) => notifier.filterByDate(_selectedDay ?? _focusedDay));
                        },
                        // optional: aksi long-press (mis. context menu)
                        // onLongPress: () => _showJournalMenu(journal),
                      ),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => JournalFormPage(selectedDate: _focusedDay)),
          ).then((_) => notifier.filterByDate(_selectedDay ?? _focusedDay));
        },
        backgroundColor: AppColors.accent,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
