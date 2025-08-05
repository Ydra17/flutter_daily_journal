import 'package:flutter/material.dart';
import 'package:flutter_daily_journal/core/constants/app_colors.dart';
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

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    Future.microtask(() {
      ref.read(journalNotifierProvider.notifier).filterByDate(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journalNotifierProvider);
    final notifier = ref.read(journalNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('My Journal')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2025),
            lastDay: DateTime.utc(2050),
            selectedDayPredicate: (day) =>
                _selectedDay != null && DateUtils.isSameDay(day, _selectedDay),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedDay = selectedDay;
              });
              notifier.filterByDate(selectedDay);
            },
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            calendarFormat: CalendarFormat.month,
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
            ),
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
