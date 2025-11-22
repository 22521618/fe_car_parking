import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Theme.of(context).cardTheme.color,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Car Parking',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
          const SizedBox(height: 32),
          _buildNavItem(context, 0, Icons.dashboard, 'Dashboard'),
          _buildNavItem(context, 1, Icons.people, 'Residents'),
          _buildNavItem(context, 2, Icons.directions_car, 'Vehicles'),
          _buildNavItem(context, 3, Icons.history, 'Parking History'),
          _buildNavItem(context, 4, Icons.security, 'Access Logs'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? colorScheme.primary : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? colorScheme.primary : Colors.grey,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor:
          colorScheme.primary.withAlpha(26), // approx 0.1 opacity
      onTap: () => onItemSelected(index),
    );
  }
}
