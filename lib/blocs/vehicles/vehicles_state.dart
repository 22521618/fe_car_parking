import 'package:equatable/equatable.dart';
import '../../models/vehicle.dart';
import '../../models/resident.dart';

enum VehiclesStatus { initial, loading, loaded, error }

class VehiclesState extends Equatable {
  final VehiclesStatus status;
  final List<Vehicle> vehicles;
  final List<Resident> residents;
  final String? error;

  const VehiclesState({
    this.status = VehiclesStatus.initial,
    this.vehicles = const [],
    this.residents = const [],
    this.error,
  });

  VehiclesState copyWith({
    VehiclesStatus? status,
    List<Vehicle>? vehicles,
    List<Resident>? residents,
    String? error,
  }) {
    return VehiclesState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      residents: residents ?? this.residents,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, vehicles, residents, error];
}
