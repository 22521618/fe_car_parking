import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/api_client.dart';
import '../../core/constants.dart';
import '../../core/socket_service.dart';
import '../../models/dashboard_stats.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final ApiClient apiClient;
  final SocketService socketService;

  DashboardBloc({required this.apiClient, required this.socketService})
      : super(const DashboardState()) {
    on<LoadDashboardStats>(_onLoadDashboardStats);
    on<UpdateDashboardStats>(_onUpdateDashboardStats);
    on<DashboardLiveFeedReceived>(_onDashboardLiveFeedReceived);

    // Listen to socket events
    socketService.on(AppConstants.eventDashboardStats, (data) {
      add(UpdateDashboardStats(data));
    });

    socketService.on(AppConstants.eventLiveFeed, (data) {
      add(DashboardLiveFeedReceived(data));
    });
  }

  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<DashboardState> emit,
  ) async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final response =
          await apiClient.get(AppConstants.dashboardSummaryEndpoint);
      final stats = DashboardStats.fromJson(response.data);
      emit(state.copyWith(status: DashboardStatus.loaded, stats: stats));
    } catch (e) {
      emit(state.copyWith(status: DashboardStatus.error, error: e.toString()));
    }
  }

  void _onUpdateDashboardStats(
    UpdateDashboardStats event,
    Emitter<DashboardState> emit,
  ) {
    if (state.stats != null) {
      // Update active sessions count from socket
      final newActiveSessions = event.data['activeSessions'];
      if (newActiveSessions != null) {
        final updatedStats = DashboardStats(
          totalResidents: state.stats!.totalResidents,
          totalVehicles: state.stats!.totalVehicles,
          activeSessions: newActiveSessions,
          todayStats: state.stats!.todayStats,
        );
        emit(state.copyWith(stats: updatedStats));
      }
    }
  }

  void _onDashboardLiveFeedReceived(
    DashboardLiveFeedReceived event,
    Emitter<DashboardState> emit,
  ) {
    final currentFeed = List<Map<String, dynamic>>.from(state.liveFeed);
    currentFeed.insert(0, event.feedData);
    if (currentFeed.length > 10) {
      currentFeed.removeLast(); // Keep only last 10 items
    }
    emit(state.copyWith(liveFeed: currentFeed));
  }
}
