import '../../domain/entities/journal_entity.dart';

enum JournalStatus { initial, loading, success, failure }

class JournalState {
  final List<JournalEntity> journals; // list sesuai filter (mis. hari terpilih)
  final Set<DateTime> allDatesWithJournals; // SEMUA tanggal yg punya entri (dinormalisasi y/m/d)
  final JournalStatus status;
  final String? errorMessage;

  const JournalState({
    required this.journals,
    required this.allDatesWithJournals,
    required this.status,
    this.errorMessage,
  });

  factory JournalState.initial() {
    return const JournalState(
      journals: [],
      allDatesWithJournals: {},
      status: JournalStatus.initial,
    );
  }

  JournalState copyWith({
    List<JournalEntity>? journals,
    Set<DateTime>? allDatesWithJournals,
    JournalStatus? status,
    String? errorMessage,
  }) {
    return JournalState(
      journals: journals ?? this.journals,
      allDatesWithJournals: allDatesWithJournals ?? this.allDatesWithJournals,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalState &&
          runtimeType == other.runtimeType &&
          journals == other.journals &&
          allDatesWithJournals == other.allDatesWithJournals &&
          status == other.status &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode =>
      journals.hashCode ^ allDatesWithJournals.hashCode ^ status.hashCode ^ errorMessage.hashCode;
}
