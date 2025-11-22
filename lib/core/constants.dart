class AppConstants {
  // Base URL for the API
  // Using 10.0.2.2 for Android Emulator, localhost for iOS/Web
  // static const String baseUrl = 'http://10.0.2.2:3000';
  static const String baseUrl = 'http://localhost:3000';

  // API Endpoints
  static const String residentsEndpoint = '/residents';
  static const String vehiclesEndpoint = '/vehicles';
  static const String parkingSessionsEndpoint = '/parking-sessions';
  static const String parkingStatsEndpoint = '/parking-sessions/stats';
  static const String accessLogsEndpoint = '/access-logs';
  static const String accessLogStatsEndpoint = '/access-logs/stats';
  static const String dashboardSummaryEndpoint = '/dashboard/summary';

  // WebSocket Events
  static const String socketUrl = baseUrl;
  static const String eventLiveFeed = 'parking/live-feed';
  static const String eventDashboardStats = 'dashboard/stats';
  static const String eventAlert = 'parking/alert';
}
