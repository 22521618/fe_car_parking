import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart'; // Unused
import '../../core/api_client.dart';
import '../../core/constants.dart';
import '../../models/parking_session.dart';
import 'parking_event.dart';
import 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ApiClient apiClient;

  ParkingBloc({required this.apiClient}) : super(const ParkingState()) {
    on<LoadParkingSessions>(_onLoadParkingSessions);
    on<LoadParkingStats>(_onLoadParkingStats);
  }

  Future<void> _onLoadParkingSessions(
    LoadParkingSessions event,
    Emitter<ParkingState> emit,
  ) async {
    emit(state.copyWith(status: ParkingStatus.loading));
    try {
      final queryParams = <String, dynamic>{};
      if (event.licensePlate != null && event.licensePlate!.isNotEmpty) {
        queryParams['licensePlate'] = event.licensePlate;
      }
      if (event.residentId != null && event.residentId!.isNotEmpty) {
        queryParams['residentId'] = event.residentId;
      }
      if (event.from != null) {
        queryParams['from'] = event.from!.toIso8601String();
      }
      if (event.to != null) {
        queryParams['to'] = event.to!.toIso8601String();
      }

      final response = await apiClient.get(
        AppConstants.parkingSessionsEndpoint,
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      final sessions =
          data.map((json) => ParkingSession.fromJson(json)).toList();
      emit(state.copyWith(status: ParkingStatus.loaded, sessions: sessions));
    } catch (e) {
      emit(state.copyWith(status: ParkingStatus.error, error: e.toString()));
    }
  }

  Future<void> _onLoadParkingStats(
    LoadParkingStats event,
    Emitter<ParkingState> emit,
  ) async {
    // We don't set loading here to avoid flickering if sessions are already loaded
    // or we can handle it separately. For now, let's just fetch.
    try {
      final response = await apiClient.get(AppConstants.parkingStatsEndpoint);
      final List<dynamic> data = response.data;
      final stats = data.cast<Map<String, dynamic>>();
      emit(state.copyWith(stats: stats));
    } catch (e) {
      // Silently fail or show error?
      debugPrint('Error loading parking stats: $e');
    }
  }
}
