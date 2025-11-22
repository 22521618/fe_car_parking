import 'package:equatable/equatable.dart';
import '../../models/resident.dart';

enum ResidentsStatus { initial, loading, loaded, error }

class ResidentsState extends Equatable {
  final ResidentsStatus status;
  final List<Resident> residents;
  final String? error;

  const ResidentsState({
    this.status = ResidentsStatus.initial,
    this.residents = const [],
    this.error,
  });

  ResidentsState copyWith({
    ResidentsStatus? status,
    List<Resident>? residents,
    String? error,
  }) {
    return ResidentsState(
      status: status ?? this.status,
      residents: residents ?? this.residents,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, residents, error];
}
