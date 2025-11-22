import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardStats extends DashboardEvent {}

class UpdateDashboardStats extends DashboardEvent {
  final Map<String, dynamic> data;

  const UpdateDashboardStats(this.data);

  @override
  List<Object> get props => [data];
}

class DashboardLiveFeedReceived extends DashboardEvent {
  final Map<String, dynamic> feedData;

  const DashboardLiveFeedReceived(this.feedData);

  @override
  List<Object> get props => [feedData];
}
