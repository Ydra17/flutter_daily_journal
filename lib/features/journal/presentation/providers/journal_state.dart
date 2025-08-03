import '../../domain/entities/journal_entity.dart';

enum JournalStatus { initial, loading, success, failure }

class JournalState {
  final List<JournalEntity> journals;
  final JournalStatus status;
  final String? errorMessage;

  const JournalState({required this.journals, required this.status, this.errorMessage});

  factory JournalState.initial() {
    return const JournalState(journals: [], status: JournalStatus.initial);
  }

  JournalState copyWith({List<JournalEntity>? journals, JournalStatus? status, String? errorMessage}) {
    return JournalState(journals: journals ?? this.journals, status: status ?? this.status, errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JournalState &&
          runtimeType == other.runtimeType &&
          journals == other.journals &&
          status == other.status &&
          errorMessage == other.errorMessage;

  @override
  int get hashCode => journals.hashCode ^ status.hashCode ^ errorMessage.hashCode;
}
