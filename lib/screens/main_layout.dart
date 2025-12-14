import 'package:flutter/material.dart';

import '../widgets/sidebar.dart';
import 'dashboard_screen.dart';
import 'residents_screen.dart';
import 'vehicles_screen.dart';
import 'parking_history_screen.dart';
import 'access_logs_screen.dart';
import 'realtime_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ResidentsScreen(),
    const VehiclesScreen(),
    const RealtimeScreen(),
    const ParkingHistoryScreen(),
    const AccessLogsScreen(),
  ];

  final List<String> _titles = const [
    'Dashboard',
    'Residents',
    'Vehicles',
    'Live Monitor',
    'Parking History',
    'Access Logs',
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 900;

        if (isWeb) {
          return Scaffold(
            body: Row(
              children: [
                Sidebar(
                  selectedIndex: _selectedIndex,
                  onItemSelected: _onItemSelected,
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.all(32),
                    child: _screens[_selectedIndex],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(_titles[_selectedIndex]),
              backgroundColor: Theme.of(context).colorScheme.surface,
            ),
            drawer: Drawer(
              child: Sidebar(
                selectedIndex: _selectedIndex,
                onItemSelected: (index) {
                  _onItemSelected(index);
                  Navigator.pop(context); // Close drawer
                },
              ),
            ),
            body: Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.all(16),
              child: _screens[_selectedIndex],
            ),
          );
        }
      },
    );
  }
}
