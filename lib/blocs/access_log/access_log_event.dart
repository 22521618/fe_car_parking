import 'package:equatable/equatable.dart';

abstract class AccessLogEvent extends Equatable {
  const AccessLogEvent();

  @override
  List<Object> get props => [];
}

class LoadAccessLogs extends AccessLogEvent {
  final String? licensePlate;
  final String? raspberryPiId;
  final bool? isAuthorized;
  final DateTime? from;
  final DateTime? to;

  const LoadAccessLogs({
    this.licensePlate,
    this.raspberryPiId,
    this.isAuthorized,
    this.from,
    this.to,
  });

  @override
  List<Object> get props => [
        licensePlate ?? '',
        raspberryPiId ?? '',
        isAuthorized ?? '',
        from ?? DateTime(0),
        to ?? DateTime(0)
      ];
}
