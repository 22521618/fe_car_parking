import 'package:equatable/equatable.dart';
import '../../models/vehicle.dart';

enum VehiclesStatus { initial, loading, loaded, error }

class VehiclesState extends Equatable {
  final VehiclesStatus status;
  final List<Vehicle> vehicles;
  final String? error;

  const VehiclesState({
    this.status = VehiclesStatus.initial,
    this.vehicles = const [],
    this.error,
  });

  VehiclesState copyWith({
    VehiclesStatus? status,
    List<Vehicle>? vehicles,
    String? error,
  }) {
    return VehiclesState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, vehicles, error];
}
