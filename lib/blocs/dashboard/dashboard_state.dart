import 'package:equatable/equatable.dart';
import '../../models/dashboard_stats.dart';

enum DashboardStatus { initial, loading, loaded, error }

class DashboardState extends Equatable {
  final DashboardStatus status;
  final DashboardStats? stats;
  final List<Map<String, dynamic>> liveFeed; // Store recent feed items
  final String? error;

  const DashboardState({
    this.status = DashboardStatus.initial,
    this.stats,
    this.liveFeed = const [],
    this.error,
  });

  DashboardState copyWith({
    DashboardStatus? status,
    DashboardStats? stats,
    List<Map<String, dynamic>>? liveFeed,
    String? error,
  }) {
    return DashboardState(
      status: status ?? this.status,
      stats: stats ?? this.stats,
      liveFeed: liveFeed ?? this.liveFeed,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, stats, liveFeed, error];
}
