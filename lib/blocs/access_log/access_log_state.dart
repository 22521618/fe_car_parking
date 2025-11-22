import 'package:equatable/equatable.dart';
import '../../models/access_log.dart';

enum AccessLogStatus { initial, loading, loaded, error }

class AccessLogState extends Equatable {
  final AccessLogStatus status;
  final List<AccessLog> logs;
  final String? error;

  const AccessLogState({
    this.status = AccessLogStatus.initial,
    this.logs = const [],
    this.error,
  });

  AccessLogState copyWith({
    AccessLogStatus? status,
    List<AccessLog>? logs,
    String? error,
  }) {
    return AccessLogState(
      status: status ?? this.status,
      logs: logs ?? this.logs,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, logs, error];
}
