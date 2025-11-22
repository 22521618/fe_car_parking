import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../blocs/dashboard/dashboard_bloc.dart';
import '../blocs/dashboard/dashboard_state.dart';
import '../models/dashboard_stats.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state.status == DashboardStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == DashboardStatus.error) {
          return Center(child: Text('Error: ${state.error}'));
        }

        final stats = state.stats;
        if (stats == null) {
          return const Center(child: Text('No data available'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 900;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isWide)
                    Text(
                      'Dashboard Overview',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                    ),
                  const SizedBox(height: 24),
                  _buildStatsGrid(context, stats, isWide),
                  const SizedBox(height: 32),
                  if (isWide)
                    SizedBox(
                      height: 400,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: _LiveFeedSection(feed: state.liveFeed),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 1,
                            child: _ChartSection(stats: stats),
                          ),
                        ],
                      ),
                    )
                  else
                    Column(
                      children: [
                        SizedBox(
                          height: 400,
                          child: _LiveFeedSection(feed: state.liveFeed),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 300,
                          child: _ChartSection(stats: stats),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatsGrid(
      BuildContext context, DashboardStats stats, bool isWide) {
    final cards = [
      _StatCard(
        title: 'Total Residents',
        value: stats.totalResidents.toString(),
        icon: Icons.people_outline,
        color: Colors.blue,
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _StatCard(
        title: 'Total Vehicles',
        value: stats.totalVehicles.toString(),
        icon: Icons.directions_car_outlined,
        color: Colors.orange,
        gradient: const LinearGradient(
          colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _StatCard(
        title: 'Active Sessions',
        value: stats.activeSessions.toString(),
        icon: Icons.local_parking,
        color: Colors.green,
        gradient: const LinearGradient(
          colors: [Color(0xFF10B981), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      _StatCard(
        title: 'Today Entries/Exits',
        value: '${stats.todayStats.entries} / ${stats.todayStats.exits}',
        icon: Icons.compare_arrows,
        color: Colors.purple,
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];

    if (isWide) {
      return SizedBox(
        height: 160,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: cards
              .map((card) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: card,
                    ),
                  ))
              .toList()
            ..last = Expanded(
                child: cards
                    .last), // Remove padding from last item logic adjustment needed but Row handles it
        ),
      );
    } else {
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.3,
        children: cards,
      );
    }
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Gradient gradient;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if space is tight (e.g. on mobile grid)
        final isTight = constraints.maxHeight < 160;
        final padding = isTight ? 12.0 : 20.0;
        final iconSize = isTight ? 24.0 : 32.0;
        final titleStyle = isTight
            ? Theme.of(context).textTheme.titleSmall
            : Theme.of(context).textTheme.titleMedium;
        final valueStyle = isTight
            ? Theme.of(context).textTheme.headlineSmall
            : Theme.of(context).textTheme.headlineMedium;

        return Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icon, color: Colors.white, size: iconSize),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward,
                          color: Colors.white, size: 16),
                    ),
                  ],
                ),
                SizedBox(height: isTight ? 8 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          style: valueStyle?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          title,
                          style: titleStyle?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LiveFeedSection extends StatelessWidget {
  final List<Map<String, dynamic>> feed;

  const _LiveFeedSection({required this.feed});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Live Feed',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: feed.length,
                itemBuilder: (context, index) {
                  final item = feed[index];
                  final isEntry = item['type'] == 'entry';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isEntry
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.red.withValues(alpha: 0.1),
                        child: Icon(
                          isEntry ? Icons.login : Icons.logout,
                          color: isEntry ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(
                        '${item['licensePlate']} - ${item['residentName'] ?? 'Unknown'}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(item['timestamp'] ?? ''),
                      trailing: item['image'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image,
                                        color: Colors.grey),
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartSection extends StatelessWidget {
  final DashboardStats stats;

  const _ChartSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: stats.todayStats.entries.toDouble(),
                      title: '${stats.todayStats.entries}',
                      titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      color: const Color(0xFF10B981), // Emerald
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: stats.todayStats.exits.toDouble(),
                      title: '${stats.todayStats.exits}',
                      titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      color: const Color(0xFFEF4444), // Red
                      radius: 60,
                    ),
                  ],
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ChartLegend(color: Color(0xFF10B981), label: 'Entries'),
                SizedBox(width: 16),
                _ChartLegend(color: Color(0xFFEF4444), label: 'Exits'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
