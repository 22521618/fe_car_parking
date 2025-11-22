import 'package:equatable/equatable.dart';
import '../../models/resident.dart';

abstract class ResidentsEvent extends Equatable {
  const ResidentsEvent();

  @override
  List<Object> get props => [];
}

class LoadResidents extends ResidentsEvent {
  final String? fullName;
  final String? apartmentNumber;

  const LoadResidents({this.fullName, this.apartmentNumber});

  @override
  List<Object> get props => [fullName ?? '', apartmentNumber ?? ''];
}

class CreateResident extends ResidentsEvent {
  final Resident resident;

  const CreateResident(this.resident);

  @override
  List<Object> get props => [resident];
}

class UpdateResident extends ResidentsEvent {
  final Resident resident;

  const UpdateResident(this.resident);

  @override
  List<Object> get props => [resident];
}

class DeleteResident extends ResidentsEvent {
  final String id;

  const DeleteResident(this.id);

  @override
  List<Object> get props => [id];
}
