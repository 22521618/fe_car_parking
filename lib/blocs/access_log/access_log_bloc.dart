import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/api_client.dart';
import '../../core/constants.dart';
import '../../models/access_log.dart';
import 'access_log_event.dart';
import 'access_log_state.dart';

class AccessLogBloc extends Bloc<AccessLogEvent, AccessLogState> {
  final ApiClient apiClient;

  AccessLogBloc({required this.apiClient}) : super(const AccessLogState()) {
    on<LoadAccessLogs>(_onLoadAccessLogs);
  }

  Future<void> _onLoadAccessLogs(
    LoadAccessLogs event,
    Emitter<AccessLogState> emit,
  ) async {
    emit(state.copyWith(status: AccessLogStatus.loading));
    try {
      final queryParams = <String, dynamic>{};
      if (event.licensePlate != null && event.licensePlate!.isNotEmpty) {
        queryParams['licensePlate'] = event.licensePlate;
      }
      if (event.raspberryPiId != null && event.raspberryPiId!.isNotEmpty) {
        queryParams['raspberryPiId'] = event.raspberryPiId;
      }
      if (event.isAuthorized != null) {
        queryParams['isAuthorized'] = event.isAuthorized;
      }
      if (event.from != null) {
        queryParams['from'] = event.from!.toIso8601String();
      }
      if (event.to != null) {
        queryParams['to'] = event.to!.toIso8601String();
      }

      final response = await apiClient.get(
        AppConstants.accessLogsEndpoint,
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      final logs = data.map((json) => AccessLog.fromJson(json)).toList();
      emit(state.copyWith(status: AccessLogStatus.loaded, logs: logs));
    } catch (e) {
      emit(state.copyWith(status: AccessLogStatus.error, error: e.toString()));
    }
  }
}
