import 'package:equatable/equatable.dart';
import '../../models/parking_session.dart';

enum ParkingStatus { initial, loading, loaded, error }

class ParkingState extends Equatable {
  final ParkingStatus status;
  final List<ParkingSession> sessions;
  final List<Map<String, dynamic>> stats; // For the stats chart
  final String? error;

  const ParkingState({
    this.status = ParkingStatus.initial,
    this.sessions = const [],
    this.stats = const [],
    this.error,
  });

  ParkingState copyWith({
    ParkingStatus? status,
    List<ParkingSession>? sessions,
    List<Map<String, dynamic>>? stats,
    String? error,
  }) {
    return ParkingState(
      status: status ?? this.status,
      sessions: sessions ?? this.sessions,
      stats: stats ?? this.stats,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, sessions, stats, error];
}
