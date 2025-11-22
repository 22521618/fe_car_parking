class DashboardStats {
  final int totalResidents;
  final int totalVehicles;
  final int activeSessions;
  final TodayStats todayStats;

  DashboardStats({
    required this.totalResidents,
    required this.totalVehicles,
    required this.activeSessions,
    required this.todayStats,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalResidents: json['totalResidents'] ?? 0,
      totalVehicles: json['totalVehicles'] ?? 0,
      activeSessions: json['activeSessions'] ?? 0,
      todayStats: TodayStats.fromJson(json['todayStats'] ?? {}),
    );
  }
}

class TodayStats {
  final int entries;
  final int exits;

  TodayStats({
    required this.entries,
    required this.exits,
  });

  factory TodayStats.fromJson(Map<String, dynamic> json) {
    return TodayStats(
      entries: json['entries'] ?? 0,
      exits: json['exits'] ?? 0,
    );
  }
}
