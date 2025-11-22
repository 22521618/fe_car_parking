import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import '../blocs/parking/parking_bloc.dart';
import '../blocs/parking/parking_event.dart';
import '../blocs/parking/parking_state.dart';

class ParkingHistoryScreen extends StatefulWidget {
  const ParkingHistoryScreen({super.key});

  @override
  State<ParkingHistoryScreen> createState() => _ParkingHistoryScreenState();
}

class _ParkingHistoryScreenState extends State<ParkingHistoryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ParkingBloc>().add(const LoadParkingSessions());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parking History',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<ParkingBloc, ParkingState>(
                builder: (context, state) {
                  if (state.status == ParkingStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == ParkingStatus.error) {
                    return Center(child: Text('Error: ${state.error}'));
                  }

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: DataTable2(
                        columnSpacing: 12,
                        horizontalMargin: 12,
                        minWidth: 900, // Ensure scrolling on small screens
                        columns: const [
                          DataColumn2(
                              label: Text('License Plate'), size: ColumnSize.L),
                          DataColumn(label: Text('Resident')),
                          DataColumn(label: Text('Entry Time')),
                          DataColumn(label: Text('Exit Time')),
                          DataColumn(label: Text('Duration (min)')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Images')),
                        ],
                        rows: state.sessions.map((session) {
                          final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
                          return DataRow(cells: [
                            DataCell(Text(session.licensePlate,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                            DataCell(
                                Text(session.resident?.fullName ?? 'Unknown')),
                            DataCell(
                                Text(dateFormat.format(session.entryTime))),
                            DataCell(Text(session.exitTime != null
                                ? dateFormat.format(session.exitTime!)
                                : '-')),
                            DataCell(Text(session.duration?.toString() ?? '-')),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: session.status == 'completed'
                                      ? Colors.green.withAlpha(26)
                                      : Colors.blue.withAlpha(26),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  session.status,
                                  style: TextStyle(
                                    color: session.status == 'completed'
                                        ? Colors.green
                                        : Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            DataCell(Row(
                              children: [
                                if (session.entryImage != null)
                                  IconButton(
                                    icon: const Icon(Icons.image),
                                    onPressed: () => _showImage(
                                        context, session.entryImage!),
                                    tooltip: 'Entry Image',
                                  ),
                                if (session.exitImage != null)
                                  IconButton(
                                    icon: const Icon(Icons.image_outlined),
                                    onPressed: () =>
                                        _showImage(context, session.exitImage!),
                                    tooltip: 'Exit Image',
                                  ),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showImage(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.network(url),
      ),
    );
  }
}
