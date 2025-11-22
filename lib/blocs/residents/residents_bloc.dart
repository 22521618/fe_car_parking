import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/api_client.dart';
import '../../core/constants.dart';
import '../../models/resident.dart';
import 'residents_event.dart';
import 'residents_state.dart';

class ResidentsBloc extends Bloc<ResidentsEvent, ResidentsState> {
  final ApiClient apiClient;

  ResidentsBloc({required this.apiClient}) : super(const ResidentsState()) {
    on<LoadResidents>(_onLoadResidents);
    on<CreateResident>(_onCreateResident);
    on<UpdateResident>(_onUpdateResident);
    on<DeleteResident>(_onDeleteResident);
  }

  Future<void> _onLoadResidents(
    LoadResidents event,
    Emitter<ResidentsState> emit,
  ) async {
    emit(state.copyWith(status: ResidentsStatus.loading));
    try {
      final queryParams = <String, dynamic>{};
      if (event.fullName != null && event.fullName!.isNotEmpty) {
        queryParams['fullName'] = event.fullName;
      }
      if (event.apartmentNumber != null && event.apartmentNumber!.isNotEmpty) {
        queryParams['apartmentNumber'] = event.apartmentNumber;
      }

      final response = await apiClient.get(
        AppConstants.residentsEndpoint,
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      final residents = data.map((json) => Resident.fromJson(json)).toList();
      emit(
          state.copyWith(status: ResidentsStatus.loaded, residents: residents));
    } catch (e) {
      emit(state.copyWith(status: ResidentsStatus.error, error: e.toString()));
    }
  }

  Future<void> _onCreateResident(
    CreateResident event,
    Emitter<ResidentsState> emit,
  ) async {
    emit(state.copyWith(status: ResidentsStatus.loading));
    try {
      // Remove ID and dates for creation if they are default/empty
      final data = event.resident.toJson();
      data.remove('_id');
      data.remove('createdAt');
      data.remove('updatedAt');

      await apiClient.post(AppConstants.residentsEndpoint, data: data);
      add(const LoadResidents()); // Reload list
    } catch (e) {
      emit(state.copyWith(status: ResidentsStatus.error, error: e.toString()));
    }
  }

  Future<void> _onUpdateResident(
    UpdateResident event,
    Emitter<ResidentsState> emit,
  ) async {
    emit(state.copyWith(status: ResidentsStatus.loading));
    try {
      final data = event.resident.toJson();
      data.remove('_id');
      data.remove('createdAt');
      data.remove('updatedAt');

      await apiClient.patch(
        '${AppConstants.residentsEndpoint}/${event.resident.id}',
        data: data,
      );
      add(const LoadResidents()); // Reload list
    } catch (e) {
      emit(state.copyWith(status: ResidentsStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDeleteResident(
    DeleteResident event,
    Emitter<ResidentsState> emit,
  ) async {
    emit(state.copyWith(status: ResidentsStatus.loading));
    try {
      await apiClient.delete(
        '${AppConstants.residentsEndpoint}/${event.id}',
      );
      add(const LoadResidents()); // Reload list
    } catch (e) {
      emit(state.copyWith(status: ResidentsStatus.error, error: e.toString()));
    }
  }
}
