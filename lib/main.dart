import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/api_client.dart';
import 'core/socket_service.dart';
import 'core/theme.dart';
import 'blocs/dashboard/dashboard_bloc.dart';
import 'blocs/residents/residents_bloc.dart';
import 'blocs/vehicles/vehicles_bloc.dart';
import 'blocs/parking/parking_bloc.dart';
import 'blocs/access_log/access_log_bloc.dart';
import 'screens/main_layout.dart';

void main() {
  // Initialize services
  final apiClient = ApiClient();
  final socketService = SocketService();
  socketService.init();

  runApp(MyApp(
    apiClient: apiClient,
    socketService: socketService,
  ));
}

class MyApp extends StatelessWidget {
  final ApiClient apiClient;
  final SocketService socketService;

  const MyApp({
    super.key,
    required this.apiClient,
    required this.socketService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardBloc(
            apiClient: apiClient,
            socketService: socketService,
          ),
        ),
        BlocProvider(
          create: (context) => ResidentsBloc(apiClient: apiClient),
        ),
        BlocProvider(
          create: (context) => VehiclesBloc(apiClient: apiClient),
        ),
        BlocProvider(
          create: (context) => ParkingBloc(apiClient: apiClient),
        ),
        BlocProvider(
          create: (context) => AccessLogBloc(apiClient: apiClient),
        ),
      ],
      child: MaterialApp(
        title: 'Car Parking System',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const MainLayout(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
