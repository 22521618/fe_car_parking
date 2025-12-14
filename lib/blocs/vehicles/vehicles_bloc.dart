import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/api_client.dart';
import '../../core/constants.dart';
import '../../models/vehicle.dart';
import '../../models/resident.dart';
import 'vehicles_event.dart';
import 'vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final ApiClient apiClient;

  VehiclesBloc({required this.apiClient}) : super(const VehiclesState()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<LoadResidents>(_onLoadResidents);
    on<RegisterVehicle>(_onRegisterVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<DeleteVehicle>(_onDeleteVehicle);
  }

  Future<void> _onLoadVehicles(
    LoadVehicles event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(state.copyWith(status: VehiclesStatus.loading));
    try {
      final queryParams = <String, dynamic>{};
      if (event.licensePlate != null && event.licensePlate!.isNotEmpty) {
        queryParams['licensePlate'] = event.licensePlate;
      }

      final response = await apiClient.get(
        AppConstants.vehiclesEndpoint,
        queryParameters: queryParams,
      );
      final List<dynamic> data = response.data;
      final vehicles = data.map((json) => Vehicle.fromJson(json)).toList();
      emit(state.copyWith(status: VehiclesStatus.loaded, vehicles: vehicles));
    } catch (e) {
      emit(state.copyWith(status: VehiclesStatus.error, error: e.toString()));
    }
  }

  Future<void> _onLoadResidents(
    LoadResidents event,
    Emitter<VehiclesState> emit,
  ) async {
    // Keep current status or set to loading if you want global loading indicator
    // But usually loading residents is a background thing or secondary
    try {
      final response = await apiClient.get(
        AppConstants.residentsEndpoint,
      );
      final List<dynamic> data = response.data;
      final residents = data.map((json) => Resident.fromJson(json)).toList();
      emit(state.copyWith(residents: residents));
    } catch (e) {
      // Handle error purely for residents if needed, or just log
      print('Error loading residents: $e');
    }
  }

  Future<void> _onRegisterVehicle(
    RegisterVehicle event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(state.copyWith(status: VehiclesStatus.loading));
    try {
      final data = event.vehicle.toJson();
      data.remove('_id');

      await apiClient.post(AppConstants.vehiclesEndpoint, data: data);
      add(const LoadVehicles()); // Reload list
    } catch (e) {
      emit(state.copyWith(status: VehiclesStatus.error, error: e.toString()));
    }
  }

  Future<void> _onUpdateVehicle(
    UpdateVehicle event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(state.copyWith(status: VehiclesStatus.loading));
    try {
      final data = event.vehicle.toJson();
      data.remove('_id');

      await apiClient.patch(
        '${AppConstants.vehiclesEndpoint}/${event.vehicle.id}',
        data: data,
      );
      add(const LoadVehicles()); // Reload list
    } catch (e) {
      emit(state.copyWith(status: VehiclesStatus.error, error: e.toString()));
    }
  }

  Future<void> _onDeleteVehicle(
    DeleteVehicle event,
    Emitter<VehiclesState> emit,
  ) async {
    emit(state.copyWith(status: VehiclesStatus.loading));
    try {
      await apiClient.delete(
        '${AppConstants.vehiclesEndpoint}/${event.id}',
      );
      add(const LoadVehicles()); // Reload list
    } catch (e) {
      emit(state.copyWith(status: VehiclesStatus.error, error: e.toString()));
    }
  }
}
