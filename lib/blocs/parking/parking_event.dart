import 'package:equatable/equatable.dart';

abstract class ParkingEvent extends Equatable {
  const ParkingEvent();

  @override
  List<Object> get props => [];
}

class LoadParkingSessions extends ParkingEvent {
  final String? licensePlate;
  final String? residentId;
  final DateTime? from;
  final DateTime? to;

  const LoadParkingSessions({
    this.licensePlate,
    this.residentId,
    this.from,
    this.to,
  });

  @override
  List<Object> get props => [
        licensePlate ?? '',
        residentId ?? '',
        from ?? DateTime(0),
        to ?? DateTime(0)
      ];
}

class LoadParkingStats extends ParkingEvent {}
