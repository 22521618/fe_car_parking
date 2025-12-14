import 'package:equatable/equatable.dart';
import '../../models/vehicle.dart';

abstract class VehiclesEvent extends Equatable {
  const VehiclesEvent();

  @override
  List<Object> get props => [];
}

class LoadVehicles extends VehiclesEvent {
  final String? licensePlate;

  const LoadVehicles({this.licensePlate});

  @override
  List<Object> get props => [licensePlate ?? ''];
}

class LoadResidents extends VehiclesEvent {
  const LoadResidents();
}

class RegisterVehicle extends VehiclesEvent {
  final Vehicle vehicle;

  const RegisterVehicle(this.vehicle);

  @override
  List<Object> get props => [vehicle];
}

class UpdateVehicle extends VehiclesEvent {
  final Vehicle vehicle;

  const UpdateVehicle(this.vehicle);

  @override
  List<Object> get props => [vehicle];
}

class DeleteVehicle extends VehiclesEvent {
  final String id;

  const DeleteVehicle(this.id);

  @override
  List<Object> get props => [id];
}
