import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:intl/intl.dart';
import '../blocs/access_log/access_log_bloc.dart';
import '../blocs/access_log/access_log_event.dart';
import '../blocs/access_log/access_log_state.dart';

class AccessLogsScreen extends StatefulWidget {
  const AccessLogsScreen({super.key});

  @override
  State<AccessLogsScreen> createState() => _AccessLogsScreenState();
}

class _AccessLogsScreenState extends State<AccessLogsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AccessLogBloc>().add(const LoadAccessLogs());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Access Logs',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocBuilder<AccessLogBloc, AccessLogState>(
                builder: (context, state) {
                  if (state.status == AccessLogStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == AccessLogStatus.error) {
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
                          DataColumn(label: Text('Card ID')),
                          DataColumn(label: Text('Action')),
                          DataColumn(label: Text('Timestamp')),
                          DataColumn(label: Text('Pi ID')),
                          DataColumn(label: Text('Authorized')),
                          DataColumn(label: Text('Response')),
                          DataColumn(label: Text('Image')),
                        ],
                        rows: state.logs.map((log) {
                          final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
                          return DataRow(cells: [
                            DataCell(Text(log.licensePlate,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold))),
                            DataCell(Text(log.cardId ?? '-')),
                            DataCell(Text(log.action.toUpperCase())),
                            DataCell(Text(dateFormat.format(log.timestamp))),
                            DataCell(Text(log.raspberryPiId)),
                            DataCell(
                              Icon(
                                log.isAuthorized
                                    ? Icons.check_circle
                                    : Icons.cancel,
                                color: log.isAuthorized
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            DataCell(Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: log.responseStatus == 'allowed'
                                    ? Colors.green.withAlpha(26)
                                    : Colors.red.withAlpha(26),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                log.responseStatus,
                                style: TextStyle(
                                  color: log.responseStatus == 'allowed'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            )),
                            DataCell(
                              log.image != null
                                  ? IconButton(
                                      icon: const Icon(Icons.image),
                                      onPressed: () =>
                                          _showImage(context, log.image!),
                                    )
                                  : const SizedBox(),
                            ),
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
